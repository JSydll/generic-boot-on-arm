# Repository Instructions

## Purpose

These instructions guide GitHub Copilot in understanding the repository structure, build processes, testing, and key workflows for this embedded Linux project. They provide essential context for effective assistance in development, debugging, and maintenance tasks.

## Overview

- **Purpose**: An embedded verified boot and update proof-of-concept for ARM using UEFI, focusing on `verdin-imx8mp` and QEMU `virt-aarch64` flavors.
- **Core functionality**: `TF-A`, `OP-TEE`, U-Boot EFI provider, UKI image generation, secure boot key management, RAUC update bundles, and secure system image construction.
- **Main layers**: `meta-generic-boot` with Yocto/OpenEmbedded recipes and a KAS-based build setup.
- **External dependencies/layers**: Checked out in `work/layers/`.
- **Languages**: Shell scripts, Python (pytest), YAML, BitBake recipes, C/C++ in external dependencies.
- **Target runtime**: ARM (iMX8MP board), QEMU `virt-aarch64` emulation.

## Key Resources and Files

- `env-init`: build and test environment (provides aliases like `buildenv-setup`, `build-current`, `build-config`).
- `conf/verdin-imx8mp.yml`, `conf/verdin-imx8mp.lock.yml`, `conf/includes/*.yml`: KAS build configuration files.
- `conf/includes/base.yml`: layer list and base configuration (BitBake, meta layers).
- `meta-generic-boot/recipes-*`: actual packages for U-Boot, kernel, images.
- `tools/flash`: flash and provisioning scripts.
- `pki/`: certificate/key artifacts and layout.
- `work/`: local generated artifacts, patches, final images when building.

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

## Lint/fix Instructions

- Currently, no explicit linter are provided. 
- Use standard Python formatting/lint from environment: `python -m pytest`, `flake8`, `shellcheck` as needed.
- Preferred: Follow code style in existing files (`bash`+`sh` style from `env-init`).

## Known Gotchas and Mandatory Preconditions

- You MUST ALWAYS verify your changes by executing appropriate commands. In particular, check edits via bash commands or local build and tests.
- ALWAYS run `source ./env-init` first before other commands.
- ALWAYS use the commands provided by `env-init` for building, testing, flashing, etc.
- Document in a concise way and focus on reasoning, avoiding repeating what the code does.
- Avoid creating trivial or lengthy documentation that the user didn't ask for.
- Trust this file. Use `grep` only when this doc lacks required detail.
- KAS uses `work/` as working directory; avoid manual deletion of `work/build/tmp` except when intending full clean.
- Rebuild may require network to fetch sources for Yocto/BitBake layers.
- NEVER use absolute or host-specific paths in code or documentation.


> Notes
> - This file is the canonical reference for Copilot in this repository.
> - If command results conflict with this document, update this doc and revalidate before proceeding.
