# My Neovim Setup & Backup Guide

A beginner-friendly guide to **what's installed**, **how to use it**, and most
importantly **how to save (back up) this config** so you never lose it.

---

## 1. What you have

This config is [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) —
a small, single-file, well-commented starting point. It's already set up for:

| Language | Language Server (autocomplete/errors) | Formatter |
|----------|----------------------------------------|-----------|
| Python   | pyright                                | black + isort |
| Go       | gopls                                  | gofmt (built into Go) |
| Rust     | rust-analyzer                          | rustfmt (built into Rust) |
| Web (JS/TS/HTML/CSS) | ts_ls, html, cssls, emmet  | prettierd |
| C        | clangd                                 | clang |
| Lua      | lua_ls                                 | stylua |
| Markdown | marksman                               | prettierd |

The main config file is `init.lua`. Everything is installed automatically by a
plugin called **Mason** the first time you open Neovim.

---

## 2. Everyday usage (the essentials)

- **Leader key** is the Spacebar. Many shortcuts start with it.
- `<Space> s f` — **search files** by name (fuzzy finder)
- `<Space> s g` — **search inside files** (grep for text)
- `<Space> e` — toggle the **file explorer** (neo-tree)
- `g d` — **go to definition** (jump to where something is defined)
- `g r` — **find references** (everywhere a thing is used)
- `K` — **hover docs** (show info about the thing under the cursor)
- `<Space> c a` — **code action** (quick fixes, imports, etc.)
- `<Space> c r` — **rename** a symbol everywhere
- `<Space> f` — **format** the current file
- `[d` / `]d` — jump to previous/next **diagnostic** (error/warning)

Helpful checkup commands (type them in normal mode, they start with `:`):

- `:Lazy` — manage plugins (press `U` to update, `q` to quit)
- `:Mason` — see/install language servers & formatters
- `:checkhealth` — diagnose any problems with your setup

---

## 3. How to SAVE this config (the important part)

Your config lives in `~/.config/nvim` and is already a **git repository**. That
means every change can be saved as a snapshot. But right now it only exists on
**this laptop**. To truly back it up, push it to GitHub.

### One-time setup: push to GitHub

1. **Create a GitHub account** (if you don't have one): https://github.com/join

2. **Create a new EMPTY repository** on GitHub:
   - Go to https://github.com/new
   - Name it something like `nvim-config`
   - Choose **Private** (recommended — it's your personal setup)
   - Do **NOT** check "Add a README" — leave it empty
   - Click *Create repository*

3. **Connect your local config to it.** Copy the repo URL GitHub shows you
   (looks like `https://github.com/YOURNAME/nvim-config.git`), then run:

   ```sh
   cd ~/.config/nvim
   git add -A
   git commit -m "My working nvim setup"
   git branch -M main
   git remote add origin https://github.com/YOURNAME/nvim-config.git
   git push -u origin main
   ```

   (If git asks who you are the first time, run these once with your info:
   `git config --global user.name "Your Name"` and
   `git config --global user.email "you@example.com"`.)

Done — your config is now safely on GitHub.

### Every time you change something later

Whenever you tweak your config and want to save it:

```sh
cd ~/.config/nvim
git add -A
git commit -m "describe what you changed"
git push
```

Tip: the message is just a note to yourself, e.g. `"add python debugging"`.

---

## 4. How to RESTORE on a new computer

After installing Neovim + the tools (see section 5), run:

```sh
git clone https://github.com/YOURNAME/nvim-config.git ~/.config/nvim
nvim
```

The first launch will auto-install all plugins and language servers. Wait a
minute, then quit (`:qa`) and reopen. That's it — identical setup, anywhere.

> If `~/.config/nvim` already exists on the new machine, move it aside first:
> `mv ~/.config/nvim ~/.config/nvim.backup`

---

## 5. Tools this config needs (already installed on this Mac)

For reference / a new machine. On macOS with [Homebrew](https://brew.sh):

```sh
brew install neovim git ripgrep fd node go
# Rust:
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# Python is already on macOS; if you want a newer one: brew install python
```

- **neovim** — the editor
- **git** — version control & backup
- **ripgrep (rg)** + **fd** — power the file/text search
- **node** — required for the web language servers
- **go**, **rust** — their language servers + formatters

---

## 6. If something breaks

1. Run `:checkhealth` inside Neovim — it tells you what's wrong.
2. Run `:Lazy` then press `U` to update plugins.
3. Run `:Mason` to confirm language servers are installed (green check = good).
4. Worst case, you can always re-clone from GitHub (section 4).

You can't permanently break anything as long as your config is pushed to
GitHub — that's the whole point of backing it up.
