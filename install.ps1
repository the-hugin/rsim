$ErrorActionPreference = "Stop"

$RSIM_REPO = "https://github.com/the-hugin/rsim"
$BACKUP_DIR = "$HOME/.claude-backup-$(Get-Date -Format 'yyyy-MM-dd')"

# 1. Backup existing
if (Test-Path "$HOME/.claude") {
    Copy-Item "$HOME/.claude" $BACKUP_DIR -Recurse
    Write-Host "Backup: $BACKUP_DIR"
}

# 2. Download latest release
$TMP = Join-Path $env:TEMP "rsim-install-$(Get-Random)"
New-Item -ItemType Directory -Path $TMP -Force | Out-Null

gh release download --repo $RSIM_REPO --dir $TMP --pattern "rsim-*.zip"

$ZIP = Get-ChildItem "$TMP\rsim-*.zip" | Select-Object -First 1
$EXTRACTED = Join-Path $TMP "extracted"
New-Item -ItemType Directory -Path $EXTRACTED -Force | Out-Null
Expand-Archive -Path $ZIP.FullName -DestinationPath $EXTRACTED -Force

# 3. Install (replace skills/ commands/ CLAUDE.md, preserve memory/)
Copy-Item "$EXTRACTED\skills"   "$HOME/.claude\skills"   -Recurse -Force
Copy-Item "$EXTRACTED\commands" "$HOME/.claude\commands" -Recurse -Force
Copy-Item "$EXTRACTED\template\CLAUDE.md" "$HOME/.claude\CLAUDE.md" -Force

# 4. Create memory/ structure only if absent
$DIRS = @(
    "$HOME/.claude/memory/episodic/failures",
    "$HOME/.claude/memory/semantic"
)
foreach ($d in $DIRS) {
    New-Item -ItemType Directory -Path $d -Force | Out-Null
}

foreach ($f in @("hard-problems.md", "best-practices.md")) {
    $target = "$HOME/.claude/memory/episodic/$f"
    if (-not (Test-Path $target)) {
        Copy-Item "$EXTRACTED\memory\episodic\$f" $target
    }
}

$target = "$HOME/.claude/memory/semantic/patterns.md"
if (-not (Test-Path $target)) {
    Copy-Item "$EXTRACTED\memory\semantic\patterns.md" $target
}

Remove-Item $TMP -Recurse -Force
Write-Host "RSIm installed. Run /intake to start first project."
