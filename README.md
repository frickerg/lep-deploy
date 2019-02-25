# lep-deploy

Automated deployment script for my Bachelor-Thesis.
The script assumes the client to be a Mac OS system, whereas the server is a Windows 10 VM.

## Prerequisites

On the Windows 10 VM:
- OpenSSH
- Git for Windows

## Grant SSH Access

### Remote Desktop Access

On the Client
- Generate an rsa key using `ssh-keygen -t rsa -b 2048`
- Copy the rsa key to the VM using `ssh-copy-id Admin@147.87.116.202`
- Remote Desktop Access with automatic rsa authentication is now granted

### GitLab Access

**On the Client**
- Open Terminal
- Generate an rsa key using `ssh-keygen -o -f ~/.ssh/fricg2`
- `pbcopy < ~/.ssh/fricg2.pub` will copy your rsa public key
- Paste rsa key from clipboard into GitLab SSH Keys (User Account Settings)
- `ssh-add ~/.ssh/fricg2` to add your new Identity

**On the Server**
- Open Git Bash
- Generate an rsa key using `ssh-keygen -t rsa -b 2048`
- `cat ~/.ssh/id_rsa.pub | clip` will copy your rsa public key
- Paste rsa key from clipboard into GitLab SSH Keys (User Account Settings)
- `ssh-add` to add your new Identity

## Deploy

Just run `lep-deploy/client.sh` on your client. If your SSH access has been configured correctly, the deployment will occur automatically without entering any of your credentials manually.

**Troubleshooting**
- Your SSH Tokens on GitLab are invalid
- You didn't add the rsa key to your Identities
- You provided a passphrase where no passphrase was needed
