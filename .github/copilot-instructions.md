# Repository instructions

## Purpose

These instructions guide GitHub Copilot in understanding the repository structure, build processes, testing, and key workflows for this embedded Linux project. They provide essential context for effective assistance in development, debugging, and maintenance tasks.

## Overview

- **Purpose**: An embedded verified boot and update proof-of-concept for ARM using UEFI, focusing on `verdin-imx8mp` and QEMU `virt-aarch64` flavors.
- **Core functionality**: `TF-A`, `OP-TEE`, U-Boot EFI provider, UKI image generation, secure boot key management, RAUC update bundles, and secure system image construction.
- **Main layers**: `meta-generic-boot` with Yocto/OpenEmbedded recipes and a KAS-based build setup.
- **External dependencies/layers**: Checked out in `work/layers/`.
- **Languages**: Shell scripts, Python (pytest), YAML, BitBake recipes, C/C++ in external dependencies.
- **Target runtime**: ARM (iMX8MP board), QEMU `virt-aarch64` emulation.

## Key resources and files

- Root: `Readme.md`, `env-init`, `conf/`, `meta-generic-boot/`, `pki/`, `test/`, `tools/`, `work/`.
- KAS config: `conf/verdin-imx8mp.yml`, `conf/verdin-imx8mp.lock.yml`, `conf/includes/*.yml`.
- Build and test environment: `env-init` (provides aliases like `buildenv-setup`, `build-current`, `build-config`).
- Test config: `test/pytest.ini`, `test/test_update/update_flow_test.py`.

## Environment setup

1. Install dependencies (required for Yocto/KAS/docker path):
   - Docker
   - git
2. Clone repository.
3. In repo root, run:
   - `source ./env-init`
   - `buildenv-setup`
4. Optional, choose config:
   - `build-config recovery` or `build-config production` etc.
5. Always run `source ./env-init` each shell session before attempting commands.

## Build Commands

- To build the default configuration:
  - `source ./env-init`
  - `build-current` (calls KAS container `build` with config in `conf/`).
- For custom configs:
  - `build-config recovery`
  - `build-config provisioning`
  - `build-config production` (default)
- Debugging: Use `build-dump` and `build-shell`.

## Test Commands

- Test harness: `test-run-pytest`.
- Interactive shell: `test-shell`.
- Config: `test/pytest.ini` defines markers and options.
- Setup: `source ./env-init && testenv_setup` (builds Docker image if needed).
- Run: `test-run-pytest` or `run_in_testenv pytest -k ...`

## Run and Flash Commands

- `flash-device`: builds artifact path and calls `tools/flash/flash.sh`.
- `run_marked_tests` for hardware marker-based test selection.

## Lint/fix instructions

- Currently, no explicit linter are provided. 
- Use standard Python formatting/lint from environment: `python -m pytest`, `flake8`, `shellcheck` as needed.
- Preferred: Follow code style in existing files (`bash`+`sh` style from `env-init`).

## Project architecture and main files

- `conf/includes/base.yml`: layer list and base configuration (BitBake, meta layers).
- `meta-generic-boot/recipes-*`: actual packages for U-Boot, kernel, images.
- `tools/flash`: flash and provisioning scripts.
- `pki/`: certificate/key artifacts and layout.
- `work/`: local generated artifacts, patches, final images when building.

## Known gotchas and mandatory preconditions

- Always run `source ./env-init` first.
- Always use the commands provided by `env-init` for building, testing, flashing, etc.
- KAS uses `work/` as working directory; avoid manual deletion of `work/build/tmp` except when intending full clean.
- If Docker image missing, command `testenv_setup -f` rebuilds it.
- Rebuild may require network to fetch sources for Yocto/BitBake layers.

## Search behavior for agents
- Trust this file. Use `grep` only when this doc lacks required detail.
- For tasks, prefer editing within `meta-generic-boot/recipes-*` and `conf/*.yml`, unless otherwise asked.
- If CI config or workflow details are absent, assume local validation via build/test paths above.

## Quick file references (prioritized)
1. `env-init` (entrypoint for build/test commands).
2. `conf/verdin-imx8mp.yml` + `conf/includes/*.yml` (machine / mode config).
3. `meta-generic-boot/recipes-*` (core recipe definitions).
4. `tools/flash` (flash and provisioning scripts).
5. `test/pytest.ini` + `test/test_update/update_flow_test.py` (test suite behavior).
6. `Readme.md` (architecture intent and scope).

> Notes
> - This file is the canonical reference for Copilot in this repository.
> - If command results conflict with this document, update this doc and revalidate before proceeding.
