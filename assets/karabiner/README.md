# Karabiner-Elements Setup

Required keyboard remapping for the Hammerspoon config. Drop this folder directly
over `~/.config/karabiner/` or copy `karabiner.json` individually.

## Install

```sh
brew install karabiner-elements
```

Open Karabiner-Elements, grant Input Monitoring permission when prompted, then:

```sh
cp -r assets/karabiner/ ~/.config/karabiner/
```

Restart Karabiner-Elements (or it picks up the file change automatically).

> **Warning:** This replaces your existing `~/.config/karabiner/karabiner.json`.
> Back it up first if you have custom rules: `cp ~/.config/karabiner/karabiner.json
> ~/.config/karabiner/karabiner.json.bak`

## What each rule does

| Rule | Why it's needed |
|---|---|
| **Caps Lock → HYPER or F19** | `hyperex.lua` binds to `F19` as the trigger. Hold Caps Lock for `⇧⌘⌥⌃` (the hyper chord used in `init.lua`). Tap alone sends `F19` → activates hyper mode. Also blocks macOS sysdiagnose shortcuts that conflict with the HYPER chord. |
| **Esc → ⌃⌥⌘ or Escape** | The "coc" chord (`⌃⌥⌘`) used in `init.lua` for system actions: lock screen, hide windows, paste credentials, reload config. Hold Esc for `⌃⌥⌘`, tap alone for normal Escape. |
| **Right Cmd → Escape or Left Ctrl** | Caps Lock is now HYPER, so you lose a dedicated Escape key. Right Cmd gives it back (tap → Escape, hold → Left Ctrl). |
| **F-keys for devs** | F1-F12 pass through as real function keys in terminals and editors (Terminal, iTerm2, VSCode, Zed, Ghostty). Brightness/media keys everywhere else. |

## How it ties together

```
Karabiner                     Hammerspoon
─────────                     ──────────
Caps Lock (held) → HYPER ──── hyper = {cmd,opt,shift,ctrl}  (hyperex.lua)
Caps Lock (tap)  → F19   ──── CHyper trigger key             (hyperex.lua)
Escape (held)    → ⌃⌥⌘  ──── coc  = {ctrl,opt,cmd}           (init.lua)
```
