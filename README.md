# lep-deploy

Automated deployment script for my Bachelor-Thesis.
The script assumes the client to be a Mac OS system, whereas the server is a Windows 10 VM.

## Prerequisites

On the Windows 10 VM:
- OpenSSH
- Git for Windows
- Administrator privileges

## Grant SSH Access

### Remote Desktop Access (deprecated)

On the Client
- Generate an rsa key using `ssh-keygen -t rsa -b 2048`
- Copy the rsa key to the VM using `ssh-copy-id Admin@147.87.116.202`
- Remote Desktop Access with automatic rsa authentication is now granted

### GitLab Access

**On the Client (deprecated)**
- Open Terminal
- Generate an rsa key using `ssh-keygen -o -f ~/.ssh/fricg2`
- `pbcopy < ~/.ssh/fricg2.pub` will copy your rsa public key
- Paste rsa key from clipboard into GitLab SSH Keys (User Account Settings)
- `ssh-add ~/.ssh/fricg2` to add your new Identity

**On the Server (Windows Server)**
- Open Git Bash
- Generate an rsa key using `ssh-keygen -t rsa -b 2048`
- `cat ~/.ssh/id_rsa.pub | clip` will copy your rsa public key
- Paste rsa key from clipboard into GitLab SSH Keys (User Account Settings)
- `ssh-add` to add your new Identity (the Open SSH Service must be running)

## Deploy

Run `lep-deploy/deploy.bat` in your cmd. Be advised that you are required to provide a parameter for the environment. Please understand that developer builds are usually not forseen to be used by client. If you want to ship a new version of the LEP Demonstrator, make sure to merge develop into master and to run `lep-deploy/deploy.bat prod` which will create a production build and create a new folder `windows-installer`, which can be zipped and delivered to the client.
If your SSH access has been configured correctly, the deployment will occur automatically without entering any of your credentials manually.

**Troubleshooting**
- Your SSH Tokens on GitLab are invalid
- You didn't add the rsa key to your Identities
- You provided a passphrase where no passphrase was needed
