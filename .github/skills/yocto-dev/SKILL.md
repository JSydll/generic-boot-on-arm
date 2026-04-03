---
name: yocto-dev
description: Guide to write and update Yocto recipes and configuration files, following best practices and conventions.
---

# Yocto Developer Skill

Use this skill when asked to add or update Yocto recipes and to cover it with tests.

## Skill Purpose

- Add or update recipe sources under `meta-generic-boot/recipes-*`.
- Integrate packages into image recipes (e.g., `meta-generic-boot/recipes-core/images/*.bb`).
- Extend test coverage for recipes and images.

## Technologies and Languages

- Embedded Linux
- `bitbake`
- `python`
- `shell`

## Conventions and Best Practices

### Code Organization

- Adhere to a standard Yocto layer structure.
- Follow the same recipe categorization approaches as in meta-oe or meta-poky. For example, put board-specific recipes in `recipes-bsp`, recipes for the main system functions in `recipes-core`, kernel recipes in `recipes-kernel` etc.
- Put `bbappends` in the same parent directory structure as the recipes they patch. However, only append to recipes in foreign layers.
- Use `bbclasses` for logic that is expected to be reused.
- Respect the boundaries of each Yocto layer - only include what's part of the "public interface".

### Recipe Implementation

- Write self-contained recipes - if data from other recipes is required, it shall be deployed in `DEPLOY_DIR_IMAGE`.
- Provide variables for logic that is expected to be configurable on upper layers.
- If a package should be extensible, either use `PACKAGECONFIG` or split out the extensions into separate recipes.
- Design packages to support configuration drop-ins for runtime variants.
- Explicitly express dependencies using `RDEPENDS:${PN}`.
- Use built-in bitbake variables to specify filesystem paths (e.g. `${sysconfdir}`, `${bindir}`, etc).
- Use the new override syntax (`:`).
- When creating patches for external packages, include the patch status according to the Yocto documentation.
- Only deploy files to `DEPLOYDIR` and inherit the `deploy` class to do the rest.
- When including or requiring files (in particular `.inc` files), use relative paths only (i.e. from the Yocto layer's root).

### Integration

- Prefer configuration-by-installation over `local.conf` customizations.
- Make use of `IMAGE_FEATURES` to pack together image contents required for an overall product feature.
- Make cross-package configuration explicit via `DISTRO_FEATURES`.
- Avoid using `ROOTFS_POSTPROCESS_COMMANDS` whenever possible.
- Avoid adjusting the configuration via the `*-pn-<recipe-name>` syntax in the `local.conf` - create appropriate `bbappend`s instead, if applicable.

### Build Configuration

- Only use `local.conf` for truly global configuration.
- Only use external environment variables for per-build-configuration.

## Gotchas

- Always source `./env-init` before running any build or test commands to set up the environment.
- QA warnings like "host-user-contaminated" indicate absolute paths or host-specific data in packages—fix by using proper variables.

## Writing Recipes

Follow this checklist to work on a recipe:

- [ ] Locate or create the recipe file at `meta-generic-boot/recipes-*/<packagename>/<packagename>_<version>.bb`.
- [ ] Add essential metadata: `SUMMARY`, `DESCRIPTION`, `LICENSE`, `LIC_FILES_CHKSUM`.
- [ ] Specify `SRC_URI` with checksums; use `SRCREV` for git sources.
- [ ] Define `DEPENDS` and `RDEPENDS:${PN}` for build and runtime dependencies.
- [ ] Specify `FILES:${PN}` to list installed files.
- [ ] Inherit appropriate classes (e.g., `autotools`, `cmake`) and follow standard task flow.
- [ ] Minimize custom task overrides; prefer class behavior and `oe_runmake`.
- [ ] Verify the result:
      - Recipe builds without errors (run `build-current`)
      - Package appears in image rootfs manifest
      - No QA errors or warnings (check build logs)
      - If applicable: Test coverage added and passes (run `test-run-pytest`)
      - No host absolute paths in packages are used (check for "host-user-contaminated")
- [ ] Update documentation (e.g., `Readme.md`) if needed.
- [ ] Review that all conventions and best practices above have been considered.

## Local Commands

- `source ./env-init`
- `build-current`
- `build-shell; <bitbake|bitbake-getvar|bitbake-layers|devtool command>`
- `test-run-pytest`