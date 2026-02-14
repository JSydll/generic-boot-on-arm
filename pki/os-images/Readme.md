# UEFI Secure Boot keys

The authentication signatures can be generated with the `sbsign` Yocto class.
However, it was found that the signing cascade required by the UEFI specification
does not work in this case.

While the PK (as the name 'Platform Key' suggests) is the root key, the others need
to be cross-signed:

- KEK needs to be signed by PK
- db and dbx need to be signed by KEK

More information can be found on [Linaro's Trusted Substrate documentation](https://trs.readthedocs.io/en/latest/firmware/running/uefi_variables.html).

If the base certs and keys already exist, the signatures can be created via

```bash
sign-efi-sig-list -c PK.crt -k PK.key PK PK.esl PK.auth
sign-efi-sig-list -c PK.crt -k PK.key KEK KEK.esl KEK.auth
sign-efi-sig-list -c KEK.crt -k KEK.key db db.esl db.auth
sign-efi-sig-list -c KEK.crt -k KEK.key dbx dbx.esl dbx.auth

```