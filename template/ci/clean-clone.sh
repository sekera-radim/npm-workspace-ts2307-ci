#!/bin/bash
# Run a CI script the way CI does: in a fresh clone of the last commit,
# where nothing built or ignored on this machine exists.
set -euo pipefail
job=${1:-ci/pipeline.sh}
dir=$(mktemp -d)
trap 'rm -rf "$dir"' EXIT
git clone -q . "$dir"
cd "$dir"
bash "$job"
echo "clean clone: $job passed"
