#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
RMBG_DIR="$SCRIPT_DIR"

echo "Installing rmbg..."

# Check dependencies
check_dep() {
  if ! command -v "$1" &> /dev/null; then
    echo "Installing $1..."
    if command -v brew &> /dev/null; then
      brew install "$2"
    else
      echo "Error: $1 not found and Homebrew not available"
      exit 1
    fi
  fi
}

check_dep "convert" "imagemagick"
check_dep "python3" "python"

# Install Python PIL if not available
if ! python3 -c "from PIL import Image" 2>/dev/null; then
  echo "Installing PIL..."
  pip3 install pillow
fi

# Create symlink in ~/bin
mkdir -p ~/bin
if [[ -L ~/bin/rmbg ]]; then
  rm ~/bin/rmbg
fi
ln -s "$RMBG_DIR/bin/rmbg" ~/bin/rmbg
echo "✓ Symlinked to ~/bin/rmbg"

# Add completion to shell
BASHRC="$HOME/.bashrc"
ZSHRC="$HOME/.zshrc"

if [[ -f "$BASHRC" ]] && ! grep -q "rmbg/completions" "$BASHRC"; then
  echo "source $RMBG_DIR/completions/rmbg.bash" >> "$BASHRC"
  echo "✓ Added bash completion"
fi

if [[ -f "$ZSHRC" ]] && ! grep -q "rmbg/completions" "$ZSHRC"; then
  echo "source $RMBG_DIR/completions/rmbg.bash" >> "$ZSHRC"
  echo "✓ Added zsh completion"
fi

# Install man page
MAN_DIR="$HOME/.local/share/man/man1"
mkdir -p "$MAN_DIR"
cp "$RMBG_DIR/man/man1/rmbg.1" "$MAN_DIR/"
mandb 2>/dev/null || true
echo "✓ Installed man page"

echo ""
echo "Installation complete!"
echo ""
echo "Usage:"
echo "  rmbg image.png"
echo "  rmbg folder/ -R -m logo"
echo ""
echo "Run 'rmbg -h' for options"