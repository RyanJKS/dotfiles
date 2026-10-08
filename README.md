# dotfiles

Opinionated personal dotfiles managed with GNU Stow.

Each top-level directory in this repository is a standalone Stow package. That keeps installation predictable now and keeps the repo easy to extend as more tools are added later.

## Managed packages

| Package  | Target path        | Notes                                                                  |
| -------- | ------------------ | ---------------------------------------------------------------------- |
| `git` | `~/.config/git/config` | Hunk pager and difftool without managing your Git identity. |
| `hunk` | `~/.config/hunk` | Hunk diff viewer with terminal colors, side-by-side layout, and line numbers. |
| `lazygit` | `~/.config/lazygit` | Side-by-side Delta rendering and interactive Hunk reviews. |
| `nvim`   | `~/.config/nvim`   | LazyVim-based Neovim setup with custom snacks and formatting behavior. |
| `yazi`   | `~/.config/yazi`   | Yazi configuration with custom keymaps and file-management shortcuts.  |
| `zellij` | `~/.config/zellij` | Zellij configuration with modal keybindings and tmux-style navigation. |

## Quick start

```bash
git clone git@github.com:RyanJKS/dotfiles.git
cd dotfiles
./scripts/dotfiles bootstrap
./scripts/dotfiles doctor
./scripts/dotfiles preview
./scripts/dotfiles install
```

`bootstrap` installs the base tooling needed to work with the repo on Debian or Ubuntu. `doctor` checks local prerequisites. `preview` shows the exact Stow plan before touching your home directory. `install` creates the symlinks.

If you already use `scripts/install.sh`, it still works, but it now delegates to `./scripts/dotfiles bootstrap` so there is one supported bootstrap path.

## Helper CLI

Use the repo helper instead of memorizing raw `stow` commands:

```bash
./scripts/dotfiles help
./scripts/dotfiles list
./scripts/dotfiles preview
./scripts/dotfiles conflicts
./scripts/dotfiles install nvim
./scripts/dotfiles restow nvim yazi
./scripts/dotfiles uninstall zellij
./scripts/dotfiles validate
./scripts/dotfiles new tmux
```

### Commands

| Command                   | Purpose                                                                                |
| ------------------------- | -------------------------------------------------------------------------------------- |
| `bootstrap`               | Install base dependencies required to manage the repo on apt-based Linux systems.      |
| `list`                    | Show all available Stow packages detected in the repository.                           |
| `path`                    | Print the repository root and current target directory.                                |
| `install [packages...]`   | Symlink all packages, or only the named packages, into the target directory.           |
| `restow [packages...]`    | Re-apply packages using `stow --restow` after config changes.                          |
| `uninstall [packages...]` | Remove symlinks for all packages, or only the named packages.                          |
| `preview [packages...]`   | Dry-run a Stow operation so you can inspect the symlink plan before changing anything. |
| `conflicts [packages...]` | Detect path collisions that would block a clean install.                               |
| `doctor`                  | Check required commands, target path readiness, and package availability.              |
| `validate`                | Validate scripts, package structure, and Stow compatibility.                           |
| `new <package> [path]`    | Scaffold a new package directory, defaulting to `.config/<package>`.                   |

For maintainers, `./scripts/validate` is a convenience wrapper around `./scripts/dotfiles validate`.

By default, the target directory is `$HOME`. Override it with either `DOTFILES_TARGET` or `--target`:

```bash
./scripts/dotfiles --target "$HOME/.dotfiles-preview" preview nvim
DOTFILES_TARGET="$HOME/.dotfiles-preview" ./scripts/dotfiles install
```

That is useful for testing or previewing the package layout without touching your live config.

## Requirements

Required to manage the repo:

- `bash`
- `git`
- `stow`

Useful for the helper workflows:

- `find`
- `mktemp`
- `readlink`

Required to use individual packages:

- `git` and `hunk` for the `git` package
- `hunk` for the `hunk` package
- `lazygit` and `delta` ([Delta](https://github.com/dandavison/delta#installation)) for the `lazygit` package
- `nvim` for the `nvim` package
- `yazi` for the `yazi` package
- `zellij` for the `zellij` package

The helper CLI checks for managed application binaries in `doctor`, but it does not install every application automatically because package sources and preferred versions vary by machine.

## Hunk diff reviews

Install Hunk using its [installation guide](https://github.com/modem-dev/hunk#install), then link the configuration:

```bash
./scripts/dotfiles install git hunk lazygit nvim
```

The Git package sets `hunk pager --mode split` as the default pager and Hunk as the difftool. Existing settings in `~/.gitconfig` take precedence over `~/.config/git/config`; remove any old pager, difftool, or Delta filter overrides there if needed. `git diff` and `git show` open Hunk, and `git difftool` compares files in Hunk. Use `hunk diff` to include untracked files.

Hunk defaults to side-by-side comparisons of old and new content, including Git pager and difftool reviews. Neovim's built-in diff windows also split vertically. LazyGit uses Delta to render old and new content beside each other inside its default diff pane, including when opened in Neovim with `<leader>gg`. Its staged and unstaged pane layout keeps the default behavior. Review, stage, commit, and push in LazyGit; open Hunk for a separate full review.

Neovim opens Hunk in a full-size terminal at the Git root:

- `<leader>gd`: review working-tree changes.
- `<leader>gD`: review staged changes.
- `<leader>gW`: watch working-tree changes.
- `<leader>gH`: browse commit history.
- `:Hunk`: review working-tree changes, or pass arguments such as `:Hunk show HEAD~1`.

These diff mappings replace the corresponding LazyVim diff picker mappings. Quit Hunk with `q` to return to Neovim.

In LazyGit, press `H` in the files panel to review working-tree changes, `I` to review staged changes, or `H` in the commits panel to review the selected commit. Hunk runs in the terminal while LazyGit is suspended. Delta renders the embedded diff pane because Hunk requires its own interactive terminal.

## Repository layout

```text
.
├── git/                     # Stow package -> ~/.config/git/config
├── hunk/                    # Stow package -> ~/.config/hunk
├── lazygit/                 # Stow package -> ~/.config/lazygit
├── docs/                    # Maintainer documentation
├── nvim/                    # Stow package -> ~/.config/nvim
├── scripts/                 # Repo helper scripts
├── yazi/                    # Stow package -> ~/.config/yazi
└── zellij/                  # Stow package -> ~/.config/zellij
```

Package directories mirror the filesystem layout you want in the destination. For example, `nvim/.config/nvim/init.lua` becomes `~/.config/nvim/init.lua` once stowed.

## Daily workflow

Install everything:

```bash
./scripts/dotfiles install
```

Install one package:

```bash
./scripts/dotfiles install yazi
```

Preview and check for conflicts before linking:

```bash
./scripts/dotfiles preview
./scripts/dotfiles conflicts
```

Re-link after editing configs:

```bash
./scripts/dotfiles restow
```

Remove one package:

```bash
./scripts/dotfiles uninstall zellij
```

Validate the repo before committing:

```bash
./scripts/dotfiles validate
./scripts/validate
```

Scaffold a new package:

```bash
./scripts/dotfiles new tmux
./scripts/dotfiles new ghostty .config/ghostty
```

## GNU Direct Operations

Other direct Stow operations follow the same pattern:

# Preview

stow --simulate --verbose --target="$HOME" lazygit

# Install

stow --target="$HOME" lazygit

# Re-apply

stow --restow --target="$HOME" lazygit

# Uninstall

stow --delete --target="$HOME" lazygit

## Extending the repo

To add a new managed tool:

1. Create a new top-level package directory named after the tool, for example `tmux/`, or scaffold it with `./scripts/dotfiles new tmux`.
2. Mirror the target filesystem layout inside that package, for example `tmux/.config/tmux/tmux.conf`.
3. Run `./scripts/dotfiles preview tmux` and `./scripts/dotfiles conflicts tmux`.
4. Run `./scripts/dotfiles restow tmux` to verify the package links cleanly.
5. Add the package to the table in this README.
6. Document any tool-specific prerequisites, caveats, or setup steps.

The helper CLI discovers packages dynamically, so new top-level package directories start working automatically as long as they follow the same Stow package layout.

## Safety and troubleshooting

- If `stow` reports a conflict, move or back up the existing file in your home directory before installing the package.
- Run `./scripts/dotfiles conflicts` before a first install on a machine that already has local config files.
- Use `./scripts/dotfiles doctor` before the first install on a new machine.
- Use `./scripts/dotfiles preview` before applying larger changes.
- Use a preview target such as `--target "$HOME/.dotfiles-preview"` when testing larger changes.
- Keep machine-specific scratch files in ignored local files rather than committing them into a shared package.

## Maintainer documentation

See [docs/repository-guide.md](docs/repository-guide.md) for the package contract, validation workflow, and contributor guidance for future additions.
