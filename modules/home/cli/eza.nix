# Eza is a ls replacement
{
  programs.eza = {
    enable = true;
    icons = "auto";
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    git = true;

    extraOptions = [
      "--group-directories-first"
      "--no-quotes"
      "--header" # Show header row
      "--git-ignore"
      # "--time-style=long-iso" # ISO 8601 extended format for time
      "--classify" # append indicator (/, *, =, @, |)
      "--hyperlink" # make paths clickable in some terminals
    ];
  };
  # Aliases to make `ls`, `ll`, `la` use eza
  home.shellAliases = {
    ":q" = "exit";
    sv = "sudo nvim";
    v = "nvim";
    c = "clear";
    ls = "eza";
    lt = "eza --tree --level=2";
    ll = "eza  -a --no-user --long";
    la = "eza -lah ";
    lsbc = "lsblk -f | bat -l conf -p ";
    tree = "eza --tree ";
    d = "exa -a --grid ";
    dir = "exa -a --grid";
    jctl = "journalctl -p 3 -xb";
    notes = "nvim ~/notes.txt";
    ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
    man = "batman";
    dysk = "dysk -c label+default";
    zi = "cdi"; # for zoxide compatibilty
    serie = "serie -p kitty --preload -g double";
    # Terminal client: use the et wrapper (sets TERM to *-direct when available)
    # Remove alias here so the script installed to PATH is used.
  };
}
