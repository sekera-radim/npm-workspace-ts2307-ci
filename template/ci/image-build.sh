#!/bin/bash
# What the container image build runs. It got the extra build step
# on the day the app started to depend on the library.
set -euo pipefail
npm ci --silent
npm run build -w @demo/libstrings
npm run typecheck -w @demo/app
