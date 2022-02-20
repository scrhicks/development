# Configuration of local development environment

## Install required packages
```bash
sudo apt install -y git git-flow jq wget curl unzip ca-certificates curl lsb-release \
	gnupg2 gnupg-agent dirmngr cryptsetup scdaemon pcscd secure-delete hopenpgp-tools yubikey-personalization \
	libssl-dev swig libpcsclite-dev python3-pip python3-pyscard
```

## No password sudo
```bash
cat << EOF | sudo tee -a /etc/sudoers.d/$USER
$USER ALL=(ALL) NOPASSWD: ALL
EOF
sudo chmod 0440 /etc/sudoers.d/$USER
```

## Install Terraform Environment
```bash
{
export TFE_VERSION=v2.2.3
export TFE_DIR=/opt/tfenv/${TFE_VERSION}
sudo mkdir -p $TFE_DIR
sudo git clone --depth 1 --branch $TFE_VERSION https://github.com/tfutils/tfenv.git $TFE_DIR

sudo chown -R $USER:$USER $TFE_DIR
sudo chmod +x $TFE_DIR/bin/tfenv
sudo ln -s $TFE_DIR/bin/* /usr/local/bin

tfenv install 1.1.6
tfenv use 1.1.6
}
```

## Install Terraform docs
```bash
{
export TFD_VERSION=v0.16.0
export TFD_DIR=/opt/terraform-docs/$TFD_VERSION
export TFD_ZIP=/tmp/terraform-docs-$TFD_VERSION.tar.gz
sudo mkdir -p $TFD_DIR
curl --fail --silent -L -o $TFD_ZIP "https://github.com/terraform-docs/terraform-docs/releases/download/${TFD_VERSION}/terraform-docs-${TFD_VERSION}-$(uname)-amd64.tar.gz"
sudo tar -xzf $TFD_ZIP -C $TFD_DIR
sudo chown -R $USER:$USER $TFD_DIR
sudo chmod +x $TFD_DIR/terraform-docs
sudo ln -s $TFD_DIR/terraform-docs /usr/local/bin/terraform-docs
}
```

## Install Terraform Lint
```bash
{
export TFL_VERSION=v0.34.1
export TFL_DIR=/opt/tflint/$TFL_VERSION
export TFL_ZIP=/tmp/tflint-$TFL_VERSION.zip
sudo mkdir -p $TFL_DIR
curl --fail --silent -L -o $TFL_ZIP "https://github.com/terraform-linters/tflint/releases/download/${TFL_VERSION}/tflint_linux_amd64.zip"
sudo unzip $TFL_ZIP -d $TFL_DIR
sudo chown -R $USER:$USER $TFL_DIR
sudo chmod +x $TFL_DIR/tflint
sudo ln -s $TFL_DIR/tflint /usr/local/bin/tflint
}
```

## Install Terragrunt
```bash
{
export TRG_VERSION=v0.36.1
export TRG_DIR=/opt/terragrunt/$TRG_VERSION
export TRG_OUTPUT=$TRG_DIR/terragrunt
sudo mkdir -p $TRG_DIR
sudo curl --fail --silent -L -o $TRG_OUTPUT "https://github.com/gruntwork-io/terragrunt/releases/download/${TRG_VERSION}/terragrunt_linux_amd64"
sudo chown -R $USER:$USER $TRG_DIR
sudo chmod +x $TRG_DIR/terragrunt
sudo ln -s $TRG_DIR/terragrunt /usr/local/bin/terragrunt
}
```

## Install Docker and Docker-Compose
```bash
{
export DC_VERSION=v2.2.3
sudo apt-get update
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

sudo curl --fail --silent -L -o /usr/local/bin/docker-compose "https://github.com/docker/compose/releases/download/${DC_VERSION}/docker-compose-$(uname -s)-$(uname -m)"
sudo chmod +x /usr/local/bin/docker-compose
}
```

## Install CascadiaCode Font
```bash
{
export VERSION=v2.1.0
curl --fail --silent -L -o /tmp/CascadiaCode.zip "https://github.com/ryanoasis/nerd-fonts/releases/download/${VERSION}/CascadiaCode.zip"
mkdir ~/.fonts
unzip /tmp/CascadiaCode.zip -d ~/.fonts
rm -rf /tmp/CascadiaCode.zip
fc-cache -fv
}
```

To use font in terminal go to the `Menu` => `Edit` => `Profile Preferences` => `Profiles` => `Unnamed`, check `Custom font` and select `CaskaydiaCove NF` font.

## Install PowerShell
```bash
{
sudo apt-get update
sudo apt-get install -y wget apt-transport-https software-properties-common
wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo rm -rf packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y powershell
}
```

## Install oh-my-posh
```bash
Install-Module oh-my-posh -Scope CurrentUser
Install-Module -Name Terminal-Icons -Repository PSGallery
Install-Module PSReadLine -AllowPrerelease -Force

mkdir -p /home/$USER/.config/powershell

# Download PowerShell configuration 
curl --fail --silent -L -o /home/$USER/.config/powershell/Microsoft.PowerShell_profile.ps1 "https://raw.githubusercontent.com/scrhicks/development/main/configs/Microsoft.PowerShell_profile.ps1"

# Download theme
curl --fail --silent -L -o /home/$USER/.config/powershell/ohmyposhv3-2.json "https://raw.githubusercontent.com/scrhicks/development/main/configs/ohmyposhv3-2.json"
```

## Change default terminal shell to PowerShell
```bash
chsh -s /usr/bin/pwsh $USER
```

## Install VSCode
```bash
sudo snap install --classic code

# Download config file
curl --fail --silent -L -o /home/$USER/.config/Code/User/settings.json "https://raw.githubusercontent.com/scrhicks/development/main/configs/settings.json"
```

## Install pre-commit
```bash
sudo pip install pre-commit
```

## Configure gpg and gpg-agent
```bash
{
pip3 install PyOpenSSL
pip3 install yubikey-manager
sudo service pcscd start
sudo ln -s ~/.local/bin/ykman /usr/local/bin/ykman
ykman openpgp info

# Download gpg and gpg-agent configuration
cd ~/.gnupg ; wget https://raw.githubusercontent.com/drduh/config/master/gpg.conf
cd ~/.gnupg ; wget https://raw.githubusercontent.com/drduh/config/master/gpg-agent.conf

# Import public gpg key and trust
gpg --keyserver keyserver.ubuntu.com --recv 0x3FEF54B2FA60C719
gpg --edit-key 0x3FEF54B2FA60C719
  gpg> 5
  gpg> y
  gpg> quit
}
```

## Configure SSH
```bash
# Copy publish ssh key from yubikey
ssh-add -L | grep "cardno:000613801128" > ~/.ssh/id_ed25519_yubikey.pub

# Set proper permissions to the key
chmod 0400 ~/.ssh/id_ed25519_yubikey.pub

# Configure SSH connection to use this key
cat << EOF >> ~/.ssh/config
Host github.com
    IdentitiesOnly yes
    IdentityFile ~/.ssh/id_ed25519_yubikey.pub
EOF

# Enable SSH agent to read key from YubiKey
echo 'export GPG_TTY="$(tty)"' >> ~/.bashrc
echo 'export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"' >> ~/.bashrc
echo 'gpg-connect-agent updatestartuptty /bye > /dev/null' >> ~/.bashrc

. ~/.profile
```

## Configure git
```bash
{
git config --global user.name "Przemyslaw Pogorzelec"
git config --global user.email 29803615+scrhicks@users.noreply.github.com
git config --global user.signingkey 0x3FEF54B2FA60C719
git config --global commit.gpgsign true
}
```