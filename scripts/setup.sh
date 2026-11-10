#!/bin/bash
# A workspace repo with dist already built, like after you built it yourself a while ago.
set -euo pipefail
rm -rf ~/repo && cp -r ~/template ~/repo && cd ~/repo
npm ci --offline --silent
git init -q && git add -A && git commit -qm "init: workspace with lib and app"
npm run build -w @demo/libstrings --silent
echo "repo ready at ~/repo (packages/lib/dist exists from a local build)"
