eval (ssh-agent -c) > /dev/null
ssh-add

set GPG_TTY (tty)
set SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

