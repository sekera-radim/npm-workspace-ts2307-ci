#!/bin/bash
# What the CI pipeline job runs. A different file, written earlier.
set -euo pipefail
npm ci --silent
npm run typecheck -w @demo/app
