#!/bin/bash
# Pre-build script to clean extended attributes
echo "Cleaning extended attributes from Flutter frameworks..."
find "${BUILT_PRODUCTS_DIR}" -name "*.framework" -exec xattr -cr {} \; 2>/dev/null || true
find "${TARGET_BUILD_DIR}" -name "*.framework" -exec xattr -cr {} \; 2>/dev/null || true
echo "Extended attributes cleaned."
