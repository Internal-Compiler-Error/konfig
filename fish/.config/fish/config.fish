if status is-login
  # Hyprland
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    # Hyprland
end

umask 027

zoxide init fish | source
set -x GBM_BACKEND nvidia-drm
set -x __GLX_VENDOR_LIBRARY_NAME nvidia

set -x EDITOR nvim
