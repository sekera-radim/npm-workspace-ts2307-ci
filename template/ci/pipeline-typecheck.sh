#!/bin/bash
# A separate CI pipeline job, written independently of the image build above.
set -euo pipefail
npm ci --offline --silent
npm run typecheck -w @demo/app
