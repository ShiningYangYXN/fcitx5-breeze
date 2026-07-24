#!/usr/bin/env bash
#
# package.sh - Build fcitx5-breeze and package the themes into a versioned archive.
#
# The version is the short git commit hash of the current tree. When the
# script is run outside a git repository (e.g. from a downloaded source
# tarball) it falls back to a UTC timestamp so packaging still works.
#
# Usage: bash package.sh
#
# Output: dist/fcitx5-breeze-<version>.tar.gz
#
# When running under GitHub Actions the version is also written to
# $GITHUB_OUTPUT so the workflow can name the uploaded artifact.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

# ---------------------------------------------------------------------------
# 1. Determine the version (hash as version number)
# ---------------------------------------------------------------------------
if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1 \
   && git rev-parse --short HEAD >/dev/null 2>&1; then
    VERSION="$(git rev-parse --short HEAD)"
else
    VERSION="$(date -u +%Y%m%d%H%M%S)"
fi
echo "Packaging version: ${VERSION}"

# ---------------------------------------------------------------------------
# 2. Build the themes
# ---------------------------------------------------------------------------
python3 build.py

# ---------------------------------------------------------------------------
# 3. Package
# ---------------------------------------------------------------------------
DIST="dist"
rm -rf "$DIST"
mkdir -p "$DIST"
ARCHIVE_BASE="fcitx5-breeze-${VERSION}"

# Tarball: theme directories sit at the archive root so it can be extracted
# straight into ~/.local/share/fcitx5/themes
tar -czf "${DIST}/${ARCHIVE_BASE}.tar.gz" -C build .

echo "Created: ${DIST}/${ARCHIVE_BASE}.tar.gz"

# ---------------------------------------------------------------------------
# 4. Expose the version to CI (GitHub Actions)
# ---------------------------------------------------------------------------
if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
    echo "version=${VERSION}" >> "$GITHUB_OUTPUT"
fi
