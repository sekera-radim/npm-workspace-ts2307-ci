# npm workspaces: TS2307 Cannot find module in CI, but it works locally

A two-package npm workspace where `packages/app` imports `packages/lib` through its built `dist/`
(the `main`/`types` fields in `packages/lib/package.json` point there). `dist/` is gitignored and
never committed. Locally it typechecks because `dist/` exists from an earlier build; a clean clone
(a container image build, a CI job) runs `npm ci` into a repo that has no `dist/` yet, so `tsc`
fails with `TS2307: Cannot find module '@demo/libstrings'`. This repo reproduces that, reproduces the
same bug recurring independently in a second, unrelated job, and applies a fix that travels with the
package instead of living in one script.

    docker build -t ts2307-workspace .
    docker run --rm ts2307-workspace
