# npm workspaces: TS2307 Cannot find module in CI, but it works locally

A two-package npm workspace. `packages/app` imports `packages/lib` through its
built `dist/` (the `main` and `types` fields of the library point there), and
`dist/` is in `.gitignore`.

- On your machine typecheck passes, because `dist/` is left over from an old build.
- In a clean clone (a CI job) `tsc` fails with
  `TS2307: Cannot find module '@demo/libstrings'`.
- One build script already builds the library first, the other one does not.
- The fix that covers every script: a `pretypecheck` script in the package.
- `ci/clean-clone.sh` runs any CI script in a fresh clone, so you see what CI sees.

Run it:

    docker build -t ts2307-workspace .
    docker run --rm ts2307-workspace

The image sets `npm config set offline true`, so every `npm ci` works from the
cache without a network. On your machine plain `npm ci` does the same job online.
