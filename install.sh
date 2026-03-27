#!/usr/bin/env bash
set -e

SKILL_REPO="https://github.com/Know-Your-People/know-your-people-skill"
SKILL_RAW="https://raw.githubusercontent.com/Know-Your-People/know-your-people-skill/main"
SKILLS_DIR="${HOME}/.openclaw/workspace/skills/people"
PEOPLE_DIR="${HOME}/.openclaw/workspace/people"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo "  Know Your People — OpenClaw Skill Installer"
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

# Download skill files
echo "  Downloading skill..."

FILES=("SKILL.md")

for file in "${FILES[@]}"; do
  curl -fsSL "${SKILL_RAW}/${file}" -o "${SKILLS_DIR}/${file}"
done

echo -e "${GREEN}✓ Skill installed to ${SKILLS_DIR}${NC}"

# Create people directory if it doesn't exist
if [ ! -d "$PEOPLE_DIR" ]; then
  mkdir -p "$PEOPLE_DIR"
  echo -e "${GREEN}✓ Created ${PEOPLE_DIR}${NC}"
else
  echo -e "${GREEN}✓ ${PEOPLE_DIR} already exists${NC}"
fi

# Create .peopleconfig.yml if it doesn't exist
CONFIG_FILE="${PEOPLE_DIR}/.peopleconfig.yml"
if [ ! -f "$CONFIG_FILE" ]; then
  cat > "$CONFIG_FILE" << 'EOF'
owner: <your-contact-file-slug> # set to your contact file slug (e.g. jane-smith)
EOF
  echo -e "${GREEN}✓ Created ${CONFIG_FILE}${NC}"
fi

echo ""
echo "  ──────────────────────────────────────────"
echo -e "  ${GREEN}All done.${NC} Start talking to your agent:"
echo ""
echo '  "Add a new contact — I just met someone called Leo at a design event."'
echo '  "Who do I know in fintech in Singapore?"'
echo '  "Draft an intro between Peter and Shaurya."'
echo ""
echo "  Enclave access (early): https://peepsapp.ai"
echo "  Source: ${SKILL_REPO}"
echo ""
