{
  pkgs,
  username,
  ...
}:

let
  inherit (import ./variables.nix) gitUsername;
in
{
  users.users = {
    "${username}" = {
      homeMode = "755";
      isNormalUser = true;
      description = "${gitUsername}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
        "scanner"
        "lp"
        "video" 
		"input" 
		"audio"
      ];
      defaultUserShell = pkgs.zsh;

      packages = with pkgs; [
      ];
    };
    
   environment.shells = with pkgs; [ zsh ];
  };
  
  environment.systemPackages = with pkgs; [
    fzf 
    ]; 
    
   programs = {
  	# Zsh configuration
	zsh = {
    	enable = true;
	  	enableCompletion = true;
      ohMyZsh = {
        enable = true;
        plugins = ["git"];
        theme = "xiong-chiamiov-plus";
      	};
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      promptInit = ''
	    #krabby random --no-mega --no-gmax --no-regional --no-title -s;
        source <(fzf --zsh);
	    HISTFILE=~/.zsh_history;
	    HISTSIZE=10000;
	    SAVEHIST=10000;
	    setopt appendhistory;
      '';
  };
}
