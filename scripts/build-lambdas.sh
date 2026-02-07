#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

SERVICE_DIR="$ROOT_DIR/services/me"
DIST_DIR="$SERVICE_DIR/dist"

mkdir -p "$DIST_DIR"

echo "--- BUILDING services/me ---"

npx esbuild "$SERVICE_DIR/handler.ts" \
  --bundle \
  --platform=node \
  --target=node20 \
  --outfile="$DIST_DIR/handler.js" \
  --minify

# Zip using Node script (cross-platform)
node "$SCRIPT_DIR/zip-lambda.mjs" "$DIST_DIR" "me.zip" "handler.js"

echo "Contents of $DIST_DIR:"
ls -la "$DIST_DIR"
