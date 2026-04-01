# Repository Guidelines

## Project Structure & Module Organization
The entrypoint `init.lua` loads options and keymaps from `lua/tristonc/core` and bootstraps Lazy in `lua/tristonc/lazy.lua`. Plugin specs live under `lua/tristonc/plugins`, with language servers isolated in `lua/tristonc/plugins/lsp`. Track updates to `lazy-lock.json` whenever plugin versions change so collaborators share identical snapshots.

## Build, Test, and Development Commands
- `nvim --headless "+Lazy sync" +qa` syncs plugin declarations after editing anything under `lua/tristonc/plugins`.
- `nvim --headless "+Lazy check" +qa` verifies pinned versions against `lazy-lock.json` before pushing.
- `NVIM_APPNAME=nvim-config nvim` launches Neovim with this profile without disturbing a default setup.
- `nvim --headless "+MasonInstall stylua black isort" +qa` preinstalls external formatters referenced by Conform and LSP configs.
- `nvim --headless "+checkhealth" +qa` runs health checks on all plugins and Mason packages to verify configuration.
- Format Lua files: `<leader>mp` triggers Conform formatting for current buffer with `stylua`.
- Format Python files: Conform applies `isort` and `black` automatically on save or via `<leader>mp`.
- Test LSP: Open a Python file and verify pyright attaches, run `:LspInfo` to confirm server status.
- Test formatting: Create test.py with messy code, save to trigger auto-format, or run `<leader>mp` manually.

## Coding Style & Naming Conventions
Use two-space indentation in Lua files and prefer double-quoted strings to match the existing style. Export a single table from each plugin module, keyed by the GitHub slug (for example `"nvim-telescope/telescope.nvim"`). Place reusable helpers in `lua/tristonc/core` and favor snake_case for locals. Format buffers via `<leader>mp`, which proxies to Conform, and leave inline comments only for non-obvious keymaps or settings.

### Lua Configuration Patterns
- Cache frequently accessed APIs: `local keymap = vim.keymap`, `local cmd = vim.cmd`, `local opt = vim.opt`
- Use `opts = {}` table for simple plugin configurations instead of `config = function()` when possible
- For complex setups requiring require statements or conditional logic, use `config = function()`
- Lazy-load plugins with appropriate events: `event = "VeryLazy"` for UI plugins, `event = { "BufReadPre", "BufNewFile" }` for LSP/formatting
- Always provide `desc` parameter in keymap definitions for which-key integration
- Use `vim.api.nvim_create_autocmd` over `autocmd` commands in Lua files

### LSP Configuration
- Use `cmp_nvim_lsp.default_capabilities()` instead of deprecated `vim.lsp.protocol.make_client_capabilities()`
- Configure LSP servers in `lua/tristonc/plugins/lsp/lspconfig.lua` using LspAttach autocmd for buffer-local keymaps
- Avoid deprecated `on_attach` function pattern; use `LspAttach` autocmd callback instead
- Set diagnostic symbols via `vim.diagnostic.config()` with sign column text mappings
- Add language-specific settings under the `settings` table in `lspconfig.setup()`

### Plugin Event Loading
- Use `event = "VeryLazy"` for plugins that don't need immediate loading at startup
- Use `event = { "BufReadPre", "BufNewFile" }` for LSP, formatting, and syntax plugins
- Use `cmd = "CommandName"` for plugins that should only load when a command is invoked
- For file-type specific plugins, use `ft = { "filetype1", "filetype2" }` instead of BufRead events

### Deprecated/Anti-patterns to Avoid
- Don't use `on_attach` function in LSP configs; use `LspAttach` autocmd instead
- Avoid deprecated `vim.lsp.protocol.make_client_capabilities()`; use `cmp_nvim_lsp.default_capabilities()`
- Don't use `vim.lsp.handlers["textDocument/hover"]` direct assignment; use LspAttach if needed
- Avoid vimscript commands in Lua files when Lua API exists (e.g., prefer `vim.opt` over `vim.cmd("set")`)
- Don't set `event = "BufRead"` when `event = { "BufReadPre", "BufNewFile" }` is more appropriate for syntax plugins
- Don't use `config = true` in lazy.nvim plugin specs; omit `config` field or use `opts = {}` instead

### Error Handling
- Wrap plugin require calls in pcall when testing optional dependencies
- Use `vim.notify()` instead of `print()` for user-facing messages
- Provide meaningful error messages when plugin configurations fail

## Testing Guidelines
Health checks substitute for unit tests. Run `nvim --headless "+checkhealth" +qa` after upgrading plugins or Mason packages. Smoke-test critical bindings—`<leader>ff`, `<leader>oo`, and LSP attach events—in a sample project. When changing Treesitter or formatting rules, open representative Python, CUDA, and Markdown files to confirm highlighting, diagnostics, and formatting execute without errors.

### Manual Testing Checklist
- Open a Python file and verify pyright LSP attaches (check with `:LspInfo`)
- Run `:checkhealth` and ensure no critical errors for core plugins
- Test formatting: Create a messy Python file, save to trigger `isort` + `black`
- Test keymaps: Verify `<leader>ff` (find files), `<leader>mp` (format), and `<leader>nh` (clear search)
- Test LSP: Hover over code with `K`, check diagnostics with `]d` and `[d`
- Verify Lazy status: Run `:Lazy` and check for any plugin errors

## Commit & Pull Request Guidelines
Adopt the short, imperative subject style already in history (e.g., `Add avante plugin to use codex`). Keep lockfile refreshes in the same commit as plugin edits. Pull requests should explain the intent, outline user-facing impacts (new keymaps, tooling), reference related issues, and add screenshots or terminal captures for UI tweaks. List manual verification steps so reviewers can reproduce the checks quickly.

## Plugin & Configuration Tips
Scope new plugins to their own file under `lua/tristonc/plugins` and set lazy-loading events to preserve startup time. Reuse existing patterns such as caching `local keymap = vim.keymap` and annotating mappings with `desc`. Remove stray backups like `*.un~` before committing, and document any plugin-specific tokens or environment variables in the README instead of hardcoding them.

### Lazy Plugin Management
- Set `version = "*"` for plugins that don't track stable releases
- Set `version = false` for plugins where you always want the latest commit
- Use `build` field for post-install commands (e.g., build steps for native modules)
- Keep `lazy-lock.json` committed to ensure consistent plugin versions across machines

### Performance Optimization
- Lazy-load non-essential plugins with `event = "VeryLazy"` or `cmd = "CommandName"`
- Avoid loading LSP servers for file types you don't use
- Use `enabled = false` in opts to conditionally disable features
- Set `timeout_ms` appropriately for formatting operations (default 1000ms in config)

## Keymap Conventions
- Leader key is set to space (`vim.g.mapleader = " "`)
- All keymaps must include a `desc` field for which-key integration
- Use `vim.keymap.set()` for creating keymaps, not deprecated `vim.api.nvim_set_keymap()`
- Group related keymaps under leader prefixes (e.g., `<leader>g` for git, `<leader>f` for files)
- Test keymaps after adding them by running `:Lazy` and checking for errors, then restarting Neovim

## File Organization Patterns
- Each plugin gets its own file under `lua/tristonc/plugins/`
- LSP servers are configured in `lua/tristonc/plugins/lsp/lspconfig.lua`
- Core functionality (options, keymaps) lives in `lua/tristonc/core/`
- Use lazy.nvim's `opts` pattern for simple configurations, `config` function for complex ones
- Keep plugin files focused: if a file gets too large (>200 lines), consider splitting it

## Neovim Version Requirements
- This configuration targets Neovim v0.11+ (current: v0.11.4)
- Always test new features on the minimum supported version before assuming they work
- Check plugin documentation for version compatibility before adding new plugins
- Some features (like `vim.api.nvim_create_autocmd` with `LspAttach`) require Neovim 0.8+

## Formatting Standards
- Lua files: Format with `stylua` (configured in Conform)
- Python files: Format with `isort` (imports) then `black` (code)
- JavaScript/TypeScript: Format with `prettier`
- Run `<leader>mp` to format current buffer manually
- Auto-formatting triggers on save for configured file types

## Debugging Tips
- Use `:messages` to see past notifications and errors
- Run `:checkhealth` to verify plugin health and configuration
- Check `:Lazy log` for plugin loading errors and warnings
- Enable debug logging with `:lua package.loaded["your.plugin"].debug = true` when troubleshooting
- Use `vim.fn.stdpath("data")` to locate Neovim data directory for logs

## Common Patterns
### Lazy-loading file-type specific plugins:
```lua
return {
  "plugin/author",
  ft = { "python", "lua" },
  opts = {},
}
```

### Setting up LSP buffers with LspAttach autocmd:
```lua
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  end,
})
```

### Configuring formatters with Conform:
```lua
conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
  },
  format_on_save = { lsp_fallback = true, async = false, timeout_ms = 1000 },
})
```

## Known Configuration Notes
- Snacks.nvim is configured with custom picker layouts (ivy, vertical) for improved workflow
- Avante.nvim integrates with MCP Hub for tool integration
- Tokyonight theme is customized with specific color overrides
- Bufferline uses "tabs" mode with "slant" separator style
- Treesitter has custom incremental selection keymaps (C-space, backspace)
- The configuration assumes availability of external tools: stylua, black, isort, prettier
