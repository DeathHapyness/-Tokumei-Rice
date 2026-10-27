{ config, pkgs, lib, ... }:

# Bash "turbinado": completion, histórico melhor, prompt colorido (Tokyo
# Night) com branch git, fuzzy search via fzf (Ctrl+R / Ctrl+T / Alt+C) e
# highlight de sintaxe + autosugestões via ble.sh (estilo zsh, mas em bash).
{
  programs.bash = {
    enable = true;
    enableCompletion = true;

    historySize = 100000;
    historyFileSize = 500000;
    historyControl = [ "ignoredups" "ignorespace" "erasedups" ];

    shellOptions = [
      "histappend" # não sobrescreve o arquivo de histórico, só acrescenta
      "checkwinsize"
      "extglob"
      "globstar" # ** para busca recursiva
      "checkjobs"
      "cdspell" # corrige pequenos erros de digitação em `cd`
      "autocd" # digitar só o nome do diretório já entra nele
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
      # --- ble.sh: highlight de sintaxe + autosugestões (precisa ser a
      # primeira coisa carregada, com --noattach; o attach vem no final) ---
      [[ $- == *i* ]] && source "${pkgs.blesh}/share/blesh/ble.sh" --noattach

      # --- prompt colorido (paleta Tokyo Night) com branch git ---
      __git_branch() {
        local b
        b=$(git symbolic-ref --short HEAD 2>/dev/null) || b=$(git rev-parse --short HEAD 2>/dev/null) || return 0
        printf ' (%s)' "$b"
      }
      PS1='\[\e[38;2;122;162;247m\]\u@\h\[\e[0m\] \[\e[38;2;158;206;106m\]\w\[\e[38;2;224;175;104m\]$(__git_branch)\[\e[0m\] \[\e[38;2;187;154;247m\]\$\[\e[0m\] '

      # --- corrige Enter no kitty: com o protocolo de teclado estendido
      # do kitty, o Enter às vezes chega como "RET" em vez do "C-m"
      # tradicional, e o ble.sh só tinha C-m amarrado ao accept-line —
      # daí só o Ctrl+J (que sempre chega como \n cru) executava o
      # comando. Amarrando os dois, Enter volta a funcionar sozinho.
      if [[ ''${BLE_VERSION-} ]]; then
        ble-bind -m emacs -f 'C-m' accept-line
        ble-bind -m emacs -f 'RET' accept-line
      fi

      # --- attach do ble.sh: precisa ser a ÚLTIMA linha do .bashrc ---
      [[ ''${BLE_VERSION-} ]] && ble-attach
    '';
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  home.packages = [ pkgs.bash-completion ];
}
