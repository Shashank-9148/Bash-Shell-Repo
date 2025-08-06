#!/bin/bash

# -----------------------------
# Bash File Backup Tool
# 
# -----------------------------

# Variables
timestamp=$(date "+%Y-%m-%d_%H-%M-%S")
backup_dir="$HOME/backups/$timestamp"
log_file="$HOME/backups/backup.log"
compress=false
remote=false
recent=""
nolog=false

mkdir -p "$backup_dir"

# -----------------------------
# Functions
# -----------------------------

log() {
    if [ "$nolog" = false ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$log_file"
    fi
}

show_help() {
    echo "Usage: ./backup.sh [OPTIONS] [FILES]"
    echo ""
    echo "Options:"
    echo "  --compress         Compress the backup into .tar.gz"
    echo "  --remote           Upload to remote server (configure manually)"
    echo "  --recent [1d|1h]   Backup recently modified files"
    echo "  --no-log           Disable logging"
    echo "  --help             Show this help message"
}

backup_file() {
    local file="$1"
    if [ -f "$file" ]; then
        cp "$file" "$backup_dir/$(basename "$file").bak"
        log "Backed up: $file -> $backup_dir/$(basename "$file").bak"
    else
        log "Skipped (not found): $file"
    fi
}

compress_backup() {
    tar_file="$HOME/backups/backup_$timestamp.tar.gz"
    tar -czf "$tar_file" -C "$backup_dir" .
    log "Compressed backup created: $tar_file"
    rm -r "$backup_dir"  # Clean up folder after compression
}

backup_recent_files() {
    find . -type f -mtime -1 | while read -r recent_file; do
        backup_file "$recent_file"
    done
}

# -----------------------------
# Argument Parsing
# -----------------------------

files=()

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --compress) compress=true ;;
        --remote) remote=true ;;  # Placeholder
        --no-log) nolog=true ;;
        --help) show_help; exit 0 ;;
        --recent) shift; recent="$1" ;;
        *) files+=("$1") ;;
    esac
    shift
done

# -----------------------------
# Execution
# -----------------------------

log "Backup started to $backup_dir"

if [ -n "$recent" ]; then
    log "Backing up files modified in last $recent"
    # For demo, using -1 day, not parsing '1h' or other durations yet
    backup_recent_files
else
    for file in "${files[@]}"; do
        backup_file "$file"
    done
fi

if [ "$compress" = true ]; then
    compress_backup
fi

log "Backup finished."

echo "Backup complete."
