// vol-mount-guard
//
// The counterpart to vol-unmount-guard: a Disk Arbitration daemon that watches
// for one or more named volumes to be *mounted* and runs a start script when
// they appear. The start script receives the mount point as $1, so it can cd
// into the volume and launch whatever service lives there.
//
// Volumes already mounted when this daemon starts also trigger the script
// (via the disk-appeared callback), so a reboot with the volume attached
// still brings the service up.
//
// Usage:
//   vol-mount-guard [--start-script PATH] VOLUME [VOLUME ...]
//
//   VOLUME          Volume name as it appears under /Volumes/ (match by name,
//                   so it survives remounts / changing disk numbers).
//   --start-script  Script to run after a mount; invoked as: script MOUNTPOINT
//                   Default: <dir of this binary>/start.sh
//
// Build:
//   clang -O2 -o vol-mount-guard vol-mount-guard.c \
//       -framework DiskArbitration -framework CoreFoundation
//
#include <DiskArbitration/DiskArbitration.h>
#include <CoreFoundation/CoreFoundation.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <libgen.h>
#include <limits.h>
#include <mach-o/dyld.h>
#include <time.h>
#include <unistd.h>
#include <sys/wait.h>

// --- runtime config (populated from argv) ---------------------------------
#define MAX_TARGETS 64
static const char *g_targets[MAX_TARGETS]; // volume names to guard
static int g_mounted[MAX_TARGETS];         // last known mount state per target
static int g_target_count = 0;
static char g_start_script[PATH_MAX] = {0};
// --------------------------------------------------------------------------

static void stamp(const char *msg, const char *extra) {
    time_t t = time(NULL);
    char buf[32];
    strftime(buf, sizeof(buf), "%Y-%m-%d %H:%M:%S", localtime(&t));
    if (extra)
        fprintf(stderr, "%s [vol-mount-guard] %s %s\n", buf, msg, extra);
    else
        fprintf(stderr, "%s [vol-mount-guard] %s\n", buf, msg);
    fflush(stderr);
}

static int target_index(const char *name) {
    for (int i = 0; i < g_target_count; i++)
        if (strcmp(name, g_targets[i]) == 0) return i;
    return -1;
}

// Default the start script to a sibling of this executable, so a relocated
// install still finds it without a flag.
static void default_start_script(void) {
    char exe[PATH_MAX];
    uint32_t sz = sizeof(exe);
    if (_NSGetExecutablePath(exe, &sz) == 0) {
        char real[PATH_MAX];
        if (realpath(exe, real)) {
            snprintf(g_start_script, sizeof(g_start_script), "%s/start.sh",
                     dirname(real));
            return;
        }
    }
    snprintf(g_start_script, sizeof(g_start_script), "./start.sh");
}

// fork/exec instead of system() so the mount point never goes through a
// shell — /Volumes paths routinely contain spaces.
static void run_start_script(const char *mountpoint) {
    pid_t pid = fork();
    if (pid < 0) {
        stamp("ERROR: fork failed", NULL);
        return;
    }
    if (pid == 0) {
        execl(g_start_script, g_start_script, mountpoint, (char *)NULL);
        _exit(127); // execl only returns on error
    }
    int status = 0;
    waitpid(pid, &status, 0);
    char rcbuf[64];
    if (WIFEXITED(status))
        snprintf(rcbuf, sizeof(rcbuf), "exit=%d", WEXITSTATUS(status));
    else
        snprintf(rcbuf, sizeof(rcbuf), "signal=%d", WTERMSIG(status));
    stamp("start script finished", rcbuf);
}

// Shared by both callbacks: look at the disk's current description and fire
// the start script on an unmounted -> mounted transition for a target volume.
// The g_mounted flags make duplicate notifications for one mount harmless.
static void check_disk(DADiskRef disk) {
    CFDictionaryRef desc = DADiskCopyDescription(disk);
    if (!desc) return;

    CFStringRef nameRef =
        CFDictionaryGetValue(desc, kDADiskDescriptionVolumeNameKey);
    char name[512] = {0};
    if (nameRef)
        CFStringGetCString(nameRef, name, sizeof(name), kCFStringEncodingUTF8);

    int idx = name[0] ? target_index(name) : -1;
    if (idx < 0) {
        CFRelease(desc);
        return;
    }

    CFURLRef pathRef =
        CFDictionaryGetValue(desc, kDADiskDescriptionVolumePathKey);
    char mountpoint[PATH_MAX] = {0};
    if (pathRef &&
        CFURLGetFileSystemRepresentation(pathRef, true, (UInt8 *)mountpoint,
                                         sizeof(mountpoint))) {
        if (!g_mounted[idx]) {
            g_mounted[idx] = 1;
            stamp("volume mounted; running start script for", mountpoint);
            run_start_script(mountpoint);
        }
    } else {
        if (g_mounted[idx]) {
            g_mounted[idx] = 0;
            stamp("volume unmounted:", name);
        }
    }
    CFRelease(desc);
}

// Fires once per disk already present at registration time, and again for
// newly attached disks. Catches the "already mounted at daemon start" case.
static void on_disk_appeared(DADiskRef disk, void *context) {
    (void)context;
    check_disk(disk);
}

// Fires when a watched description key changes; we watch the volume-path key,
// which goes NULL -> /Volumes/... on mount (and back to NULL on unmount).
static void on_description_changed(DADiskRef disk, CFArrayRef keys,
                                   void *context) {
    (void)keys;
    (void)context;
    check_disk(disk);
}

static void usage(const char *argv0) {
    fprintf(stderr,
            "usage: %s [--start-script PATH] VOLUME [VOLUME ...]\n"
            "  VOLUME          volume name under /Volumes/ (matched by name)\n"
            "  --start-script  script run after a mount, invoked with the\n"
            "                  mount point as $1\n"
            "                  (default: <binary dir>/start.sh)\n",
            argv0);
}

int main(int argc, char **argv) {
    default_start_script();

    for (int i = 1; i < argc; i++) {
        if ((strcmp(argv[i], "--start-script") == 0 ||
             strcmp(argv[i], "-s") == 0)) {
            if (i + 1 >= argc) { usage(argv[0]); return 2; }
            snprintf(g_start_script, sizeof(g_start_script), "%s", argv[++i]);
        } else if (strcmp(argv[i], "-h") == 0 ||
                   strcmp(argv[i], "--help") == 0) {
            usage(argv[0]);
            return 0;
        } else {
            if (g_target_count < MAX_TARGETS)
                g_targets[g_target_count++] = argv[i];
        }
    }

    if (g_target_count == 0) {
        usage(argv[0]);
        return 2;
    }

    DASessionRef session = DASessionCreate(kCFAllocatorDefault);
    if (!session) {
        stamp("FATAL: could not create Disk Arbitration session", NULL);
        return 1;
    }

    // Watch only volume-path changes (i.e. mount/unmount transitions).
    CFStringRef watchKey = kDADiskDescriptionVolumePathKey;
    CFArrayRef watchKeys = CFArrayCreate(
        kCFAllocatorDefault, (const void **)&watchKey, 1,
        &kCFTypeArrayCallBacks);

    DARegisterDiskAppearedCallback(session, NULL /*match all*/,
                                   on_disk_appeared, NULL);
    DARegisterDiskDescriptionChangedCallback(session, NULL /*match all*/,
                                             watchKeys, on_description_changed,
                                             NULL);
    CFRelease(watchKeys);

    DASessionScheduleWithRunLoop(session, CFRunLoopGetCurrent(),
                                 kCFRunLoopDefaultMode);

    for (int i = 0; i < g_target_count; i++)
        stamp("watching for mount of", g_targets[i]);
    stamp("start script:", g_start_script);

    CFRunLoopRun();

    DAUnregisterCallback(session, on_disk_appeared, NULL);
    DAUnregisterCallback(session, on_description_changed, NULL);
    DASessionUnscheduleFromRunLoop(session, CFRunLoopGetCurrent(),
                                   kCFRunLoopDefaultMode);
    CFRelease(session);
    return 0;
}
