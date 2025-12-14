# Tmux is a terminal multiplexer that allows you to run multiple terminal sessions in a single window.
{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    mouse = true;
    shell = "${pkgs.zsh}/bin/zsh";
    prefix = "C-a";
    terminal = "tmux-256color";
    keyMode = "vi";
    baseIndex = 1;
    clock24 = false;
    historyLimit = 5000;

    extraConfig = ''
              set-option -g status-position top
              set -ga terminal-overrides ",*:RGB"
              set -g renumber-windows on
              set -g set-clipboard on

              unbind %
              unbind '"'

              # VIM Motion realated settings
              bind-key h select-pane -L
              bind-key j select-pane -D
              bind-key k select-pane -U
              bind-key l select-pane -R

              bind -n M-h select-pane -L
              bind -n M-j select-pane -D
              bind -n M-k select-pane -U
              bind -n M-l select-pane -R

              bind-key -T copy-mode-vi v send-keys -X begin-selection
              bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
              bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
              unbind -T copy-mode-vi MouseDragEnd1Pane


              set -gq allow-passthrough on
              bind-key x kill-pane # skip "kill-pane 1? (y/n)" prompt

              bind-key -n C-Tab next-window
              bind-key -n C-S-Tab previous-window
              bind-key -n M-Tab new-window

              bind -n M-1 select-window -t 1
              bind -n M-2 select-window -t 2
              bind -n M-3 select-window -t 3
              bind -n M-4 select-window -t 4
              bind -n M-5 select-window -t 5
              bind -n M-6 select-window -t 6
              bind -n M-7 select-window -t 7
              bind -n M-8 select-window -t 8
              bind -n M-9 select-window -t 9

              # Start windows and panes index at 1, not 0.
              setw -g pane-base-index 1

              # Creating panes
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
              # 'p' previous window
              bind-key  p previous-window

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

      bind C-r display-popup \
        -d "#{pane_current_path}" \
        -w 90% \
        -h 90% \
        -E "yazi"

      bind C-t display-popup \
        -d "#{pane_current_path}" \
        -w 75% \
        -h 75% \
        -E "zsh"

      # Tokyonight Moon theme (from tmux.tony.conf)
      set -g status "on"
      set -g status-bg "#222436"
      set -g status-justify "left"
      set -g status-left-length "100"
      set -g status-right-length "100"

      # Messages
      set -g message-style "fg=#86e1fc,bg=#3a3f5a,align=centre"
      set -g message-command-style "fg=#86e1fc,bg=#3a3f5a,align=centre"

      # Panes
      set -g pane-border-style "fg=#3a3f5a"
      set -g pane-active-border-style "fg=#82aaff"

      # Windows
      set -g window-status-activity-style "fg=#c8d3f5,bg=#222436,none"
      set -g window-status-separator ""
      set -g window-status-style "fg=#c8d3f5,bg=#222436,none"

      # Statusline - current window
      set -g window-status-current-format "#[fg=#82aaff,bg=#222436] #I: #[fg=#c099ff,bg=#222436](✓) #[fg=#86e1fc,bg=#222436]#(echo '#{pane_current_path}' | rev | cut -d'/' -f-2 | rev) #[fg=#c099ff,bg=#222436]"

      # Statusline - other windows
      set -g window-status-format "#[fg=#82aaff,bg=#222436] #I: #[fg=#c8d3f5,bg=#222436]#W"

      # Statusline - right side
      set -g status-right "#[fg=#82aaff,bg=#222436,nobold,nounderscore,noitalics]#[fg=#222436,bg=#82aaff,nobold,nounderscore,noitalics] #[fg=#c8d3f5,bg=#3a3f5a] #W #{?client_prefix,#[fg=#c099ff],#[fg=#86e1fc]}#[bg=#3a3f5a]#{?client_prefix,#[bg=#c099ff],#[bg=#86e1fc]}#[fg=#222436] #[fg=#c8d3f5,bg=#3a3f5a] #S "

      # Statusline - left side (empty)
      set -g status-left ""

      # Modes
      set -g clock-mode-colour "#82aaff"
      set -g mode-style "fg=#82aaff bg=#444a73 bold"


    '';
  };
}
