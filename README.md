# Directory Structure
frigate - Frigate configuration files and Frigate state.
media - recordings saved by Frigate
scripts - bash scripts supporting automation, encryption, decryption, and key rotation

# Passwords and Secrets
All passwords and secrets are kept in ValutWarden
Frigate user - hashed in Frigate's DB
Camera user - passed to Frigate as Docker secrets

# Network Configuration
The camera's are on an isolated network that is only accessible to the Frigate server. Cameras are assigned a static IP starting with 10.9.3.100. Additionally, the camera feeds are protected with a username and password.

The Frigate host needs a static IP on the same subnet to discover the cameras. For the hackspace-nvr laptop, the camera-net was configured with nmcli.
`nmcli con add con-name "camera-net" ifname enxa0cec8004537 type ethernet ip4 10.9.3.1/24 ipv4.method manual`

# Encryption
Running `encrypt_and_clean.sh` will compress and encrypt new recordings every hour. These are signed with a `CounselOf<date>` PGP key.

# Data Retention
`encrypt_and_clean.sh` deletes both raw files from Frigate and encrypted files according to the retention policy. This makes Frigate's retention policy mostly irrelevant, but the policy is still configured for completeness.

# Rotating Keys
New keys are generated with `frigate-counsel.sh`. It will generate a CorrectHorseBatterStaple password, create a new `CounselOf<date>` PGP key pair where the private key is protected by the password, and then use Shamir's Secret Sharing to generate tokens so that K members of the counsel can recover the password at a later date. The tokens written to PGP encrypted messages under `keys/CounselOf<date>`.

At a minimum, the counsel members need to have a public key registered on the server's PGP key ring. This allows the key to be rotated as needed without convening the full counsel. If a counsel member needs to change their public key for any reason, the counsel key should be rotated. The old key should be retained until the footage it protects is expired.

For example: `frigate-counsel.sh 2 Cody Esther Wade` will generate a new key that requires 2 people to unlock. The provided names should match the names in the PGP key ring.

# Unlocking
Shamir's Secret Sharing allows K out of N secret holders to unlock the secret. `unlock.sh keys/CounselOf<date> Name` will trigger a prompt for Name to unlock their private key to decrypt their token. The token is written out to a file in the same directory. If enough unlocked tokens are found in the directory, the secret will be written out to `keys/CounselOf<date>/password`.

The old key is considered compromised once it is recovered, and a new key should be generated immediately. This could be fully automatic in the future, but for now a person has to press the button.

Once the password is recovered, `decrypt_dir.sh /media/frigate/recordings/<date>/<hour>.gpgtar` will restore the files to their original location. This allows you to use Frigate's tools to efficiently review footage from multiple camera's. The files will be encrypted again next time `encrypt_and_clean` runs. Footage in Frigate's "export" folder is preserved indefinitely.

# Bootstrapping
1) Install Docker
2) Clone this repository
3) Setup secret files. Docker will tell you if you missed any.
4) Run `docker compose up -d`
5) Log in to Frigate and verify all the cameras are connected
6) Change the Frigate password. For first boot, a randomly generated admin password will be output to the logs `docker logs -f frigate | less`
7) Setup Caffeine or otherwise configure the host so it won't sleep
8) Check back in a few hours. Is the server asleep? Are the cameras still connected?
9) Onboard the counsel members and generate a new encryption key. Any
