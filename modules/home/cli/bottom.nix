{ ... }: {
  programs.bottom = {
    enable = true;
    settings = {
      enable_gpu = true;
      colors = {
        cpu = {
          all_entry_color = "#f5e0dc";
          avg_entry_color = "#eba0ac";
          cpu_core_colors = [ "#f38ba8" "#fab387" "#f9e2af" "#a6e3a1" "#74c7ec" "#cba6f7" ];
        };
        memory = {
          ram_color = "#a6e3a1";
          cache_color = "#f38ba8";
          swap_color = "#fab387";
          gpu_colors = [ "#74c7ec" "#cba6f7" "#f38ba8" "#fab387" "#f9e2af" "#a6e3a1" ];
          arc_color = "#89dceb";
        };
        network = {
          rx_color = "#a6e3a1";
          tx_color = "#f38ba8";
          rx_total_color = "#89dceb";
          tx_total_color = "#a6e3a1";
        };
        battery = {
          high_battery_color = "#a6e3a1";
          medium_battery_color = "#f9e2af";
          low_battery_color = "#f38ba8";
        };
        tables = {
          headers = { color = "#f5e0dc"; };
        };
        graphs = {
          graph_color = "#a6adc8";
          legend_text = { color = "#a6adc8"; };
        };
        widgets = {
          border_color = "#585b70";
          selected_border_color = "#f5c2e7";
          widget_title = { color = "#f2cdcd"; };
          text = { color = "#cdd6f4"; };
          selected_text = { color = "#11111b"; bg_color = "#cba6f7"; };
          disabled_text = { color = "#1e1e2e"; };
        };
      };
      flags.group_processes = true;
      row = [
        {
          ratio = 2;
          child = [
            { type = "cpu"; }
            { type = "temp"; }
          ];
        }
        {
          ratio = 2;
          child = [
            { type = "network"; }
          ];
        }
        {
          ratio = 3;
          child = [
            {
              type = "proc";
              ratio = 1;
              default = true;
            }
          ];
        }
      ];
    };
  };
}
