// hostblocker — block distracting sites at the network level. Fixes a problem I
// have for ADHD+muscle memory = "let me check reddit while Claude is doing
// something"
//
// Blocks by doing the following:
//   1. Adds pf rules that drop outbound packets to resolved IPs
//   2. Adds /etc/hosts entries pointing blocked domains to 127.0.0.1 and ::1,
//      where a local HTTP server serves a simple "site blocked" page
//      instead of leaving the browser to spin forever.
//
// Both IPv4 (A) and IPv6 (AAAA) addresses are blocked. HTTPS visits fail to
// connect rather than showing the page (that would need a trusted local CA).
//
// The local server is this same binary (`hostblocker serve`), run as a
// LaunchDaemon (local.hostblocker) so it survives reboots without any extra
// setup. For the most part, this works in Firefox and Chrome, but not in Safari.
//
// Usage: hostblocker <enable|disable|reload|status|edit-config>
// Config: $XDG_CONFIG_HOME/hostblocker/blocked-domains (one domain per line)
//
// Build: make hostblocker. Tests: test/compare.zsh (see test/run.zsh).

import Darwin
import Foundation

struct CommandError: Error {
  let message: String
  init(_ message: String) { self.message = message }
}

let env = ProcessInfo.processInfo.environment
let home = env["HOME"] ?? NSHomeDirectory() // like Ruby's Dir.home

// Ruby's File.join for two parts
func join(_ a: String, _ b: String) -> String {
  a.hasSuffix("/") ? a + b : a + "/" + b
}

// Ruby's String#strip / #rstrip whitespace (includes NUL)
let rubyWhitespace: Set<Character> = [" ", "\t", "\n", "\u{0B}", "\u{0C}", "\r", "\r\n", "\0"]

extension String {
  func rstripped() -> String {
    var s = Substring(self)
    while let c = s.last, rubyWhitespace.contains(c) { s = s.dropLast() }
    return String(s)
  }

  func stripped() -> String {
    var s = Substring(rstripped())
    while let c = s.first, rubyWhitespace.contains(c) { s = s.dropFirst() }
    return String(s)
  }

  // Ruby's String#ljust (counts code points, like Ruby)
  func ljust(_ width: Int) -> String {
    let n = unicodeScalars.count
    return n >= width ? self : self + String(repeating: " ", count: width - n)
  }

  // Ruby's String#lines, without the line terminators
  var lineList: [String] {
    var parts = components(separatedBy: "\n")
    if parts.last == "" { parts.removeLast() }
    return parts
  }
}

// MARK: - Output

func say(_ s: String = "") {
  fputs(s.hasSuffix("\n") ? s : s + "\n", stdout)
}

func fail(_ message: String) -> Never {
  fflush(stdout)
  fputs(message.hasSuffix("\n") ? message : message + "\n", stderr)
  exit(1)
}

// MARK: - Subprocesses

func findExecutable(_ name: String) -> String? {
  if name.contains("/") { return name }
  for dir in (env["PATH"] ?? "").split(separator: ":", omittingEmptySubsequences: false) {
    let path = join(dir.isEmpty ? "." : String(dir), name)
    var isDir: ObjCBool = false
    if FileManager.default.fileExists(atPath: path, isDirectory: &isDir), !isDir.boolValue,
      FileManager.default.isExecutableFile(atPath: path)
    {
      return path
    }
  }
  return nil
}

func makeProcess(_ args: [String]) throws -> Process {
  guard let exe = findExecutable(args[0]) else {
    throw CommandError("No such file or directory - \(args[0])")
  }
  let process = Process()
  process.executableURL = URL(fileURLWithPath: exe)
  process.arguments = Array(args.dropFirst())
  return process
}

final class DataBox: @unchecked Sendable { var data = Data() }

struct CaptureResult {
  let stdout: String
  let stderr: String
  let success: Bool
}

// Open3.capture3: stdin is always a pipe (empty unless given)
func capture(_ args: [String], stdin input: String = "") throws -> CaptureResult {
  let process = try makeProcess(args)
  let inPipe = Pipe(), outPipe = Pipe(), errPipe = Pipe()
  process.standardInput = inPipe
  process.standardOutput = outPipe
  process.standardError = errPipe
  try process.run()

  // Read both streams while writing stdin, or a chatty child (tee) deadlocks
  let out = DataBox(), err = DataBox()
  let group = DispatchGroup()
  DispatchQueue.global().async(group: group) {
    out.data = outPipe.fileHandleForReading.readDataToEndOfFile()
  }
  DispatchQueue.global().async(group: group) {
    err.data = errPipe.fileHandleForReading.readDataToEndOfFile()
  }
  let writer = inPipe.fileHandleForWriting
  _ = fcntl(writer.fileDescriptor, F_SETNOSIGPIPE, 1)
  if !input.isEmpty { try? writer.write(contentsOf: Data(input.utf8)) }
  try? writer.close()
  group.wait()
  process.waitUntilExit()

  return CaptureResult(
    stdout: String(decoding: out.data, as: UTF8.self),
    stderr: String(decoding: err.data, as: UTF8.self),
    success: process.terminationReason == .exit && process.terminationStatus == 0
  )
}

// Kernel#system: inherits stdio unless quiet. Returns false if it can't run.
@discardableResult
func spawn(_ args: [String], quiet: Bool = false) -> Bool {
  fflush(stdout)
  guard let process = try? makeProcess(args) else { return false }
  if quiet {
    process.standardOutput = FileHandle.nullDevice
    process.standardError = FileHandle.nullDevice
  }
  guard (try? process.run()) != nil else { return false }
  process.waitUntilExit()
  return process.terminationReason == .exit && process.terminationStatus == 0
}

func execvp(_ args: [String]) throws -> Never {
  fflush(stdout)
  let cArgs = args.map { strdup($0) } + [nil]
  Darwin.execvp(args[0], cArgs)
  throw CommandError("No such file or directory - \(args[0])")
}

// Ruby's Shellwords.split
func shellSplit(_ line: String) throws -> [String] {
  var words: [String] = []
  var field = ""
  var inField = false
  var chars = Array(line)[...]

  while let c = chars.first {
    chars = chars.dropFirst()
    switch c {
    case " ", "\t", "\n", "\u{0B}", "\u{0C}", "\r":
      if inField { words.append(field); field = ""; inField = false }
    case "'":
      guard let end = chars.firstIndex(of: "'") else { throw CommandError("Unmatched quote: \(line)") }
      field += String(chars[..<end]); chars = chars[(end + 1)...]; inField = true
    case "\"":
      var closed = false
      while let d = chars.first {
        chars = chars.dropFirst()
        if d == "\"" { closed = true; break }
        if d == "\\", let e = chars.first {
          chars = chars.dropFirst()
          field += "$`\"\\\n".contains(e) ? String(e) : "\\" + String(e)
        } else {
          field.append(d)
        }
      }
      guard closed else { throw CommandError("Unmatched quote: \(line)") }
      inField = true
    case "\\":
      if let e = chars.first { chars = chars.dropFirst(); field.append(e) }
      inField = true
    default:
      field.append(c); inField = true
    }
  }
  if inField { words.append(field) }
  return words
}

// MARK: - DNS cache

final class DnsCache {
  // v2 holds A and AAAA addresses; older versions cached A only in dns_cache
  static let tableName = "dns_cache_v2"
  let path: String
  let ttlSeconds: Int

  init(path: String, ttlSeconds: Int) {
    self.path = path
    self.ttlSeconds = ttlSeconds
  }

  func initialize() throws {
    try FileManager.default.createDirectory(
      atPath: (path as NSString).deletingLastPathComponent, withIntermediateDirectories: true)
    try sqlite("""
      CREATE TABLE IF NOT EXISTS \(Self.tableName) (
        domain TEXT PRIMARY KEY,
        ips TEXT,
        timestamp INTEGER
      );

      """)
  }

  func fetch(_ domain: String) throws -> [String] {
    let cutoff = now() - ttlSeconds
    let output = try sqlite("""
      SELECT ips
      FROM \(Self.tableName)
      WHERE domain = \(sqlQuote(domain))
        AND timestamp > \(cutoff);

      """, allowFailure: true)
    return parseIPs(output.lineList.first ?? "")
  }

  func write(_ domain: String, _ ips: [String]) throws {
    try sqlite("""
      INSERT OR REPLACE INTO \(Self.tableName) (domain, ips, timestamp)
      VALUES (
        \(sqlQuote(domain)),
        \(sqlQuote(ips.joined(separator: ","))),
        \(now())
      );

      """)
  }

  func clear() throws {
    guard FileManager.default.fileExists(atPath: path) else { return }
    try sqlite("DELETE FROM \(Self.tableName);", allowFailure: true)
  }

  private func now() -> Int { Int(Date().timeIntervalSince1970) }

  private func parseIPs(_ value: String) -> [String] {
    value.stripped().split(separator: ",", omittingEmptySubsequences: true).map(String.init)
  }

  private func sqlQuote(_ value: String) -> String {
    "'" + value.replacingOccurrences(of: "'", with: "''") + "'"
  }

  @discardableResult
  private func sqlite(_ sql: String, allowFailure: Bool = false) throws -> String {
    let result = try capture(["sqlite3", path, sql])
    if result.success || allowFailure { return result.stdout }
    let err = result.stderr.stripped()
    throw CommandError(err.isEmpty ? "sqlite3 command failed" : err)
  }
}

// MARK: - /etc/hosts

let root = env["HOSTBLOCKER_ROOT"] ?? "" // test hook: sandbox for system paths

final class HostsFile {
  static let path = "\(root)/etc/hosts"
  static let sectionStart = "# hostblocker-start"
  static let sectionEnd = "# hostblocker-end"
  static let sectionPattern = try! NSRegularExpression(
    pattern: NSRegularExpression.escapedPattern(for: sectionStart) + "\\n.*?"
      + NSRegularExpression.escapedPattern(for: sectionEnd) + "\\n?",
    options: [.dotMatchesLineSeparators])

  func write(_ domains: [String]) throws {
    let content = try withoutSection()
    let entries = domains.flatMap { ["127.0.0.1 \($0)", "::1 \($0)"] }.joined(separator: "\n")
    try writeFile("\(content)\n\n\(Self.sectionStart)\n\(entries)\n\(Self.sectionEnd)\n")
    flushDNSCache()
  }

  func clear() throws {
    try writeFile("\(try withoutSection())\n")
    flushDNSCache()
  }

  private func withoutSection() throws -> String {
    let data = try Data(contentsOf: URL(fileURLWithPath: Self.path))
    // Never rewrite a hosts file we can't round-trip exactly
    guard let content = String(data: data, encoding: .utf8) else {
      throw CommandError("\(Self.path) is not valid UTF-8; not modifying it")
    }
    let range = NSRange(content.startIndex..., in: content)
    return Self.sectionPattern.stringByReplacingMatches(
      in: content, range: range, withTemplate: ""
    ).rstripped()
  }

  private func writeFile(_ content: String) throws {
    let result = try capture(["sudo", "tee", Self.path], stdin: content)
    guard result.success else {
      throw CommandError("Failed to update \(Self.path): \(result.stderr.stripped())")
    }
  }

  private func flushDNSCache() {
    spawn(["sudo", "dscacheutil", "-flushcache"], quiet: true)
    spawn(["sudo", "killall", "-HUP", "mDNSResponder"], quiet: true)
  }
}

// MARK: - Local "site blocked" server

final class LocalServer {
  static let daemonLabel = "local.hostblocker"
  static let plistPath = "\(root)/Library/LaunchDaemons/\(daemonLabel).plist"
  let serverPath: String

  init(serverPath: String) {
    self.serverPath = serverPath
  }

  func ensureRunning() throws {
    try installServer()
    if installed && currentPlist == plistContent { return }

    // A plist from an older version (e.g. the Ruby server) runs something else:
    // replace it and restart the daemon so the new server takes over port 80.
    let upgrading = installed
    try writePlist()
    if upgrading { spawn(["sudo", "launchctl", "unload", Self.plistPath]) }
    spawn(["sudo", "launchctl", "load", "-w", Self.plistPath])
  }

  func stop() {
    guard installed else { return }

    spawn(["sudo", "launchctl", "unload", Self.plistPath])
    spawn(["sudo", "rm", "-f", Self.plistPath])
  }

  private var installed: Bool { FileManager.default.fileExists(atPath: Self.plistPath) }

  private var currentPlist: String? { try? String(contentsOfFile: Self.plistPath, encoding: .utf8) }

  // Copy this binary to a stable path for the daemon, so rebuilding or moving
  // the repo doesn't break it. Rename is atomic; a running server keeps its copy.
  private func installServer() throws {
    guard let me = Bundle.main.executableURL?.resolvingSymlinksInPath().path,
      me != serverPath
    else { return }
    let dir = (serverPath as NSString).deletingLastPathComponent
    try FileManager.default.createDirectory(atPath: dir, withIntermediateDirectories: true)
    let tmp = serverPath + ".tmp"
    try? FileManager.default.removeItem(atPath: tmp)
    try FileManager.default.copyItem(atPath: me, toPath: tmp)
    try FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: tmp)
    guard rename(tmp, serverPath) == 0 else {
      throw CommandError("Failed to install server to \(serverPath): \(String(cString: strerror(errno)))")
    }
  }

  private func writePlist() throws {
    let result = try capture(["sudo", "tee", Self.plistPath], stdin: plistContent)
    guard result.success else {
      throw CommandError("Failed to write server plist: \(result.stderr.stripped())")
    }

    spawn(["sudo", "chmod", "644", Self.plistPath])
  }

  private var plistContent: String {
    """
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>\(Self.daemonLabel)</string>
      <key>ProgramArguments</key>
      <array>
        <string>\(serverPath)</string>
        <string>serve</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
      <key>StandardErrorPath</key>
      <string>/tmp/hostblocker-server.log</string>
    </dict>
    </plist>

    """
  }
}

// Serves the "site blocked" page to anything that connects. Run by launchd.
enum BlockedPageServer {
  static let html = """
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Blocked</title>
      <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
               display: flex; align-items: center; justify-content: center;
               min-height: 100vh; background: #f0f0f0; }
        .card { background: white; border-radius: 12px; padding: 48px 64px;
                box-shadow: 0 4px 24px rgba(0,0,0,0.08); text-align: center; max-width: 480px; }
        h1 { color: #c0392b; font-size: 2.2em; margin-bottom: 12px; }
        p { color: #888; font-size: 1.1em; }
      </style>
    </head>
    <body>
      <div class="card">
        <h1>Site Blocked</h1>
        <p>This site is blocked by hostblocker.</p>
      </div>
    </body>
    </html>

    """

  static let response = Array(
    [
      "HTTP/1.1 200 OK",
      "Content-Type: text/html; charset=utf-8",
      "Content-Length: \(html.utf8.count)",
      "Connection: close",
      "",
      html,
    ].joined(separator: "\r\n").utf8)

  static func run() -> Never {
    // HOSTBLOCKER_PORT is a test hook; browsers hit 80
    let port = UInt16(env["HOSTBLOCKER_PORT"] ?? "80") ?? 80
    let fd4 = listen4(port: port)
    // IPv6 is best effort: without it, IPv4 still serves the page
    if let fd6 = listen6(port: port) {
      Thread.detachNewThread { acceptLoop(fd6) }
    }
    acceptLoop(fd4)
  }

  static func listen6(port: UInt16) -> Int32? {
    let fd = socket(AF_INET6, SOCK_STREAM, 0)
    var yes: Int32 = 1
    setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &yes, socklen_t(MemoryLayout<Int32>.size))
    setsockopt(fd, IPPROTO_IPV6, IPV6_V6ONLY, &yes, socklen_t(MemoryLayout<Int32>.size))
    var addr = sockaddr_in6()
    addr.sin6_len = UInt8(MemoryLayout<sockaddr_in6>.size)
    addr.sin6_family = sa_family_t(AF_INET6)
    addr.sin6_port = port.bigEndian
    addr.sin6_addr = in6addr_loopback
    let bound = withUnsafePointer(to: &addr) {
      $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
        bind(fd, $0, socklen_t(MemoryLayout<sockaddr_in6>.size))
      }
    }
    guard fd >= 0, bound == 0, listen(fd, 128) == 0 else {
      fputs("hostblocker serve: can't listen on [::1]:\(port): \(String(cString: strerror(errno)))\n", stderr)
      if fd >= 0 { close(fd) }
      return nil
    }
    return fd
  }

  static func listen4(port: UInt16) -> Int32 {
    let fd = socket(AF_INET, SOCK_STREAM, 0)
    var yes: Int32 = 1
    setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &yes, socklen_t(MemoryLayout<Int32>.size))
    var addr = sockaddr_in()
    addr.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    addr.sin_family = sa_family_t(AF_INET)
    addr.sin_port = port.bigEndian
    addr.sin_addr.s_addr = inet_addr("127.0.0.1")
    let bound = withUnsafePointer(to: &addr) {
      $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
        bind(fd, $0, socklen_t(MemoryLayout<sockaddr_in>.size))
      }
    }
    guard fd >= 0, bound == 0, listen(fd, 128) == 0 else {
      fail("hostblocker serve: can't listen on 127.0.0.1:\(port): \(String(cString: strerror(errno)))")
    }
    return fd
  }

  static func acceptLoop(_ fd: Int32) -> Never {
    while true {
      let client = accept(fd, nil, nil)
      guard client >= 0 else { continue }
      // A thread per client, not GCD: idle browser preconnects block in recv
      // and would exhaust GCD's worker pool, stalling every other client
      Thread.detachNewThread { respond(client) }
    }
  }

  static func respond(_ client: Int32) {
    var yes: Int32 = 1
    setsockopt(client, SOL_SOCKET, SO_NOSIGPIPE, &yes, socklen_t(MemoryLayout<Int32>.size))
    // Don't hold a thread forever for a client that never sends
    var timeout = timeval(tv_sec: 10, tv_usec: 0)
    setsockopt(client, SOL_SOCKET, SO_RCVTIMEO, &timeout, socklen_t(MemoryLayout<timeval>.size))
    setsockopt(client, SOL_SOCKET, SO_SNDTIMEO, &timeout, socklen_t(MemoryLayout<timeval>.size))
    var buf = [UInt8](repeating: 0, count: 4096)
    _ = recv(client, &buf, buf.count, 0)
    response.withUnsafeBytes { bytes in
      var sent = 0
      while sent < bytes.count {
        let n = send(client, bytes.baseAddress! + sent, bytes.count - sent, 0)
        if n <= 0 { break }
        sent += n
      }
    }
    close(client)
  }
}

// MARK: - CLI

enum Style: String {
  case reset = "\u{1B}[0m"
  case bold = "\u{1B}[1m"
  case dim = "\u{1B}[2m"
  case red = "\u{1B}[31m"
  case green = "\u{1B}[32m"
  case yellow = "\u{1B}[33m"
  case blue = "\u{1B}[34m"
  case magenta = "\u{1B}[35m"
  case cyan = "\u{1B}[36m"
}

final class Hostblocker {
  static let configDir = join(env["XDG_CONFIG_HOME"] ?? join(home, ".config"), "hostblocker")
  static let dataDir = join(env["XDG_DATA_HOME"] ?? join(join(home, ".local"), "share"), "hostblocker")
  static let blocklistFile = join(configDir, "blocked-domains")
  static let cacheDB = join(dataDir, "dns_cache.db")
  static let serverPath = join(dataDir, "hostblocker-server")
  static let pfTable = "blocked"
  static let ttlSeconds = 86_400

  let command: String?
  let editor: String
  let cache = DnsCache(path: cacheDB, ttlSeconds: ttlSeconds)
  let hostsFile = HostsFile()
  let localServer = LocalServer(serverPath: serverPath)
  private var cachedDomains: [String]?

  init(_ command: String?, editor: String = env["EDITOR"] ?? "vi") {
    self.command = command
    self.editor = editor
  }

  func run() throws {
    switch command {
    case "enable": try enable()
    case "reload": try enable(forceReload: true)
    case "disable": try disable()
    case "status": try status()
    case "edit-config": try editConfig()
    default: throw usage()
    }
  }

  private func enable(forceReload: Bool = false) throws {
    try ensureBlocklist()
    let domains = try blockedDomains()

    try cache.initialize()
    say(titleLine(forceReload ? "Reloading blocklist" : "Enabling blocklist", tone: forceReload ? .yellow : .cyan))

    if forceReload {
      try flushPFTable()
      try cache.clear()
    }

    let currentIPs = Set(try pfTableIPs())
    var desiredIPs: [String] = []
    var resolvedDomainCount = 0

    for domain in domains {
      let ips = try resolvedIPs(for: domain, refresh: forceReload)
      if ips.isEmpty { continue }

      desiredIPs += ips
      resolvedDomainCount += 1
    }

    desiredIPs = uniq(desiredIPs)

    try hostsFile.write(domains)
    try localServer.ensureRunning()

    if !forceReload && !currentIPs.isEmpty && Set(desiredIPs) == currentIPs {
      say(statusLine("Already enabled", tone: .green))
      return
    }

    if desiredIPs.isEmpty {
      say(statusLine("No IPs resolved; nothing to update", tone: .yellow))
      return
    }

    try loadPFRules()
    try replacePFTable(desiredIPs)

    say(statusLine("Blocking active", tone: .green))
    say("  \(blockingMessage(desiredIPs.count, resolvedDomainCount))")
  }

  private func disable() throws {
    say(titleLine("Disabling blocklist", tone: .yellow))
    try flushPFTable()
    try runCommand(["sudo", "pfctl", "-f", "-"], stdin: "# blocklist disabled\n", allowFailure: true)
    try hostsFile.clear()
    localServer.stop()
    say(statusLine("Blocking disabled", tone: .yellow))
  }

  private func status() throws {
    try ensureBlocklist()

    let currentIPs = try pfTableIPs()
    if currentIPs.isEmpty {
      say(titleLine("Hostblocker status", tone: .blue))
      say(statusLine("DISABLED", tone: .yellow))
      return
    }

    say(titleLine("Hostblocker status", tone: .blue))
    say(statusLine("ENABLED", tone: .green))
    say("  \(blockingSummary(currentIPs.count, try blockedDomains().count))")
    say("  \(paint(Self.blocklistFile, .dim))")
    say()
    say(tableRow("DOMAIN", "IPS", leftStyles: [.bold, .cyan], rightStyles: [.bold, .cyan]))
    say(tableRow("------", "---", leftStyles: [.dim], rightStyles: [.dim]))

    for domain in try blockedDomains() {
      let ips = try resolveDomain(domain)
      let row = ips.isEmpty
        ? paint("(no A/AAAA records)", .dim, .yellow)
        : ips.joined(separator: paint(" • ", .dim))

      say(tableRow(domain, row, leftStyles: [.bold]))
    }
  }

  private func editConfig() throws {
    try FileManager.default.createDirectory(atPath: Self.configDir, withIntermediateDirectories: true)
    var editorCommand = try shellSplit(editor)
    if editorCommand.isEmpty { editorCommand = ["vi"] }
    try execvp(editorCommand + [Self.blocklistFile])
  }

  private func ensureBlocklist() throws {
    if FileManager.default.fileExists(atPath: Self.blocklistFile) { return }

    throw CommandError("Error: \(Self.blocklistFile) not found.")
  }

  private func blockedDomains() throws -> [String] {
    if let cachedDomains { return cachedDomains }
    let content = try String(contentsOfFile: Self.blocklistFile, encoding: .utf8)
    let domains = content.lineList.compactMap { line -> String? in
      let domain = line.stripped()
      return domain.isEmpty || domain.hasPrefix("#") ? nil : domain
    }
    cachedDomains = domains
    return domains
  }

  private func resolvedIPs(for domain: String, refresh: Bool) throws -> [String] {
    let cachedIPs = refresh ? [] : try cache.fetch(domain)
    if !cachedIPs.isEmpty {
      say(stepLine("cached", domain, tone: .blue))
      return cachedIPs
    }

    say(stepLine("resolve", domain, tone: .magenta))
    let resolved = try resolveDomain(domain)

    if resolved.isEmpty {
      say("  \(paint("no A/AAAA records found", .dim, .yellow))")
    } else {
      try cache.write(domain, resolved)
      say("  \(paint(resolved.joined(separator: " "), .dim))")
    }

    return resolved
  }

  // dig queries DNS directly; the system resolver would return our own
  // /etc/hosts entries (127.0.0.1, ::1) for blocked domains.
  private func resolveDomain(_ domain: String) throws -> [String] {
    let v4 = try runCommand(["dig", "+short", domain], allowFailure: true)
    let v6 = try runCommand(["dig", "+short", "AAAA", domain], allowFailure: true)
    return v4.stdout.lineList.map { $0.stripped() }.filter(isIPv4)
      + v6.stdout.lineList.map { $0.stripped() }.filter(isIPv6)
  }

  private func isIPv6(_ s: String) -> Bool {
    var addr = in6_addr()
    return s.contains(":") && inet_pton(AF_INET6, s, &addr) == 1
  }

  // Ruby's /\A\d{1,3}(?:\.\d{1,3}){3}\z/
  private func isIPv4(_ s: String) -> Bool {
    let parts = s.split(separator: ".", omittingEmptySubsequences: false)
    return parts.count == 4
      && parts.allSatisfy { (1...3).contains($0.count) && $0.allSatisfy { $0.isASCII && $0.isNumber } }
  }

  private func pfTableIPs() throws -> [String] {
    let result = try runCommand(["sudo", "pfctl", "-t", Self.pfTable, "-T", "show"], allowFailure: true)
    return result.stdout.lineList.map { $0.stripped() }.filter { !$0.isEmpty }
  }

  private func flushPFTable() throws {
    try runCommand(["sudo", "pfctl", "-t", Self.pfTable, "-T", "flush"], allowFailure: true)
  }

  private func loadPFRules() throws {
    let pfRules = """
      table <\(Self.pfTable)> persist
      block drop out quick to <\(Self.pfTable)>

      """

    try runCommand(["sudo", "pfctl", "-f", "-"], stdin: pfRules, failureMessage: "Error loading pf rules")
  }

  private func replacePFTable(_ ips: [String]) throws {
    try runCommand(
      ["sudo", "pfctl", "-t", Self.pfTable, "-T", "replace"] + ips,
      failureMessage: "Error updating pf table")
  }

  @discardableResult
  private func runCommand(
    _ command: [String], stdin: String = "", allowFailure: Bool = false, failureMessage: String? = nil
  ) throws -> CaptureResult {
    let result = try capture(command, stdin: stdin)
    if result.success || allowFailure { return result }

    var message = failureMessage ?? result.stderr.stripped()
    if message.isEmpty { message = "Command failed: \(command.joined(separator: " "))" }

    throw CommandError(message)
  }

  private func blockingMessage(_ ipCount: Int, _ domainCount: Int) -> String {
    "Blocking \(ipCount) \(pluralize(ipCount, "IP", "IPs")) "
      + "for \(domainCount) \(pluralize(domainCount, "domain", "domains")) "
      + "from \(Self.blocklistFile)"
  }

  private func blockingSummary(_ ipCount: Int, _ domainCount: Int) -> String {
    "Blocking \(ipCount) \(pluralize(ipCount, "IP", "IPs")) "
      + "for \(domainCount) \(pluralize(domainCount, "domain", "domains"))"
  }

  private func pluralize(_ count: Int, _ singular: String, _ plural: String) -> String {
    count == 1 ? singular : plural
  }

  private func usage() -> CommandError {
    CommandError("""
      \(titleLine("Hostblocker", tone: .cyan))

      \(paint("Usage:", .bold)) hostblocker <command>

      Commands:
        \(paint("enable", .green))       Enable / update blocklist
        \(paint("disable", .yellow))      Disable blocklist
        \(paint("reload", .magenta))       Re-resolve all domains and re-apply blocklist
        \(paint("status", .blue))       Show blocked domains and their IPs
        \(paint("edit-config", .cyan))  Open blocked-domains in $EDITOR

      """)
  }

  private func titleLine(_ text: String, tone: Style) -> String {
    "\(paint("==>", .bold, tone)) \(paint(text, .bold))"
  }

  private func statusLine(_ text: String, tone: Style) -> String {
    "\(paint("[hostblocker]", .bold, tone)) \(paint(text, .bold))"
  }

  private func stepLine(_ action: String, _ domain: String, tone: Style) -> String {
    "\(paint(action.uppercased().ljust(7), .bold, tone)) \(paint(domain, .bold))"
  }

  private func tableRow(
    _ left: String, _ right: String, width: Int = 22, leftStyles: [Style] = [], rightStyles: [Style] = []
  ) -> String {
    "\(paint(left.ljust(width), leftStyles)) \(paint(right, rightStyles))"
  }

  private func paint(_ text: String, _ styles: Style...) -> String {
    paint(text, styles)
  }

  private func paint(_ text: String, _ styles: [Style]) -> String {
    guard color, !styles.isEmpty else { return text }
    return styles.map(\.rawValue).joined() + text + Style.reset.rawValue
  }

  private var color: Bool {
    if env["NO_COLOR"] != nil { return false }
    if env["CLICOLOR_FORCE"] == "1" || env["FORCE_COLOR"] == "1" { return true }
    return isatty(STDOUT_FILENO) == 1
  }
}

func uniq(_ items: [String]) -> [String] {
  var seen = Set<String>()
  return items.filter { seen.insert($0).inserted }
}

let arguments = CommandLine.arguments.dropFirst()
if arguments.first == "serve" { BlockedPageServer.run() }

do {
  try Hostblocker(arguments.first).run()
} catch let error as CommandError {
  fail(error.message)
} catch {
  fail("hostblocker: \(error.localizedDescription)")
}
