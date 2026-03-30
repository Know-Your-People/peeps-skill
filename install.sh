#!/usr/bin/env bash
set -euo pipefail

SKILL_REPO="git@github.com:Know-Your-People/peeps-skill.git"
SKILL_RAW="https://raw.githubusercontent.com/Know-Your-People/peeps-skill/main"
SKILLS_DIR="${HOME}/.openclaw/workspace/skills/peeps"
PEEPS_DIR="${HOME}/.openclaw/workspace/peeps"

# Colors — use $'...' so \033 is a real ESC byte (single-quoted '\033' is literal backslash + digits)
GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
RED=$'\033[0;31m'
BOLD=$'\033[1m'
NC=$'\033[0m'

# Discord invite — blurple (#7289DA) → fuchsia (#EB459E) truecolor gradient on the URL
DISCORD_URL='https://discord.gg/q3zVtnYnGY'
print_discord_line() {
  local i len=${#DISCORD_URL} r g b p ch
  printf '  %s💬%s %sJoin the community on Discord:%s ' "$YELLOW" "$NC" "$BOLD" "$NC"
  for ((i = 0; i < len; i++)); do
    ch=${DISCORD_URL:i:1}
    if ((len > 1)); then
      p=$((i * 1000 / (len - 1)))
    else
      p=0
    fi
    r=$((114 + (235 - 114) * p / 1000))
    g=$((137 + (69 - 137) * p / 1000))
    b=$((218 + (250 - 218) * p / 1000))
    printf $'\033[38;2;%d;%d;%dm%s' "$r" "$g" "$b" "$ch"
  done
  printf '%s\n' "$NC"
}

echo ""
echo -e "${GREEN}  ██████╗ ███████╗███████╗██████╗ ███████╗${NC}"
echo -e "${GREEN}  ██╔══██╗██╔════╝██╔════╝██╔══██╗██╔════╝${NC}"
echo -e "${GREEN}  ██████╔╝█████╗  █████╗  ██████╔╝███████╗${NC}"
echo -e "${GREEN}  ██╔═══╝ ██╔══╝  ██╔══╝  ██╔═══╝ ╚════██║${NC}"
echo -e "${GREEN}  ██║     ███████╗███████╗██║     ███████║${NC}"
echo -e "${GREEN}  ╚═╝     ╚══════╝╚══════╝╚═╝     ╚══════╝${NC}"
echo ""
echo "  Building a good network is a skill. Do it with OpenClaw."
echo "  ──────────────────────────────────────────"
echo ""

# Check OpenClaw is installed
if ! command -v openclaw &> /dev/null; then
  echo -e "${RED}✗ OpenClaw not found.${NC}"
  echo ""
  echo "  Install OpenClaw first: https://openclaw.ai"
  echo ""
  exit 1
fi

echo -e "${GREEN}✓ OpenClaw found${NC}"

# Create skills directory
mkdir -p "$SKILLS_DIR"

# Download skill files (update vs first install)
if [ -f "${SKILLS_DIR}/SKILL.md" ]; then
  echo "  Updating skill..."
else
  echo "  Downloading skill..."
fi

FILES=("SKILL.md")

for file in "${FILES[@]}"; do
  curl -fsSL "${SKILL_RAW}/${file}" -o "${SKILLS_DIR}/${file}"
done

echo -e "${GREEN}✓ Skill installed to ${SKILLS_DIR}${NC}"

# Create workspace/peeps directory if it doesn't exist
if [ ! -d "$PEEPS_DIR" ]; then
  mkdir -p "$PEEPS_DIR"
  echo -e "${GREEN}✓ Created ${PEEPS_DIR}${NC}"
else
  echo -e "${GREEN}✓ ${PEEPS_DIR} already exists${NC}"
fi

# Create peepsconfig.yml if it doesn't exist
CONFIG_FILE="${PEEPS_DIR}/peepsconfig.yml"
if [ ! -f "$CONFIG_FILE" ]; then
  echo ""
  read -r -p "  Your full name (e.g. Jane Smith): " OWNER_NAME
  # Derive slug: lowercase, replace spaces with hyphens
  OWNER_SLUG=$(echo "$OWNER_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9-')

  echo "owner: ${OWNER_SLUG}" > "$CONFIG_FILE"

  echo -e "${GREEN}✓ Created ${CONFIG_FILE} (owner: ${OWNER_SLUG})${NC}"
  echo -e "${YELLOW}  Remember to create your own contact file: ${PEEPS_DIR}/${OWNER_SLUG}.md${NC}"
else
  echo -e "${GREEN}✓ ${CONFIG_FILE} already exists${NC}"
fi

echo ""
echo "  ──────────────────────────────────────────"
echo -e "  ${GREEN}Peeps installed.${NC} Start talking to your contacts:"
echo ""
echo '  "Add Leo Lawrence — we just met at a design event."'
echo '  "Who do I know in fintech in Singapore?"'
echo '  "Draft an intro between Peter and Shaurya."'
echo ""
print_discord_line
echo "  Source: ${SKILL_REPO}"
echo ""

# Install Dispatch skill (handles circle key setup and migration from any existing peepsconfig.yml)
echo "  ──────────────────────────────────────────"
echo -e "  ${BOLD}Installing Dispatch skill...${NC}"
echo ""
curl -fsSL https://raw.githubusercontent.com/Know-Your-People/dispatch-skill/main/install.sh | bash
