{ config, pkgs, lib, ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;

    historySize = 100000;
    historyFileSize = 500000;
    historyControl = [ "ignoredups" "ignorespace" "erasedups" ];

    shellOptions = [
      "histappend" 
      "checkwinsize"
      "extglob"
      "globstar" 
      "checkjobs"
      "cdspell" 
      "autocd" 
    ];

    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -lah --color=auto";
      la = "ls -A --color=auto";
      grep = "grep --color=auto";
      ".." = "cd ..";
      "..." = "cd ../..";
      gs = "git status";
      gd = "git diff";
      gc = "git commit";
      gp = "git push";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#nixos";
    };

    bashrcExtra = ''
      [[ $- == *i* ]] && source "${pkgs.blesh}/share/blesh/ble.sh" --noattach

      
      __git_branch() {
        local b
        b=$(git symbolic-ref --short HEAD 2>/dev/null) || b=$(git rev-parse --short HEAD 2>/dev/null) || return 0
        printf ' (%s)' "$b"
      }
      PS1='\[\e[38;2;122;162;247m\]\u@\h\[\e[0m\] \[\e[38;2;158;206;106m\]\w\[\e[38;2;224;175;104m\]$(__git_branch)\[\e[0m\] \[\e[38;2;187;154;247m\]\$\[\e[0m\] '

      if [[ ''${BLE_VERSION-} ]]; then
        ble-bind -m emacs -f 'C-m' accept-line
        ble-bind -m emacs -f 'RET' accept-line
      fi

      [[ ''${BLE_VERSION-} ]] && ble-attach
    '';
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  home.packages = [ pkgs.bash-completion ];
}
