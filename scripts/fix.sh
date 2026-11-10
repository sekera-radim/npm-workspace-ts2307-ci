#!/bin/bash
# The fix lives in the package: typecheck builds its dependency first.
set -euo pipefail
cd ~/repo
npm pkg set scripts.pretypecheck="npm run build -w @demo/libstrings" -w @demo/app
git commit -qam "fix: build the library before typecheck"
echo "fix committed"
