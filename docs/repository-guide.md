# Repository guide

This document defines the maintenance contract for the dotfiles repository so it stays predictable as more packages are added.

## Core model

- Each top-level directory is a GNU Stow package.
- Each package mirrors the final filesystem layout under the install target, usually `$HOME`.
- `scripts/` is reserved for repo automation.
- `docs/` is reserved for repository and maintenance documentation.
- Hidden top-level directories such as `.git`, `.codex`, or `.serena` are not managed packages.

The helper CLI in `scripts/dotfiles` depends on that contract. If a new package is added as a normal top-level directory, the CLI will discover it automatically.

## Package conventions

Use these conventions for every new package:

1. Name the top-level directory after the tool or concern being managed, such as `tmux`, `ghostty`, or `git`.
2. Reproduce the destination path exactly inside that package.
3. Keep unrelated tools in separate packages instead of creating a generic catch-all directory.
4. Prefer XDG-style locations when the tool supports them.
5. Keep package-specific notes in the main README until the package becomes large enough to justify its own doc.

Example:

```text
tmux/
└── .config/
    └── tmux/
        └── tmux.conf
```

After `./scripts/dotfiles install tmux`, that file will be linked to `~/.config/tmux/tmux.conf`.

## High-leverage helper commands

These are the commands maintainers should use by default:

- `./scripts/dotfiles preview [packages...]`
- `./scripts/dotfiles conflicts [packages...]`
- `./scripts/dotfiles validate`
- `./scripts/dotfiles new <package> [path]`
- `./scripts/validate`

The goal is to catch problems before symlinks are written into a real home directory.

## Adding a new package

1. Scaffold the package with `./scripts/dotfiles new <package>` or create the package directory manually.
2. Add the real managed files under the correct destination path.
3. Install the underlying application locally if needed.
4. Run `./scripts/dotfiles doctor`.
5. Run `./scripts/dotfiles preview <package>`.
6. Run `./scripts/dotfiles conflicts <package>`.
7. Run `./scripts/dotfiles restow <package>`.
8. Validate that the application starts correctly and picks up the linked config.
9. Update [README.md](/home/ryanjks/CodeHaven/Personal-Projects/dotfiles/README.md) with:
   - The package name
   - The target path
   - Any required dependencies
   - Any first-run or migration caveats
10. Add deeper documentation under `docs/` only when the package has setup complexity that would bloat the README.

## Validation workflow

Before committing changes that touch packages or automation:

1. Run `./scripts/dotfiles validate`.
2. Run `./scripts/dotfiles preview`.
3. Run `./scripts/dotfiles conflicts`.
4. If you changed a package, run `./scripts/dotfiles restow <package>` or install it into a preview target.

For risky changes, use:

```bash
./scripts/dotfiles --target "$HOME/.dotfiles-preview" install
```

That keeps the live home directory untouched while you verify the symlink layout.

## Documentation standards

Use the README as the public entry point:

- Keep the quick start current.
- Keep the managed package table complete.
- Keep CLI examples aligned with `scripts/dotfiles`.
- Document new helper commands when they materially change workflow.

Add `docs/` content when one of these is true:

- A package needs non-trivial setup instructions.
- A package has platform-specific caveats.
- A change introduces maintenance policy that should not live in the README.

## Scope boundaries

Avoid putting these concerns into the repo helper:

- Package-manager-specific installation for every managed app
- Machine secrets
- Host-specific paths that do not generalize
- Destructive migration logic

The repo should stay easy to clone, inspect, and link. Complex one-off setup belongs in separate package-specific docs or local machine notes, not in the default install path.
