if status is-login
  # Hyprland
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    # Hyprland
end

umask 027

zoxide init fish | source

set -x EDITOR nvim
set -x RANGER_LOAD_DEFAULT_RC FALSE
