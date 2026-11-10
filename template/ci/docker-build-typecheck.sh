#!/bin/bash
# Simulates a container image build stage: fresh install, then typecheck.
set -euo pipefail
npm ci --offline --silent
npm run typecheck -w @demo/app
