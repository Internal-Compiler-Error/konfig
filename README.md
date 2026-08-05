# konfig

Dotfiles managed with [dotter](https://github.com/SuperCuber/dotter). Repo layout mirrors
deploy targets directly — no per-package nesting, no `<pkg>/.config/<pkg>/...` stutter.

```
config/<pkg>/...   -> ~/.config/<pkg>/...
home/gnupg/*.conf  -> ~/.gnupg/*.conf     (individual files only, see below)
```

## Install

```sh
paru -S dotter-rs-bin   # or build from source: cargo install dotter
```

## First-time setup on a machine

1. Clone this repo wherever you want it to live (e.g. `~/konfig`).
2. Create `.dotter/local.toml` — it's gitignored, since it's this machine's package
   selection, not shared config. Start from this template and trim to what this
   machine actually needs:

   ```toml
   packages = [
       "alacritty",
       "fish",
       "fontconfig",
       "git",
       "gnupg",
       "hypr",
       "kitty",
       "ncmpcpp",
       "newsraft",
       "nvim",
       "systemd",
       "tealdeer",
       "tmux",
       "waybar",
   ]
   ```

   A headless box, for instance, would drop `hypr` and `waybar`.

3. Preview before touching anything:

   ```sh
   dotter deploy --dry-run
   ```

4. Deploy:

   ```sh
   dotter deploy
   ```

## Day to day

- **Edit configs directly in the repo** (`config/fish/config.fish`, etc.) — they're
  deployed as real symlinks, so changes are live immediately, no redeploy needed.
- **Adding a new file to an already-linked package** — nothing to do. dotter maps
  whole directories, so anything you add under `config/fish/` is picked up on the
  next `dotter deploy` (idempotent — safe to run anytime, it no-ops if nothing changed).
- **Adding a new package** — add a `[<pkg>.files]` table to `.dotter/global.toml`
  mapping repo path to target, add `<pkg>` to `.dotter/local.toml`'s `packages`
  list, then `dotter deploy`.
- **Removing a package from this machine** — delete it from `.dotter/local.toml`'s
  `packages` list, then `dotter undeploy` to remove the symlinks (or `dotter deploy`,
  which also prunes symlinks for packages no longer enabled).

## Gotchas

**`{{` triggers Handlebars templating.** By default, any mapped file is treated as a
template if its content contains `{{`, and dotter renders it (copy, not symlink) —
which silently mangles files that happen to contain `{{` for unrelated reasons.
Two files in this repo hit that: `kitty.conf` uses `{{{`/`}}}` as vim fold markers,
and `nvim/.github/workflows/stylua.yml` has GitHub Actions `${{ }}` expressions.
Because of this, **every mapping in `.dotter/global.toml` is written with an explicit
`type = "symbolic"`**, not left to the default — that's deliberate, not decoration.
If you add a new package, copy that pattern:

```toml
[somepkg.files]
"config/somepkg" = { target = "~/.config/somepkg", type = "symbolic" }
```

not the bare-string shorthand (`"config/somepkg" = "~/.config/somepkg"`), unless you've
checked nothing inside contains `{{`.

**`gnupg` is linked file-by-file, never as a directory.** `~/.gnupg` holds live
keyrings (`private-keys-v1.d/`, `trustdb.gpg`, etc.) that must never be replaced by
a symlink into the repo. Only the two config files are mapped:

```toml
[gnupg.files]
"home/gnupg/common.conf" = { target = "~/.gnupg/common.conf", type = "symbolic" }
"home/gnupg/gpg-agent.conf" = { target = "~/.gnupg/gpg-agent.conf", type = "symbolic" }
```

If you add another gnupg config, add it the same way — don't map the directory.

**`systemd` units are listed individually, not as a directory.** `~/.config/systemd/user/`
also contains `hyprland-session.target.wants/`, a tree of absolute symlinks that
`systemctl --user enable` generates and manages. dotter can't safely walk that (it
errors on symlinks whose target doesn't currently resolve), and enablement state
isn't this repo's concern anyway — that's what `systemctl --user enable <unit>` is for.
After deploying new units: `systemctl --user daemon-reload`.

## Packages with unresolved drift

`fontconfig`, `kitty`, `newsraft`, and `nvim` had real (non-symlink) files already
sitting in `~/.config` when this repo was restructured, with content that had
diverged from what's tracked here. `dotter deploy` will refuse to touch those specific
files rather than guess which side is right — it prints `already exists and isn't a
symlink. Skipping.` and moves on.

To resolve one:

```sh
diff -r config/nvim ~/.config/nvim   # see what differs
```

Then either update the repo from what's live, or let dotter overwrite what's live
from the repo:

```sh
dotter deploy --force   # overwrites ALL unresolved conflicts across ALL packages —
                        # review the diff first, this is not scoped to one package
```

There's no per-file `--force` — it's all-or-nothing for the run, so resolve content
differences you care about before reaching for it.

## Commands reference

| Command | Effect |
|---|---|
| `dotter deploy --dry-run` | Preview changes, touches nothing |
| `dotter deploy` | Symlink everything enabled in `local.toml` |
| `dotter deploy --force` | Same, but overwrites non-symlink conflicts |
| `dotter undeploy` | Remove all symlinks this repo manages |
