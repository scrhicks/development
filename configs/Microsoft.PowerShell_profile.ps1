Import-Module oh-my-posh
Import-Module -Name Terminal-Icons
Import-Module PSReadLine

oh-my-posh --init --shell pwsh --config /home/ubuntu/.config/powershell/ohmyposhv3-2.json | Invoke-Expression

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows

$Env:GPG_TTY = "$(tty)"
$Env:SSH_AUTH_SOCK = "/run/user/$(id -u)/gnupg/S.gpg-agent.ssh"
gpg-connect-agent updatestartuptty /bye > /dev/null