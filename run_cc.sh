#!/bin/bash

RAW_DIR="data/raw"
PCD_DIR="data/pcd"

# Převod LAS → PCD pomocí CloudCompare (jen tento krok)
echo "🔁 Převádím LAS → PCD pomocí CloudCompare Dockeru..."
mkdir -p "$PCD_DIR"

for file in "$RAW_DIR"/*.las; do
    [ -e "$file" ] || continue
    fname=$(basename "$file" .las)
    echo "➡️  $fname.las → $fname.pcd (via CloudCompare)"

docker run --rm -v "$(pwd)/data:/data" cloudcompare-cli \
    -SILENT -AUTO_SAVE OFF \
    -O "/data/raw/$fname.las" \
    -C_EXPORT_FMT PCD \
    -NO_TIMESTAMP \
    -SAVE_CLOUDS FILE "/data/pcd/${fname}.pcd"
done

echo "✅ Převod LAS → PCD dokončen."
