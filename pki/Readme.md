# PKI for a full chain of trust

The current implementation uses separate key material for the three main phases of the
device's runtime:

- A board-specific PKI for signing the [Firmware (boot-containers)](./boot-containers/Readme.md),
  establishing the root of trust.

- UEFI conformant keys for signing the [Unified Kernel Images (os-images)](./os-images/Readme.md)

- Simple certificate based authentication for [Software Updates (update-bundles)](./update-bundles/Readme.md)

While it might be technically feasible (using the HAB API in U-Boot) so reuse the firmware PKI
for signing the UKIs as well, this not only bulks up the _risk of leaked secrets_, but also makes
_key revocation scenarios_ harder.
Because while _some_ boards support revoking the Super Root Keys (SRKs) used as the root of trust
a few (i.e. up to 3 times), this is a not trivial operation.
A firmware update - containing commands to provision new UEFI keys - might be easier.