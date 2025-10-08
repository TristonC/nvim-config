# Repository Guidelines

## Project Structure & Module Organization
The entrypoint `init.lua` loads options and keymaps from `lua/tristonc/core` and bootstraps Lazy in `lua/tristonc/lazy.lua`. Plugin specs live under `lua/tristonc/plugins`, with language servers isolated in `lua/tristonc/plugins/lsp`. Track updates to `lazy-lock.json` whenever plugin versions change so collaborators share identical snapshots.

## Build, Test, and Development Commands
- `nvim --headless "+Lazy sync" +qa` syncs plugin declarations after editing anything under `lua/tristonc/plugins`.
- `nvim --headless "+Lazy check" +qa` verifies pinned versions against `lazy-lock.json` before pushing.
- `NVIM_APPNAME=nvim-config nvim` launches Neovim with this profile without disturbing a default setup.
- `nvim --headless "+MasonInstall stylua black isort" +qa` preinstalls external formatters referenced by Conform and LSP configs.

## Coding Style & Naming Conventions
Use two-space indentation in Lua files and prefer double-quoted strings to match the existing style. Export a single table from each plugin module, keyed by the GitHub slug (for example `"nvim-telescope/telescope.nvim"`). Place reusable helpers in `lua/tristonc/core` and favor snake_case for locals. Format buffers via `<leader>mp`, which proxies to Conform, and leave inline comments only for non-obvious keymaps or settings.

## Testing Guidelines
Health checks substitute for unit tests. Run `nvim --headless "+checkhealth" +qa` after upgrading plugins or Mason packages. Smoke-test critical bindings—`<leader>ff`, `<leader>oo`, and LSP attach events—in a sample project. When changing Treesitter or formatting rules, open representative Python, CUDA, and Markdown files to confirm highlighting, diagnostics, and formatting execute without errors.

## Commit & Pull Request Guidelines
Adopt the short, imperative subject style already in history (e.g., `Add avante plugin to use codex`). Keep lockfile refreshes in the same commit as plugin edits. Pull requests should explain the intent, outline user-facing impacts (new keymaps, tooling), reference related issues, and add screenshots or terminal captures for UI tweaks. List manual verification steps so reviewers can reproduce the checks quickly.

## Plugin & Configuration Tips
Scope new plugins to their own file under `lua/tristonc/plugins` and set lazy-loading events to preserve startup time. Reuse existing patterns such as caching `local keymap = vim.keymap` and annotating mappings with `desc`. Remove stray backups like `*.un~` before committing, and document any plugin-specific tokens or environment variables in the README instead of hardcoding them.
