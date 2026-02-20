# Generic (UEFI-based) verified boot and update on ARM

This repository contains a spike for generalizing some of the concepts known from the server and 
desktop world to embedded devices.

It stands on the shoulders of giants - namely arm, Linaro and Siemens - who've been pushing this
approach since a few years. However, it tries to simplify the overall setup and only include the 
basic verified boot and A/B update scheme here.

There are two implementations:

- the `verdin-imx8mp` (default) branch provides a build configuration for the Toradex iMX8MP SoC.
- the `virt-aarch64` branch was used for early experiments and has a partial configuration for emulation on QEMU.


## Wait, but why?

- A sophisticated (and widespread) specification (UEFI Secure Boot) - which also enforces properties
  like authenticated variables in the system.
- A stable API for the interaction of drivers and applications with the firmware - which can help to
  completely decouple BSP & OS layers
- Less complexity in bootscripting due to the features of `efibootmgr`
- Reasonable defaults, like signatures for the full kernel + dtb configuration 
  (see [u-boot docs](https://docs.u-boot.org/en/latest/usage/fit/signature.html#signed-configurations))
- Distro boot on embedded?
- Fun?

Relevant, partially embedded focused specificatons:
- Embedded Base Boot Requirements [EBBR](https://arm-software.github.io/ebbr/)
- Linaro & ARM partnership on SystemReady

## Overview of approaches

- **Linaro**'s [Trusted Substrate](https://trusted-substrate.readthedocs.io/en/latest/intro/software_components.html)
  > `TF-A`, `OP-TEE`, `u-boot` [EFI provider] -> `systemd-boot` [EFI payload, switching BL] -> UKI on ESP (vfat) (+ update unclear)

- **Siemens** 
  > `TF-A`, `OP-TEE`, `u-boot` [EFI provider] -> `efibootguard` [EFI payload, switching BL] + UKI on ESP (vfat) + `swupdate`

- **meta-generic-boot**:
  > `TF-A`, `OP-TEE` w/ `StandaloneMM` & RPMB, `u-boot` [EFI provider, switching BL] + UKIs w/ profiles 

**Improvement goals followed in meta-generic-boot**:
- removal of additional switching bootloader to reduce complexity
- full artifact signing
- support for arbitrary partitioning and no need for ESP
- robust filesystems support (no vfat)
- sophisticated boot counting possible (in comparision to `systemd-boot`'s file-rename-based approach)

**Readings**:
- UEFI-based secure boot on ARM - Siemens @ [ELC 2022](https://www.youtube.com/watch?v=H_dBnwkTAbw)
- isar CIP Core implementation [GitHub](https://gitlab.com/cip-project/cip-core/isar-cip-core/-/blob/master/doc/README.secureboot.md?ref_type=heads)
- Linaro blog: [UEFI secure boot in u-boot](https://www.linaro.org/blog/uefi-secureboot-in-u-boot/)
- Introduction to Linaro's [TrustedSubstrate](https://www.youtube.com/watch?v=8fELcFgPY_g) (2025)

### Core technologies

- Trusted Firmware for Cortex-A
- [`meta-arm`](https://git.yoctoproject.org/meta-arm) for `TF-A`, `EDK2`, ...
- UKIs with multiple profiles ([ukify docs](https://www.freedesktop.org/software/systemd/man/latest/ukify.html#Examples))
- `u-boot` as EFI provider ([docs](https://docs.u-boot.org/en/latest/develop/uefi/uefi.html))
- `RAUC` [integration docs](https://rauc.readthedocs.io/en/latest/integration.html#efi)

- For early development experiments: QEMU ARM virt machine ([doc](https://www.qemu.org/docs/master/system/arm/virt.html))

### Considerations

**General preconditions for UEFI on ARM**

- ARM TrustZone for extended firmware support
- eFuses and/or eMMC with Replay Protected Memory Blocks (RPMB) for storing the keyring

**Splitting OS and bootloader updates**

While there's the concept of [capsule updates](https://docs.u-boot.org/en/latest/develop/uefi/uefi.html#enabling-uefi-capsule-update-feature)
for updating the firmware (i.e. the bootloader parts), there might be easier and more canonical solutions
available on boards that come with an eMMC with two separate boot partitions and a MBR switch.

The Verdin iMX8MP SoC falls into this category, hence the simple firmware update via RAUC can be implemented.

**Alternatives to using u-boot as switching bootloader**

_Reasoning according to Siemens:_

- Low trust in its (UEFI-related) implementation
  _-> It's indeed rather new, but getting more mature already._

- Missing support for (secure) storage of the switching flag (i.e. `BootOrder` and `BootNext`)
  _-> This is addressed when using RPMB-backed authenticated UEFI variables._

- Early exit from watchdog
  _-> To be clarified._

Also see [this talk](https://youtu.be/vfYSP4qIJP0?si=RXGUvnzYJCqHUaQZ).


## Challenges and limitations

### Secret handling and authenticated runtime variables

While there is a solution ready to be used with the `StandaloneMM` varstore supplicant and by using RPMB backed storage,
this is not applicable to all boards and requires **significantly more effort** for a proper **integration** and **provisioning**.

For boards without RPMB, the solution implemented on the `virt-aarch64` branch, storing UEFI variables on the ESP and manually syncing them,
might be an alternative as long as the thread model allows for it.

**Readings**:
- Blog by Linaro: [Protected UEFI variables with u-boot](https://www.linaro.org/blog/protected-uefi-variables-with-u-boot/)
  (or directly from the Ilias [here](https://apalos.github.io/Protected%20UEFI%20variables%20with%20U-Boot.html)).
- [Patchset for QEMU](https://patchwork.ozlabs.org/project/qemu-devel/list/?series=470527) by Jan Kriska for RPMB support
- Overview by Ilias at Linux Plumbers 2023 ([Session](https://lpc.events/event/17/contributions/1653/), [PDF](https://lpc.events/event/17/contributions/1653/attachments/1338/2682/Plumbers%20-%20EFI%20setvariable%20problems%20and%20solutions.pdf))


### Gapless watchdog configuration

Current status: There are potential gap between ExitBootServices and kernel watchdog activation.
U-Boot has support for serving the hardware watchdog until ExitBootServices() (according to the UEFI specification).
There are ongoing discussions about the u-boot implementation in the [trusted-firmware.org mailinglist](https://lists.trustedfirmware.org/archives/list/tf-a@lists.trustedfirmware.org/thread/MLS2QZ7LLTEMOUIU5OUF4YMQ67UHAADV/).


## Current state of implementation

Working chain of trust, based on mainline branches and several Toradex provided meta layers.

Note: Given that some upstream features (like the `uki.bbclass`) were only recently published,
none of the current LTS releases can be used. See [Toradex Release Matrix](https://developer.toradex.com/software/toradex-embedded-software/embedded-linux-release-matrix/#current-releases)
for the versions of core system components like u-boot and kernel.

Why not using the Toradex distro and reference images? This spike is reduced to the bare minimum to get a clear
understanding of the involved parts while avoiding too much noise coming in from other features.
This being said, the Toradex layers as well as the Torizon platform come with a lot more features and a set of
reasonably made decisions for productive use cases. You should definitely consider using this instead of rolling
your own solutions just for the sake of it.

## Loose ends

- Implement bootloader updates
- Provide proper lg-env-config (and tests?)
- Fine-tune watchdog configuration to avoid a gap?
- Upstream / remove patches in community layers and tools.
- Upstream extensions for `uki.bbclass`

## General findings

- Many of the involved open source projects lack beginner documentation
- Implementations by Toradex, Linaro and Siemens have a lot more features than the presented approach 
  (which makes them harder to understand at times)
- Lots of building blocks already in upstream layers - though quality & maintenance needs to be monitored

## Recent advances in alternative approaches

- Barebox will (soon) support direct FIT image verification - further reducing the attack surface for altered content in the OS images
  (see [this talk by A. Fatoum](https://www.youtube.com/watch?v=dermEhoAu1I))
