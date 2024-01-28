if status is-interactive
    # Commands to run in interactive sessions can go here
end

umask 027

zoxide init fish | source
set editor nvim
