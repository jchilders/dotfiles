# Neovim config cleanup

Tracking the refactor work surfaced in the 2026-04-19 review.

## Test-as-you-go

Before starting a batch, run the smoke test to confirm a clean baseline:

```bash
~/bin/nvim-smoke                 # loads every jc.* and core.* module headlessly
```

After each change:

1. Re-run `nvim-smoke` — must stay green.
2. Open `nvim` normally and exercise the keymap or feature touched by the change (list below with each item).
3. For pure-logic changes, add a plenary busted spec under `xdg_config/nvim/tests/` and run with:
   ```bash
   nvim --headless -c "PlenaryBustedDirectory xdg_config/nvim/tests/ {minimal_init='xdg_config/nvim/tests/minimal_init.lua'}"
   ```

## Bugs (do first — smallest risk, biggest payoff)

- [x] `scratcher.lua:17` — `bufnr = 0 or bufnr` always picks 0. Swap to `bufnr = bufnr or 0`. Also replaced deprecated `nvim_buf_get_option` → `vim.bo[bufnr].filetype` in the same edit. **Verify:** `<leader>rs` opens a scratch file for the current filetype.
- [x] `utils.lua` — `blameVirtText`/`clearBlameVirtText` deleted (were broken on `api.buf_set_virtual_text`, no callers).
- [x] `mappings.lua` — rewrote `map_ctrlo` / `map_ctrlo_tele` to drop the stale `bufnr`/`map_options` params and pass a closure to `vim.keymap.set`. This also eliminated the `TelescopeMapArgs` global and the `nvim_replace_termcodes` keying scheme (cascades into the globals section). **Verify:** `<C-o>o`, `<C-o>b`, `<C-o>f`, `<C-o>gb`, `<C-o>gs`, `<C-o>r`, `<C-o>t`, `<C-o>T` all fire; `<C-o>rc/rm/rv` still target `app/controllers|models|views`.
- [x] `utils.lua` (`lsp_name`) — replaced body with `table.concat(vim.tbl_map(...), ", ")`. **Verify:** statusline shows correct LSP list in a buffer with 2+ clients.
- [x] `utils.lua` (`dump_to_buffer`) — deleted (shadowed `table`, superseded by `vim.inspect`).

## Deprecated APIs

- [x] `scratcher.lua:18` — `nvim_buf_get_option` → `vim.bo[bufnr].filetype` (done as part of the bufnr fix).
- [x] `autocmd.lua:6` — use `(vim.hl or vim.highlight).on_yank()` (works on 0.11+ and older).
- [x] `core/globals.lua` — `vim.loop` → `(vim.uv or vim.loop)`. `terminal/shared.lua` had an unused `local uv = vim.loop`, deleted.
- [x] Purged `nvim_set_keymap` / `nvim_buf_set_keymap` everywhere. Deleted `utils.lua` helpers (`key_mapper`, `set_mappings`, `map`, `map_global`); migrated all `remap(...)` callers in `mappings.lua`, the Ruby `insert_binding` autocmd in `autocmd.lua`, and the Music app keymaps (which also turned `ControlMusic` global into a local `tell_music`).

## Dead code

- [x] `utils.lua` — deleted `prequire`, `add_gem_to_lsp_workspace` ("Does this work?"), `T`/`N`/`root_node_text`, `is_array`, `table_length`, `dump`. Stdlib replacements were already pointed at in the prior comments.
- [x] `mappings.lua` — stripped the `<leader>sa` TODO, the tireswing `J`/`K` block, the treesitter-toggle block, and the LSP-diagnostic block. (The long `*`-search StackOverflow explainer stays — it's documentation, not dead code.)
- [x] `terminal/shared.lua:1` — unused `local uv = vim.loop` (done with the deprecated-APIs batch).
- [x] `chuck_tester.lua:211` — `return bufnr` instead of re-looking it up.

## Duplication

- [ ] `terminal/wezterm.lua` and `terminal/ghostty.lua` both re-implement `send_left/right/up/down` wrappers. Move those four into `terminal/init.lua` so each backend only exposes `send_text`. **Verify:** `<leader>sh/sj/sk/sl` still send to the expected pane under both `$TERM_PROGRAM=ghostty` and wezterm.
- [ ] `valid_directions` lives in both backends — move to shared.

## Globals / scoping

- [ ] `core/globals.lua` — add `local` to `reloader`, make `RELOAD`/`R` opt-in (move under `_G` explicitly or drop). Replace the fake-class `globals:load_variables()` with a plain table of fields.
- [x] `mappings.lua:6` — `TelescopeMapArgs` global removed; `map_ctrlo_tele` now uses a closure (done as part of the bug batch).
- [x] `mappings.lua:315` — `ControlMusic` is gone; replaced with a local `tell_music` helper and closures in each keymap (done with the deprecated-APIs batch).

## Structural

- [ ] Split `utils.lua` (366 lines):
  - `jc/debug_print.lua` — templates + `insert_print_statement`.
  - `jc/ui.lua` — `toggle_qf`, `toggle_zenish`.
  - Everything else gets deleted per the dead-code section.
- [ ] Add `return nil` to recursive dead-ends in `tireswing.lua` (`sibling_or_parent_sibling`, `parent_node_of_type`).
- [ ] Add `selene` or `luacheck` config so the above classes of issue get caught automatically going forward.
