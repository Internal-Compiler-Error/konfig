eval (ssh-agent -c) &>/dev/null
ssh-add &>/dev/null

set -x GPG_TTY (tty)
set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent &>/dev/null

