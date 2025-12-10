# Generic (UEFI-based) verified boot and update on ARM

This repository contains a spike for generalizing some of the concepts known from the server and 
desktop world to embedded devices.

It stands on the shoulders of giants - namely arm, Linaro and Siemens - already pushing this approach
since a few years. Yet, it tries to further simplify the overall setup and only include the basic
verified boot and A/B update scheme here.

Currently, only an integration for `qemuarm64` is available. A port on a representative hardware board may follow.

## Wait, but why?

- cross-validation from widespread use in the server & desktop world
- rather sophisticated specification
- reduce development & maintenance effort
- cover some gaps, like missing (default) signature for FIT config itself (see [u-boot docs](https://docs.u-boot.org/en/latest/usage/fit/signature.html#signed-configurations))

Also pushed by:
- Embedded Base Boot Requirements [EBBR](https://arm-software.github.io/ebbr/)
- Linaro & ARM partnership on SystemReady

## Approaches

- **Linaro**'s [Trusted Substrate](https://trusted-substrate.readthedocs.io/en/latest/intro/software_components.html) 
  -> TF-A, OP-TEE, u-boot [EFI provider] + systemd-boot [EFI payload, switching BL] + UKI on ESP (vfat) (+ update unclear)
- **Siemens** 
  -> TF-A, OP-TEE, u-boot [EFI provider] + efibootguard [EFI payload, switching BL] + UKI on ESP (vfat) + swupdate

> **meta-generic-boot**: TF-A, OP-TEE, u-boot [EFI provider, switching BL] + UKIs w/ profiles (no ESP, squashfs or raw partitions possible) 

**Improvement goals**:
- less components to reduce complexity
- full artifact signing
- support for partitioning and no dependency on ESP
- robust filesystems support
- sophisticated boot counting possible (in comparision to `systemd-boot`'s file-rename-based approach)

**Readings**:
- UEFI-based secure boot on ARM - Siemens @ [ELC 2022](https://www.youtube.com/watch?v=H_dBnwkTAbw)
- isar CIP Core implementation [GitHub](https://gitlab.com/cip-project/cip-core/isar-cip-core/-/blob/master/doc/README.secureboot.md?ref_type=heads)
- Linaro blog: [UEFI secure boot in u-boot](https://www.linaro.org/blog/uefi-secureboot-in-u-boot/)
- Introduction to Linaro's [TrustedSubstrate](https://www.youtube.com/watch?v=8fELcFgPY_g) (2025)

### Considerations

**General preconditions for UEFI on ARM**

- ARM TrustZone for extended firmware support
- eFuses and/or eMMC with Replay Protected Memory Blocks (RPMB) for storing the keyring

**Splitting OS and bootloader updates**

Established approaches on embedded Linux devices often use a common path for both updating the Linux side 
of the system as well as the bootloader (see RAUC's capabilities on doing that, for example).
In contrast to this, the TF-A architecture and UEFI specification separate the two by defining
[capsule updates](https://docs.u-boot.org/en/latest/develop/uefi/uefi.html#enabling-uefi-capsule-update-feature)
for updating the firmware (at least the extended firmware scope or _FIP_ [Firmware Interface Package]).
This would then also include the bootloader.
An advantage of this is, again, that implementations must follow a clear specification, while some aspects like
the requirement for a FAT-based EFI System Partition are potential downsides - especially in the embedded context.

**Alternatives to using u-boot as switching bootloader**

_Reasoning according to Siemens:_

- Low trust in its (UEFI-related) implementation
- Missing support for (secure) storage of the switching flag (i.e. `BootOrder` and `BootNext`)
- Early exit from watchdog

Also see [this talk](https://youtu.be/vfYSP4qIJP0?si=RXGUvnzYJCqHUaQZ).

### Core technologies

- Trusted Firmware for Cortex-A ([docs for QEMU](https://github.com/ARM-software/arm-trusted-firmware/blob/master/docs/plat/qemu.rst), [blog](https://lnxblog.github.io/2020/08/20/qemu-arm-tf.html))
- [`meta-arm`](https://git.yoctoproject.org/meta-arm) for `TF-A`, `EDK2`, ...
- UKIs with multiple profiles ([ukify docs](https://www.freedesktop.org/software/systemd/man/latest/ukify.html#Examples))
- `u-boot` as EFI provider ([docs](https://docs.u-boot.org/en/latest/develop/uefi/uefi.html))
- `RAUC` [integration docs](https://rauc.readthedocs.io/en/latest/integration.html#efi)
- QEMU ARM virt machine ([doc](https://www.qemu.org/docs/master/system/arm/virt.html))

## Challenges and limitations

### Secret handling

Common approaches: efuses, OP-TEE w/ RPMB eMMC (yet, this is still accessible from userspace), burned into binary

Issues:
- No guaranteed protection against access from kernel / userspace
- In QEMU: missing emulation support

> **meta-generic-boot**: Limited due to secrets built-in to u-boot binary, requiring firmware update for key rotation.

**Readings**:
- Blog by Linaro: [Protected UEFI variables with u-boot](https://www.linaro.org/blog/protected-uefi-variables-with-u-boot/)
- [Patchset for QEMU](https://patchwork.ozlabs.org/project/qemu-devel/list/?series=470527) by Jan Kriska for RPMB support

### Runtime, authenticated variables

Current status: no SetVariableRT in u-boot (barebox maybe?)

**Readings**:
- Overview by Ilias at Linux Plumbers 2023 ([Session](https://lpc.events/event/17/contributions/1653/), [PDF](https://lpc.events/event/17/contributions/1653/attachments/1338/2682/Plumbers%20-%20EFI%20setvariable%20problems%20and%20solutions.pdf))

> **meta-generic-boot**: Limited by a workaround loading variables from an ESP in separate disk and manually persisting it by copying over changes only written in RAM (also comes with a different u-boot config). Also no further means to protect against rollback are implemented yet.

### Gapless watchdog configuration

Current status: Potential gap between ExitBootServices & Kernel watchdog activation

U-Boot has support for serving the hardware watchdog until ExitBootServices() (according to the UEFI spec).

**Readings**:
- Discussions about the u-boot implementation in the [trusted-firmware.org mailinglist](https://lists.trustedfirmware.org/archives/list/tf-a@lists.trustedfirmware.org/thread/MLS2QZ7LLTEMOUIU5OUF4YMQ67UHAADV/)

## Current state of implementation

**qemuarm64**:
...

**verdin-imx8mp**:
...

Note: Given that some upstream features (like the `uki.bbclass`) were only recently published,
none of the current LTS releases can be used.

Why not using the Toradex distro and reference images? This spike is reduced to the bare minimum to get a clear
understanding of the involved parts while avoiding too much noise coming in from other features.
This being said, the Toradex layers as well as the Torizon platform come with a lot more features and a set of
reasonably made decisions for productive use cases. You should definitely consider using this instead of rolling
your own solutions just for the sake of it.

To be clarified:

For QEMU support of the `imx8mp-evk` board model, version 10 is required and needs to be built from sources.

## Loose ends

- Fine-tune watchdog configuration to avoid a gap?
- Build testenv Docker image including changes in `QemuDriver`
- Automatically provide secrets for update bundle signing
- Upstream patches in `meta-arm` and `labgrid`
- Upstream extensions for `uki.bbclass`
- Take over patchset on QEMU for RPMB eMMC emulation and remove workaround
- Implement **capsule updates** for bootloader updates

## General observations

- Many of the involved open source projects lack beginner documentation
- Implementations by Linaro and Siemens have a lot more features than the presented approach (which makes it hard to understand at times)
- Lots of building blocks already in upstream layers - though quality & maintenance needs to be monitored

## Recent advances in alternative approaches

- Barebox will (soon) support direct FIT image verification - further reducing the attack surface for altered content in the OS images
  (see [this talk by A. Fatoum](https://www.youtube.com/watch?v=dermEhoAu1I))

## Further readings

- swtpm & QEMU configuration: [Linaro blog](https://www.linaro.org/blog/how-to-emulate-trusted-platform-module-in-qemu-with-u-boot/), [ejaaskel.dev](https://ejaaskel.dev/yocto-emulation-setting-up-qemu-with-tpm/)
