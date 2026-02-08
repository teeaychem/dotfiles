{ pkgs, ... }:
{
  home.packages = with pkgs; [
  ];

  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    historyLimit = 100000;
    plugins = with pkgs; [
      tmuxPlugins.sensible
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_window_tabs_enabled on
          set -g @catppuccin_date_time "%H:%M"
        '';
      }
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-dir '$HOME/.cache/tmux'
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-boot 'on'
          set -g @continuum-save-interval '10'
        '';
      }
      tmuxPlugins.better-mouse-mode
    ];
    extraConfig = ''
      set -g mouse on

      set -g prefix C-w
      unbind C-b
      bind-key C-w send-prefix

      bind-key | split-window -h
      bind-key - split-window -v
      unbind '"'
      unbind %

      set -g display-time 4000  # Increase tmux messages display duration from 750ms to 4s
      set -g status-interval 5  # Refresh 'status-left' and 'status-right' every 5s
      set -g focus-events on
    '';
  };
}
