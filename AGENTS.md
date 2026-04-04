# Agent Guidelines

This repository uses [BlueBuild](https://blue-build.org/) to create custom Fedora Atomic images.

## Build Commands

Building is managed by GitHub Actions via the `bluebuild` workflow.

- **Manual Build Trigger**: You can trigger a build manually via the GitHub Actions UI using the `workflow_dispatch` event.
- **Local Testing**: There are no standard "lint" or "test" commands for the image itself in this repo, as the "code" is a declarative recipe.
- **Script Execution**: Some scripts are executed during the build process (e.g., `k3s.sh`). You can test these locally if you have an environment set up for it.

## Code Style & Conventions

### Configuration (`recipes/recipe.yml`)
- **Declarative Format**: Use YAML for defining the image recipe.
- **Modules**: Use the `modules` list to specify operations in order.
    - `files`: For copying files from the repository to the image root.
    - `rpm-ostree`: For installing RPM packages.
    - `script`: For running shell scripts during the build.
    - `signing`: Required for generating signed images.
- **Ordering**: The order of modules matters; ensure dependencies between modules are respected.

### Scripts (`files/scripts/`)
- **Shell Scripts**: Use standard shell scripting practices.
- **Execution**: Scripts are called by the `script` module in the recipe.
- **Environment**: Remember that these scripts run within the build environment of the BlueBuild action.

### File Structure
- `files/system/`: Files placed here are copied to the root `/` of the image via the `files` module.
- `recipes/`: Contains the image recipe configuration.
- `files/scripts/`: Contains shell scripts used during the build.

## Important Notes
- This is an experimental Fedora Atomic image.
- Images are signed using `cosign`.
- Verification command: `cosign verify --key cosign.pub ghcr.io/esteganobvio/guiso`