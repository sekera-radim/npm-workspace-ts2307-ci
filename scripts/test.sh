#!/bin/bash
set -uo pipefail
fail() { echo "FAIL: $1"; exit 1; }
cd ~ && bash scripts/setup.sh >/dev/null

(cd ~/repo && npm run typecheck -w @demo/app >/dev/null 2>&1) \
  || fail "local typecheck should pass, dist is already built"
echo "ok 1 - locally it typechecks, packages/lib/dist already exists"

rm -rf ~/repo-ci && git clone -q ~/repo ~/repo-ci
(cd ~/repo-ci && npm ci --offline --silent && npm run typecheck -w @demo/app) \
  >/tmp/ci1.log 2>&1 && fail "a clean clone should fail with TS2307"
grep -q "TS2307" /tmp/ci1.log || fail "expected a real TS2307 error"
echo "ok 2 - a clean clone fails with the real TS2307"

rm -rf ~/repo-ci && git clone -q ~/repo ~/repo-ci
(cd ~/repo-ci && bash ci/docker-build-typecheck.sh) \
  >/tmp/ci2.log 2>&1 && fail "the image build script should still fail before the fix"
grep -q "TS2307" /tmp/ci2.log || fail "expected TS2307 in the image build script"
echo "ok 3 - the image build script fails the same way"

rm -rf ~/repo-ci && git clone -q ~/repo ~/repo-ci
(cd ~/repo-ci && bash ci/pipeline-typecheck.sh) \
  >/tmp/ci3.log 2>&1 && fail "the pipeline job should still fail before the fix"
grep -q "TS2307" /tmp/ci3.log || fail "expected TS2307 in the pipeline job"
echo "ok 4 - an independent pipeline job hits the same bug"

cd ~/repo
npm pkg set scripts.pretypecheck="npm run build -w @demo/libstrings" -w @demo/app
git add -A && git commit -qm "fix: build the dependency automatically before typecheck"
rm -rf ~/repo-ci && git clone -q ~/repo ~/repo-ci
(cd ~/repo-ci && bash ci/docker-build-typecheck.sh) >/tmp/ci4.log 2>&1 \
  || fail "the image build script should pass after the fix"
(cd ~/repo-ci && bash ci/pipeline-typecheck.sh) >/tmp/ci5.log 2>&1 \
  || fail "the pipeline job should pass after the fix, untouched"
echo "ok 5 - one fix in the package, both unmodified jobs pass"

echo "ALL PASSED"
