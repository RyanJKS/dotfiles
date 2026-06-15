# dotfiles

Opinionated personal dotfiles managed with GNU Stow.

Each top-level directory in this repository is a standalone Stow package. That keeps installation predictable now and keeps the repo easy to extend as more tools are added later.

## Managed packages

| Package | Target path | Notes |
| --- | --- | --- |
| `nvim` | `~/.config/nvim` | LazyVim-based Neovim setup with custom snacks and formatting behavior. |
| `yazi` | `~/.config/yazi` | Yazi configuration with custom keymaps and file-management shortcuts. |
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

| Command | Purpose |
| --- | --- |
| `bootstrap` | Install base dependencies required to manage the repo on apt-based Linux systems. |
| `list` | Show all available Stow packages detected in the repository. |
| `path` | Print the repository root and current target directory. |
| `install [packages...]` | Symlink all packages, or only the named packages, into the target directory. |
| `restow [packages...]` | Re-apply packages using `stow --restow` after config changes. |
| `uninstall [packages...]` | Remove symlinks for all packages, or only the named packages. |
| `preview [packages...]` | Dry-run a Stow operation so you can inspect the symlink plan before changing anything. |
| `conflicts [packages...]` | Detect path collisions that would block a clean install. |
| `doctor` | Check required commands, target path readiness, and package availability. |
| `validate` | Validate scripts, package structure, and Stow compatibility. |
| `new <package> [path]` | Scaffold a new package directory, defaulting to `.config/<package>`. |

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

- `nvim` for the `nvim` package
- `yazi` for the `yazi` package
- `zellij` for the `zellij` package

The helper CLI checks for managed application binaries in `doctor`, but it does not install every application automatically because package sources and preferred versions vary by machine.

## Repository layout

```text
.
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
