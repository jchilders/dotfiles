# Environment

macOS. Modern CLI tooling is installed — prefer it over the POSIX defaults:

- `rg` (ripgrep) instead of `grep` / `grep -r`
- `fd` instead of `find`
- `jq` for JSON; `yq` for YAML/TOML
- `duckdb` for ad-hoc CSV/Parquet/SQL work
- `gh` for GitHub operations
- `bat` instead of `cat` when showing me output (plain `cat` is fine for piping)
- `eza` instead of `ls`

Use these without asking. If you genuinely need a POSIX tool (portable scripts, etc.), briefly note why.

For **structural code matching or security/bug scanning** — finding a code *pattern* rather than a string, or auditing for vulnerabilities — use `semgrep` (`semgrep -e '<pattern>' --lang <lang>` for ad-hoc patterns, `semgrep --config auto` for rule-based scans). Keep using `rg` for ordinary text/symbol search; `semgrep` is a complement, not a replacement (it's much slower and only works on supported languages).
