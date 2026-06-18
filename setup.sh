#!/usr/bin/env sh
# ─────────────────────────────────────────────────────────────────────────────
# Hammerspoon + Karabiner-Elements setup
# ─────────────────────────────────────────────────────────────────────────────
# Run this once on a fresh macOS machine. You'll need to grant permissions
# after both apps are installed (System Settings → Privacy & Security).

set -e

echo "==> Installing Hammerspoon..."
brew install hammerspoon
#   macOS window manager and automation engine.
#   Runs ~/.hammerspoon/init.lua on login.

echo "==> Installing Karabiner-Elements..."
brew install karabiner-elements
#   Per-key remapping at the kernel level (SIP-friendly).
#   Required for: caps_lock → HYPER (used by hyperex.lua),
#   esc → ⌃⌥⌘ (used as the "coc" chord in init.lua),
#   right_cmd → escape, F-keys in terminals.

echo "==> Deploying Karabiner config..."
BACKUP="$HOME/.config/karabiner/karabiner.json.bak"
if [ -f "$HOME/.config/karabiner/karabiner.json" ]; then
  cp "$HOME/.config/karabiner/karabiner.json" "$BACKUP"
  echo "    Backed up existing karabiner.json → $BACKUP"
fi
mkdir -p "$HOME/.config/karabiner"
cp assets/karabiner/karabiner.json "$HOME/.config/karabiner/karabiner.json"
echo "    Copied assets/karabiner/karabiner.json"

echo ""
echo "Done. Next steps:"
echo "  1. Open Karabiner-Events → grant Input Monitoring"
echo "  2. Open Hammerspoon → grant Accessibility"
echo "  3. Restart both apps (or log out/in)"
echo ""
