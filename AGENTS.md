# Repository Guidelines

## Project Structure & Module Organization

This repository contains a personal Neovim configuration focused on PHP and web development. `init.lua` bootstraps lazy.nvim, loads plugin specifications, and enables shared configuration.

- `lua/plugins/`: active lazy.nvim plugin specifications; each file returns a plugin table.
- `lua/vim-options.lua`, `lua/keymaps.lua`, and `lua/autocommands.lua`: shared editor settings, shortcuts, and event handlers.
- `lua/custom/` and `lua/config/`: supporting Lua modules and specialized configuration.
- `lua/inw/`: alternative or experimental specifications; these are not automatically imported by the current lazy.nvim setup.
- `lua/assets/`: text artwork for dashboards.

There is no dedicated test directory or build system. `README.md` documents the configuration and external dependencies.

## Development & Validation Commands

- `nvim`: launch the configured editor and exercise changed functionality.
- `nvim --headless -i NONE '+qa!'`: smoke-check startup without reading or writing ShaDa; inspect output for configuration errors.
- `:Lazy`: inspect plugin loading and installation status. Use updates deliberately because upstream API changes can break mappings.
- `:checkhealth`: diagnose missing dependencies and plugin integration problems.
- `git diff --check`: detect whitespace errors before committing.

Initial startup can download lazy.nvim and plugins. External tools include ripgrep, npm, language servers, and formatters; inspect the relevant plugin specification before installing dependencies.

## Coding Style & Naming Conventions

Follow the surrounding Lua style and preserve existing indentation; much of the configuration uses four spaces, with some tab-indented modules. Use descriptive plugin filenames consistent with nearby files, such as `smart_splits_nvim.lua`. Keep plugin-specific setup and mappings together. Avoid unrelated formatting changes.

Conform configures StyLua for Lua via `<leader>gf`; no repository-wide StyLua configuration is present. `.clang-format` defines JavaScript formatting. nvim-lint runs PHPStan for PHP files.

Present changes to be approved by developer before writing to the files

## Testing Guidelines

No automated testing framework or coverage target is configured. For changes, check startup and manually exercise affected shortcuts, filetypes, or events. For plugin upgrades, verify referenced functions exist in the installed version and test lazy-loading behavior. Report commands used and observed results.

## Commit & Pull Request Guidelines

Git history uses short, descriptive subjects such as “Add a quick terminal shortcut.” Follow that pattern and keep changes focused. Pull requests should explain the problem, resulting behavior, and validation performed. Link relevant issues and include screenshots for visible UI changes. Do not commit credentials, license keys, or generated logs; `lazy-lock.json` is currently ignored.
