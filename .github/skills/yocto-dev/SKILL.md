---
name: yocto-dev
description: Guide to add and update Yocto recipes, following best practices and conventions.
license: MIT
---

# Yocto developer skill

Use this skill when asked to add or update Yocto recipes and to cover it with tests.

## Skill purpose

- Add or update recipe sources under `meta-generic-boot/recipes-*`.
- Integrate packages into image recipes (e.g., `meta-generic-boot/recipes-core/images/*.bb`).
- Extend test coverage for recipes and images.

## Conventions and best practices

### Code organization

- Adhere to a standard Yocto layer structure.
- Put `bbappends` in the same directory structure as the recipes they patch.
- Use `bbclasses` for logic that is expected to be reused.
- Respect the boundaries of each Yocto layer - only include what's part of the "public interface".

### Recipe implementation

- Write self-contained recipes - if data from other recipes is required, it shall be deployed in `DEPLOY_DIR_IMAGE`.
- Provide variables for logic that is expected to be configurable on upper layers.
- If a package should be extensible, either use `PACKAGECONFIG` or split out the extensions into separate recipes.
- Design packages to support configuration drop-ins for runtime variants.
- Explicitly express dependencies using `RDEPENDS:${PN}`.
- Use built-in bitbake variables to specify filesystem paths (e.g. `${sysconfdir}`, `${bindir}`, etc).
- Use the new override syntax (`:`).
- When creating patches for external packages, include the patch status according to the Yocto documentation.
- Deploy files only to `DEPLOYDIR` and inherit the `deploy` class to do the rest.
- When including or requiring files (in particular `.inc` files), use relative paths only (i.e. from the Yocto layer's root).

### Integration

- Prefer configuration-by-installation over `local.conf` customizations.
- Make use of `IMAGE_FEATURES` to pack together image contents required for an overall product feature.
- Make cross-package configuration explicit via `DISTRO_FEATURES`.
- Avoid using `ROOTFS_POSTPROCESS_COMMANDS` whenever possible.

### Build configuration

- Only use `local.conf` for truly global configuration.
- Only use external environment variables for per-build-configuration.

## Gotchas

- Always source `./env-init` before running any build or test commands to set up the environment.
- QA warnings like "host-user-contaminated" indicate absolute paths or host-specific data in packages—fix by using proper variables.

## Writing recipes

Follow this checklist to work on a recipe:

- [ ] Choose the best recipe category (e.g., `recipes-bsp` for board-specific, `recipes-kernel` for kernel) based on meta-oe and similar layers.
- [ ] Create the recipe file at `meta-generic-boot/recipes-*/<packagename>/<packagename>_<version>.bb`.
- [ ] Add essential metadata: `SUMMARY`, `DESCRIPTION`, `LICENSE`, `LIC_FILES_CHKSUM`.
- [ ] Specify `SRC_URI` with checksums; use `SRCREV` for git sources.
- [ ] Define `DEPENDS` for build dependencies and `RDEPENDS:${PN}` for runtime dependencies.
- [ ] Specify `FILES:${PN}` to list installed files.
- [ ] Inherit appropriate classes (e.g., `autotools`, `cmake`) and follow standard task flow.
- [ ] Minimize custom task overrides; prefer class behavior and `oe_runmake`.
- [ ] Verify the result:
      - Recipe builds without errors: `build-current`
      - Package appears in image rootfs manifest
      - No QA errors or warnings (check build logs)
      - If applicable: Test coverage added and passes: `test-run-pytest`
      - No host absolute paths in packages (check for "host-user-contaminated")
- [ ] Update documentation (e.g., Readme.md if needed)
- [ ] Review that all conventions and best practices above have been considered.

## Writing system tests

1. Add test file under `test/`: e.g., `test/test_<feature>/<behavior-under-test>_test.py`.
2. Use fixtures from `test/conftest.py`.
3. Follow `pytest` conventions.
4. Tag tests appropriately (e.g., `@pytest.mark.hardware` for hardware-specific tests).
5. Run tests: `test-run-pytest -k <test_file>`.

Note: This is currently not feasible for agent execution.

## Local commands

- `source ./env-init`
- `build-current`
- `build-shell; <bitbake|bitbake-getvar|bitbake-layers|devtool command>`