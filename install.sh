#!/usr/bin/env bash
set -e

RSIM_REPO="https://github.com/the-hugin/rsim"
BACKUP_DIR="$HOME/.claude-backup-$(date +%Y-%m-%d)"

# 1. Backup existing
if [ -d "$HOME/.claude" ]; then
  cp -r "$HOME/.claude" "$BACKUP_DIR"
  echo "Backup: $BACKUP_DIR"
fi

# 2. Download latest release
TMP=$(mktemp -d)
gh release download --repo "$RSIM_REPO" --dir "$TMP" --pattern "rsim-*.tar.gz"
mkdir -p "$TMP/extracted"
tar -xzf "$TMP"/rsim-*.tar.gz -C "$TMP/extracted"

# 3. Install (replace skills/ commands/ CLAUDE.md, preserve memory/)
cp -r "$TMP/extracted/skills/"    "$HOME/.claude/skills/"
cp -r "$TMP/extracted/commands/"  "$HOME/.claude/commands/"
cp    "$TMP/extracted/template/CLAUDE.md"  "$HOME/.claude/CLAUDE.md"

# 4. Create memory/ structure only if absent
mkdir -p "$HOME/.claude/memory/episodic/failures"
mkdir -p "$HOME/.claude/memory/semantic"

for f in hard-problems.md best-practices.md; do
  target="$HOME/.claude/memory/episodic/$f"
  [ -f "$target" ] || cp "$TMP/extracted/memory/episodic/$f" "$target"
done

target="$HOME/.claude/memory/semantic/patterns.md"
[ -f "$target" ] || cp "$TMP/extracted/memory/semantic/patterns.md" "$target"

rm -rf "$TMP"
echo "RSIm installed. Run /intake to start first project."
