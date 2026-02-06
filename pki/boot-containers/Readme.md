# PKI generated for usage with the NXP iMX CST

The structure in this directory represents the minimal environment required to sign boot containers
for secure boot on HAB4 enabled devices.

# Setup

The following steps were done to populate the contents of the directories:

1. Generate keys and certs according to chapter 4.1.2 of the CST User Guide and deploy them 
   (including the `key_pass.txt`!) in the respective `keys` and `crts` folders:

   ```bash
   cd <cst-4.0.1>/keys
   echo '<some-number>' > serial
   echo '<passphrase>\n<passphrase>' > key_pass.txt
   ./hab4_pki_tree.sh -existing-ca n -use-ecc n -kl 2048 -duration 999 -num-srk 4 -srk-ca y
   ```

2. Create a SRK hash table as described in chapter 4.1.3 and deploy it in the `crts` directory, too:
   
   ```bash
   cd <cst-4.0.1>/crts

   ../linux64/bin/srktool -h 4 -t SRK_1_2_3_4_table.bin -e SRK_1_2_3_4_fuse.bin -d sha256 -c ./SRK1_sha256_2048_65537_v3_ca_crt.pem,./SRK2_sha256_2048_65537_v3_ca_crt.pem,./SRK3_sha256_2048_65537_v3_ca_crt.pem,./SRK4_sha256_2048_65537_v3_ca_crt.pem -f 1

   ```

3. Deploy the CST binary to use in the `bin` folder.