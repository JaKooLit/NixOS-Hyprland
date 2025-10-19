# Tmux is a terminal multiplexer that allows you to run multiple terminal sessions in a single window.
{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    mouse = true;
    shell = "${pkgs.zsh}/bin/zsh";
    prefix = "C-a";
    terminal = "tmux-256color";
    keyMode = "vi";
    baseIndex = 1;
    clock24 = false;

    extraConfig = ''
              set-option -g status-position top
              set -sg terminal-overrides ",*:RGB"
              set -g default-terminal "tmux-256color"
              set-option -g history-limit 5000
              set -g renumber-windows on

              unbind %
              unbind '"'

              bind-key h select-pane -L
              bind-key j select-pane -D
              bind-key k select-pane -U
              bind-key l select-pane -R

              set -gq allow-passthrough on
              bind-key x kill-pane # skip "kill-pane 1? (y/n)" prompt

              bind-key -n C-Tab next-window
              bind-key -n C-S-Tab previous-window
              bind-key -n M-Tab new-window


            # Start windows and panes index at 1, not 0.
            setw -g pane-base-index 1


            bind-key "|" split-window -h -c "#{pane_current_path}"
            bind-key "\\" split-window -fh -c "#{pane_current_path}"

            bind-key "-" split-window -v -c "#{pane_current_path}"
            bind-key "_" split-window -fv -c "#{pane_current_path}"

            bind -r C-j resize-pane -D 15
            bind -r C-k resize-pane -U 15
            bind -r C-h resize-pane -L 15
            bind -r C-l resize-pane -R 15

            # 'c' to new window
            bind-key  c new-window

            # 'n' next  window
            bind-key  n next-window

            # 'p' next  previous
            bind-key  n previous-window

            unbind r
            bind r source-file ~/.config/tmux/tmux.conf

            bind -r m resize-pane -Z

            bind-key  t clock-mode
            bind-key  q display-panes
            bind-key  u refresh-client
            bind-key  o select-pane -t :.+


      ##### Display Popups #####

      bind C-y display-popup \
        -d "#{pane_current_path}" \
        -w 80% \
        -h 80% \
        -E "lazygit"
      bind C-n display-popup -E 'bash -i -c "read -p \"Session name: \" name; tmux new-session -d -s \$name && tmux switch-client -t \$name"'
      bind C-j display-popup -E "tmux list-sessions | sed -E 's/:.*$//' | grep -v \"^$(tmux display-message -p '#S')\$\" | fzf --reverse | xargs tmux switch-client -t"
      #bind C-p display-popup -E "ipython"
      #bind C-f display-popup \
       # -w 80% \
       # -h 80% \
       # -E 'rmpc'
      bind C-r display-popup \
        -d "#{pane_current_path}" \
        -w 90% \
        -h 90% \
        -E "yazi"
      bind C-z display-popup \
        -w 90% \
        -h 90% \
        -E 'nvim ~/NixOS-Hyprland/flake.nix'
      bind C-t display-popup \
        -d "#{pane_current_path}" \
        -w 75% \
        -h 75% \
        -E "zsh"

      ##### Display Menu #####

      bind d display-menu -T "#[align=centre]Dotfiles" -x C -y C \
        "NixOS flake.nix"        f  "display-popup -E 'nvim ~/NixOS-Hyprland/flake.nix'" \
        "NixOS core packages"    c  "display-popup -E 'nvim ~/NixOS-Hyprland/modules/packages.nix'" \
        "       Exit"              q  ""


    '';

    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.sensible
      tmuxPlugins.catppuccin
      #tmuxPlugins.Dracula
      #tmuxPlugins.tokyo-night-tmux
    ];
  };
}
