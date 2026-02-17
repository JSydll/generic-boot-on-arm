# Automation for flashing the Verdin iMX-8MP

For deploying the software and provisioning the device, the `snagboot` tool is used.
Installation instructions can be found [here](https://snagboot.readthedocs.io/en/latest/installing/).

There are two different modes to interact with the device:

- Running only the firmware (the boot container including u-boot, ATF and OP-TEE) in RAM and 
  sending fastboot commands to the bootloader.
  ```bash
  run-recovery.sh
  run-fastboot-cmd.sh ucmd:version
  ...
  ```

- Flashing a complete system image (containing both the boot container and the eMMC partition contents)
  to the device:
  ```bash
  flash.sh /abs/path/to/deploy/images/verdin-imx8mp flash.bin secure-image-minimal-verdin-imx8mp.rootfs.wic
  ```
  _Note: There's a helper in the env-init for this: flash-device._


## Preparation

Provide the required boot containers for your board in this directory:

- `recovery`: Depending on your board status, provide an unsigned or signed `recovery-flash.bin`.
- `provisioning`: The final provisioning requires a signed `provisioning-flash.bin`.

## Provisioning sequence

There are three stages in which the initial, security-related provisioning is done:

1) **Set up the root of trust**
   - Boot (signed) `recovery` boot container
   - Fuse SRK hash table
   - Reset & check `hab_status` for correct behavior
   - Close the device
   - Reset

2) **Provision authenticated UEFI variables**
   - Boot signed `provisioning` boot container - which will automatically write the RPMB authentication key
   - Write UEFI secure boot variables (PK, KEK, db, dbx)

3) **Flash secure boot enabled system image**
   - Can optionally be done while in the provisioning environment
   - Flash the `production` boot container and system image to the eMMC