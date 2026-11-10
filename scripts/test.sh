#!/bin/bash
set -uo pipefail
fail() { echo "FAIL: $1"; exit 1; }
cd ~ && bash scripts/setup.sh >/dev/null || fail "setup"
cd ~/repo

npm run typecheck -w @demo/app >/dev/null 2>&1 || fail "local typecheck should pass, dist is already built"
echo "ok 1 - locally it typechecks: packages/lib/dist exists from an old build"

bash ci/clean-clone.sh ci/pipeline.sh >/tmp/t2.log 2>&1 && fail "a clean clone should fail"
grep -q "TS2307" /tmp/t2.log || fail "expected a real TS2307 error"
echo "ok 2 - the pipeline job in a clean clone fails with TS2307"

bash ci/clean-clone.sh ci/image-build.sh >/dev/null 2>&1 || fail "the image build has its own build step and should pass"
echo "ok 3 - the image build passes: it builds the library itself"

bash ~/scripts/fix.sh >/dev/null || fail "fix"
bash ci/clean-clone.sh ci/pipeline.sh >/dev/null 2>&1 || fail "the pipeline job should pass after the fix"
echo "ok 4 - with pretypecheck in the package, the untouched pipeline job passes"

echo "ALL PASSED"
