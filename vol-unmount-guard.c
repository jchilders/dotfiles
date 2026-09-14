// vol-unmount-guard
//
// A Disk Arbitration daemon that intercepts *unmount approval* for one or more
// named volumes. When anything (Finder eject, `hdiutil detach`,
// `diskutil unmount`) tries to unmount a target volume, this runs a stop script
// FIRST to release any file handles on the volume, then approves the unmount so it
// succeeds on the first try.
//
// Usage:
//   vol-unmount-guard [--stop-script PATH] VOLUME [VOLUME ...]
//
//   VOLUME          Volume name as it appears under /Volumes/ (match by name,
//                   so it survives remounts / changing disk numbers).
//   --stop-script   Script to run before approving an unmount.
//                   Default: <dir of this binary>/stop.sh
//
// Build:
//   clang -O2 -o vol-unmount-guard vol-unmount-guard.c \
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

// --- runtime config (populated from argv) ---------------------------------
static const char **g_targets = NULL; // volume names to guard
static int g_target_count = 0;
static char g_stop_script[PATH_MAX] = {0};
// --------------------------------------------------------------------------

static void stamp(const char *msg, const char *extra) {
    time_t t = time(NULL);
    char buf[32];
    strftime(buf, sizeof(buf), "%Y-%m-%d %H:%M:%S", localtime(&t));
    if (extra)
        fprintf(stderr, "%s [vol-unmount-guard] %s %s\n", buf, msg, extra);
    else
        fprintf(stderr, "%s [vol-unmount-guard] %s\n", buf, msg);
    fflush(stderr);
}

static int is_target(const char *name) {
    for (int i = 0; i < g_target_count; i++)
        if (strcmp(name, g_targets[i]) == 0) return 1;
    return 0;
}

// Default the stop script to a sibling of this executable, so a relocated
// install still finds it without a flag.
static void default_stop_script(void) {
    char exe[PATH_MAX];
    uint32_t sz = sizeof(exe);
    if (_NSGetExecutablePath(exe, &sz) == 0) {
        char real[PATH_MAX];
        if (realpath(exe, real)) {
            snprintf(g_stop_script, sizeof(g_stop_script), "%s/stop.sh",
                     dirname(real));
            return;
        }
    }
    snprintf(g_stop_script, sizeof(g_stop_script), "./stop.sh");
}

// Returning NULL approves the unmount; a non-NULL dissenter would block it.
// We never block — we just run the stop script synchronously first, which
// holds up the unmount until the stop script has released the volume.
static DADissenterRef on_unmount(DADiskRef disk, void *context) {
    (void)context;
    CFDictionaryRef desc = DADiskCopyDescription(disk);
    if (!desc) return NULL;

    CFStringRef nameRef =
        CFDictionaryGetValue(desc, kDADiskDescriptionVolumeNameKey);
    char name[512] = {0};
    if (nameRef)
        CFStringGetCString(nameRef, name, sizeof(name), kCFStringEncodingUTF8);
    CFRelease(desc);

    if (name[0] && is_target(name)) {
        stamp("unmount requested; running stop script for", name);
        int rc = system(g_stop_script);
        char rcbuf[64];
        snprintf(rcbuf, sizeof(rcbuf), "exit=%d", rc);
        stamp("stop script finished", rcbuf);
    }
    return NULL; // approve
}

static void usage(const char *argv0) {
    fprintf(stderr,
            "usage: %s [--stop-script PATH] VOLUME [VOLUME ...]\n"
            "  VOLUME         volume name under /Volumes/ (matched by name)\n"
            "  --stop-script  script run before approving an unmount\n"
            "                 (default: <binary dir>/stop.sh)\n",
            argv0);
}

int main(int argc, char **argv) {
    default_stop_script();

    const char *targets[64];
    int n = 0;
    for (int i = 1; i < argc; i++) {
        if ((strcmp(argv[i], "--stop-script") == 0 ||
             strcmp(argv[i], "-s") == 0)) {
            if (i + 1 >= argc) { usage(argv[0]); return 2; }
            snprintf(g_stop_script, sizeof(g_stop_script), "%s", argv[++i]);
        } else if (strcmp(argv[i], "-h") == 0 ||
                   strcmp(argv[i], "--help") == 0) {
            usage(argv[0]);
            return 0;
        } else {
            if (n < (int)(sizeof(targets) / sizeof(targets[0])))
                targets[n++] = argv[i];
        }
    }

    if (n == 0) {
        usage(argv[0]);
        return 2;
    }
    g_targets = targets;
    g_target_count = n;

    DASessionRef session = DASessionCreate(kCFAllocatorDefault);
    if (!session) {
        stamp("FATAL: could not create Disk Arbitration session", NULL);
        return 1;
    }

    DARegisterDiskUnmountApprovalCallback(session, NULL /*match all*/,
                                          on_unmount, NULL);
    DASessionScheduleWithRunLoop(session, CFRunLoopGetCurrent(),
                                 kCFRunLoopDefaultMode);

    for (int i = 0; i < g_target_count; i++)
        stamp("watching for unmount of", g_targets[i]);
    stamp("stop script:", g_stop_script);

    CFRunLoopRun();

    DAUnregisterApprovalCallback(session, on_unmount, NULL);
    DASessionUnscheduleFromRunLoop(session, CFRunLoopGetCurrent(),
                                   kCFRunLoopDefaultMode);
    CFRelease(session);
    return 0;
}
