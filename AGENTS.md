# Agent Guidelines

This repository is a [BlueBuild](https://blue-build.org/) recipe that builds a custom Fedora Atomic image (`ghcr.io/esteganobvio/guiso`) from `recipes/recipe.yml`.

## Build & Verification
- **Build**: Runs via the `bluebuild` GitHub Actions workflow (`.github/workflows/build.yml`) using the reusable `blue-build/github-action`. It triggers on push (except `**.md`), PR, daily cron, and `workflow_dispatch`.
- **Chunked images**: CI sets `build_chunked_oci: true` (runs `rpm-ostree compose build-chunked-oci`), so updates between builds download only changed chunks. Moving from the last non-chunked build to the first chunked build is a one-time full rebase.
- **Local builds** (require docker): validate with `bluebuild validate recipes/recipe.yml`; build with `bluebuild build recipes/recipe.yml --verbose`; to match CI's layout use `bluebuild build --build-chunked-oci recipes/recipe.yml`. Rebase a machine onto a local build with `bluebuild switch`.
- **Verification**: `cosign verify --key cosign.pub ghcr.io/esteganobvio/guiso`.
- **Testing**: No lint/test commands; all logic is declarative in `recipes/recipe.yml`.

## Configuration & Structure
- **Recipe (`recipes/recipe.yml`)**: Defines image layers via modules (`files`, `rpm-ostree`, `script`, `signing`) executed in order. **Order matters** — `signing` must stay last.
- **Files (`files/system/`)**: Copied verbatim to image root `/` (e.g. `system/etc/...` → `/etc/...`).
- **Scripts (`files/scripts/`)**: Executed during build **only if listed** in a `script` module in `recipe.yml`. Unreferenced scripts (e.g. `example.sh`) are dead code — add them to the recipe to run them.
- *Note*: `k3s.sh` installs to `/var/usrlocal/bin`, skipping auto-start.

## Signing & Secrets
- Signing is done by the `signing` module in CI using the `SIGNING_SECRET` GitHub secret; the private key (`cosign.key`) is gitignored. Public key: `cosign.pub`.
- Users rebase to the unsigned image first (to install signing keys/policy), then to the signed one — see `README.md`.

## Important Context
- **Base Image**: `ghcr.io/ublue-os/ucore-hci`, `image-version: stable` — keeps the same Fedora major version across builds.
- **Status**: Experimental Fedora Atomic image (rpm-ostree native containers).
