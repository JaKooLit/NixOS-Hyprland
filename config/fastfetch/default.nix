{
  programs.fastfetch = {
    enable = true;

    settings = {
      display = {
        color = {
          keys = "35";
          output = "90";
        };
      };

      logo = {
        source = ./nixos.png;
        type = "kitty-direct";
        height = 15;
        width = 30;
        padding = {
          top = 3;
          left = 3;
        };
      };

      modules = [
          "break"
          {
              type = "custom";
              format = "┌──────────────────────Hardware──────────────────────┐";
          }
          {
              type = "cpu";
              key = "│  ";
          }
          {
              type = "gpu";
              key = "│ 󰍛 ";
          }
          {
              type = "memory";
              key = "│ 󰑭 ";
          }
          {
              type = "custom";
              format = "└────────────────────────────────────────────────────┘";
          }
          "break"
          {
              type = "custom";
              format = "┌──────────────────────Software──────────────────────┐";
          }
          {
              type = "custom";
              format = " OS -> ZaneyOS 2.2";
          }
          {
              type = "kernel";
              key = "│ ├ ";
          }
          {
              type = "packages";
              key = "│ ├󰏖 ";
          }
          {
              type = "shell";
              key = "└ └ ";
          }
          "break"
          {
              type = "wm";
              key = " WM";
          }
          {
              type = "wmtheme";
              key = "│ ├󰉼 ";
          }
          {
              type = "terminal";
              key = "└ └ ";
          }
          {
              type = "custom";
              format = "└────────────────────────────────────────────────────┘";
          }
          "break"
          {
              type = "custom";
              format = "┌────────────────────Uptime / Age────────────────────┐";
          }
          {
              type = "command";
              key = "│  ";
              text = #bash
              ''
                birth_install=$(stat -c %W /)
                current=$(date +%s)
                delta=$((current - birth_install))
                delta_days=$((delta / 86400))
                echo $delta_days days
              '';
          }
          {
              type = "uptime";
              key = "│  ";
          }
          {
              type = "custom";
              format = "└────────────────────────────────────────────────────┘";
          }
          "break"
      ];
    };
  };
}
