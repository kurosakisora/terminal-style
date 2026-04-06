#!/bin/bash
#
# terminal-style — One-click macOS terminal environment setup
#
# Stack: Ghostty + Zsh + Starship + MesloLGS Nerd Font
# Tools: bat, fzf, zoxide, lsd, ripgrep, fd, jq, starship
# Theme: Catppuccin Mocha (Starship) + green-eye-care (Ghostty)
#
# Usage:
#   ./setup.sh              # full install
#   ./setup.sh --dry-run    # preview only
#

set -euo pipefail

# ─── Colors ──────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'; BLUE='\033[0;34m'; BOLD='\033[1m'; NC='\033[0m'

DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC} $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

run_cmd() {
    if $DRY_RUN; then echo -e "${YELLOW}[DRY-RUN]${NC} $*"; else "$@"; fi
}

has_cmd() { command -v "$1" &>/dev/null; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─── macOS check ─────────────────────────────────────────────────────
[[ "$(uname -s)" != "Darwin" ]] && error "This script is for macOS only."

# ═══════════════════════════════════════════════════════════════════════
# Step 1: Homebrew
# ═══════════════════════════════════════════════════════════════════════
echo -e "\n${BOLD}  📦 Step 1/5: Homebrew${NC}"

if ! has_cmd brew; then
    info "Installing Homebrew..."
    run_cmd /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    success "Homebrew already installed"
fi

# ═══════════════════════════════════════════════════════════════════════
# Step 2: Ghostty
# ═══════════════════════════════════════════════════════════════════════
echo -e "\n${BOLD}  👻 Step 2/5: Ghostty${NC}"

if [[ ! -d "/Applications/Ghostty.app" ]]; then
    info "Installing Ghostty..."
    run_cmd brew install --cask ghostty
else
    success "Ghostty already installed"
fi

# ═══════════════════════════════════════════════════════════════════════
# Step 3: Fonts
# ═══════════════════════════════════════════════════════════════════════
echo -e "\n${BOLD}  🔤 Step 3/5: MesloLGS Nerd Font${NC}"

FONT_DIR="$HOME/Library/Fonts"
mkdir -p "$FONT_DIR"

FONT_INSTALLED=true
for f in "$SCRIPT_DIR"/fonts/MesloLGS*.ttf; do
    [[ ! -f "$FONT_DIR/$(basename "$f")" ]] && FONT_INSTALLED=false && break
done

if $FONT_INSTALLED; then
    success "MesloLGS NF fonts already installed"
else
    info "Installing fonts..."
    run_cmd cp "$SCRIPT_DIR"/fonts/MesloLGS*.ttf "$FONT_DIR/"
    success "Fonts installed"
fi

# Also install via cask for broader coverage
if ! brew list --cask font-meslo-lg-nerd-font &>/dev/null; then
    run_cmd brew install --cask font-meslo-lg-nerd-font
fi

# ═══════════════════════════════════════════════════════════════════════
# Step 4: CLI Tools
# ═══════════════════════════════════════════════════════════════════════
echo -e "\n${BOLD}  🛠  Step 4/5: CLI Tools${NC}"

BREW_TOOLS=(
    starship
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
    fzf
    zoxide
    bat
    lsd
    fd
    ripgrep
    jq
)

for tool in "${BREW_TOOLS[@]}"; do
    if brew list "$tool" &>/dev/null; then
        success "$tool"
    else
        info "Installing $tool..."
        run_cmd brew install "$tool"
        success "$tool installed"
    fi
done

# ═══════════════════════════════════════════════════════════════════════
# Step 5: Deploy Configs
# ═══════════════════════════════════════════════════════════════════════
echo -e "\n${BOLD}  📦 Step 5/5: Deploying Configs${NC}"

backup_and_copy() {
    local src="$1" dst="$2"
    if [[ -f "$dst" ]]; then
        run_cmd cp "$dst" "${dst}.bak.$(date +%Y%m%d%H%M%S)"
        warn "Backed up $(basename "$dst")"
    fi
    mkdir -p "$(dirname "$dst")"
    run_cmd cp "$src" "$dst"
    success "Deployed $(basename "$dst")"
}

# Ghostty
backup_and_copy "$SCRIPT_DIR/configs/ghostty/config" "$HOME/.config/ghostty/config"
mkdir -p "$HOME/.config/ghostty/themes"
run_cmd cp "$SCRIPT_DIR/configs/ghostty/themes/green-eye-care" "$HOME/.config/ghostty/themes/green-eye-care"
success "Deployed ghostty theme"

# Starship
backup_and_copy "$SCRIPT_DIR/configs/starship.toml" "$HOME/.config/starship.toml"

# Zshrc
backup_and_copy "$SCRIPT_DIR/configs/.zshrc" "$HOME/.zshrc"

# ─── Done ────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}  ✅ All done!${NC}"
echo ""
echo -e "  ${BOLD}Stack:${NC}"
echo -e "    👻 Ghostty + green-eye-care theme"
echo -e "    🐚 Zsh + autosuggestions + syntax-highlighting"
echo -e "    🚀 Starship (Catppuccin Mocha)"
echo -e "    🔤 MesloLGS Nerd Font"
echo -e "    📁 zoxide / fzf / bat / lsd / fd / ripgrep"
echo ""
echo -e "  ${YELLOW}Restart your terminal to apply changes.${NC}"
