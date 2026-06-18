# Hammerspoon Config

My macOS automation setup — window management, keyboard remapping, app launching,
clipboard utilities, and VPN credential pasting.

## Prerequisites

- [Hammerspoon](https://www.hammerspoon.org/) — runs `init.lua` on login
- [Karabiner-Elements](https://karabiner-elements.pqrs.org/) — kernel-level key
  remapping required by the hyper key and coc chord

See [`install.sh`](install.sh) for a one-shot setup script.

Also requires the Karabiner config from [`assets/karabiner/`](assets/karabiner/):

```sh
cp -r assets/karabiner/ ~/.config/karabiner/
```

## Keyboard model

Two modifier chords are used throughout. Both come from Karabiner remapping,
not Hammerspoon itself (Hammerspoon cannot intercept modifier-key-down alone):

```
Karabiner                   Chord           Used as
─────────                   ─────           ───────
Caps Lock (held) → HYPER    ⇧⌘⌥⌃           4-finger chord
  Tap alone    → F19                        hyperex.lua trigger key
Escape   (held) → COC       ⌃⌥⌘            3-finger chord
  Tap alone    → Escape                     (no change)
```

The names used in `init.lua`:

```lua
local hyper = { 'command', 'option', 'shift', 'control' }  -- ⇧⌘⌥⌃
local coc = { 'control', 'option', 'command' }              -- ⌃⌥⌘
```

## Hotkeys

### HYPER + key (hold Caps Lock, press key)

| Chord | Action |
|---|---|
| `HYPER` + `0` | Fix selected text keyboard layout (EN↔UK) |
| `HYPER` + `6` | UPPERCASE selected text |
| `HYPER` + `7` | lowercase selected text |
| `HYPER` + `8` | Translate selected text (UK→EN) |
| `HYPER` + `9` | Translate selected text (EN→UK) |
| `HYPER` + `V` | Clipboard history popup |
| `HYPER` + `A..Z` | Switch to / launch app (see `apps-def.lua`) |

### COC + key (hold Escape, press key)

| Chord | Action |
|---|---|
| `COC` + `\` | Lock screen |
| `COC` + `Y` | Hide all windows (keeps Finder desktop) |
| `COC` + `U` | Paste VPN username |
| `COC` + `P` | Paste VPN password |
| `COC` + `` ` `` | Reload Hammerspoon config |
| `COC` + `6` | Toggle Hammerspoon console |

### Window Layout Mode

Activated by `⌃⌥⌘ + S` (COC chord + S). Inside the mode, Vim-style keys move the
focused window — the mode exits after each action.

See [`windows-bindings-defaults.lua`](windows-bindings-defaults.lua) for the full
key map and customization instructions.

## VPN password management

`COC` + `U` / `COC` + `P` paste VPN credentials into the active input field.
Values are stored in your macOS login keychain as a generic password with a JSON
payload, read via `/usr/bin/security` + `jq`.

### Setup

1. Open **Keychain Access** → **login** keychain.
2. Click **File** → **New Password Item…**.
3. Set:
   - **Keychain Item Name**: `vpn.infra`
   - **Account Name**: _(leave blank)_
   - **Password**: a JSON object with your credentials:

     ```json
     {"url":"vpn.company.com","username":"first.last","password":"s3cret"}
     ```

4. Click **Add**.

After reloading Hammerspoon (`COC` + `` ` ``), `COC` + `U` pastes the username
(`first.last`) and `COC` + `P` pastes the password (`s3cret`).

You can add multiple entries with different labels and hotkeys. The label
`vpn.infra` is hardcoded in `init.lua` — change it to match your own entry.

### Requirements

- [jq](https://jqlang.org/) — `brew install jq`

## Project structure

| File | Purpose |
|---|---|
| `init.lua` | Entry point, loads all modules and binds hotkeys |
| `hyperex.lua` | Hyper key engine — CHyper modifier system |
| `windows.lua` | Window positioning functions + Layout Mode modal |
| `windows-bindings-defaults.lua` | Default layout mode key bindings |
| `spoons.lua` | Spoon (plugin) installation and config |
| `kbl.lua` | Keyboard layout fixer — EN↔UK text transform |
| `launch.lua` | App launcher — re-launches hidden apps on wake |
| `launch-apps.lua` | App list for launch-on-wake |
| `apps.lua` / `apps-def.lua` | HYPER+key app switching |
| `keychain.lua` | Password pasting from macOS Keychain |
| `notify.lua` | URL event handler for task-completed notifications |
| `status-message.lua` | On-screen status overlay for layout mode |
| `util.lua` | Shared clipboard polling (`withCopiedSelection`) |
| `delete-words.lua` | Word-delete keybindings (disabled — conflicts) |
| `install.sh` | Automated setup script |
| `assets/karabiner/` | Drop-in Karabiner config with all rules |
