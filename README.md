<h1>
  Tokumei Rice<sub>(匿名)</sub>
</h1>


## Sumário

- [Visão geral](#visão-geral)
- [Instalação](#instalação)
- [Estrutura do repositório](#estrutura-do-repositório)
- [Editando o rice](#editando-o-rice)
- [Sistema de temas](#sistema-de-temas)
- [Atalhos do niri](#atalhos-do-niri)
- [Segurança e privacidade](#segurança-e-privacidade)
- [Solução de problemas](#solução-de-problemas)

## Visão geral

| Item | Detalhe |
|---|---|
| Sistema | NixOS (nixpkgs `unstable`) |
| Gerência do usuário | home-manager |
| Sessão | niri (Wayland), GDM + GNOME mantidos como alternativa |
| Terminal / launcher | kitty / fuzzel |
| Barra / notificações | waybar / mako |
| Bloqueio / power | swaylock + swayidle / wlogout |
| Tema padrão | Tema Personalizado |
| Bootloader | systemd-boot |

## Instalação

```bash
cd ~/nixos-config
sudo nixos-rebuild switch --flake .#nixos
```

> [!WARNING]
> O `switch` reinicia o display manager (GDM). Se houver uma sessão gráfica
> ativa, **salve seu trabalho antes**.

Depois do switch, na tela de login do GDM, clique na engrenagem perto do botão
de entrar e escolha a sessão **niri**.

**Rollback:** a geração anterior (GNOME puro) continua disponível no menu do
systemd-boot ao reiniciar.

> Nos arquivos, `<usuario>` é o nome do diretório do seu usuário em `home/`.

## Editando o rice

1. Altere os arquivos em `home/<usuario>/*.nix` (binds em `niri.nix`, cores
   estáticas em `theme.nix`,Rice vem com pacotes que o propriotario usava e achava necessario,revise antes de rodar rebuild, etc.).
2. Rode o `switch` novamente:

   ```bash
   sudo nixos-rebuild switch --flake .#nixos
   ```

Não edite nada direto em `~/.config`: os arquivos lá são symlinks gerados pelo
home-manager. **A exceção** são os arquivos gerados dinamicamente pelo sistema
de temas (próxima seção).

## Sistema de temas

Inspirado no omarchy: troca de tema e de layout **em tempo real, sem rebuild**,
tudo em bash.

| Atalho | Ação |
|---|---|
| `Super+T` | menu (fuzzel) para escolher o tema |
| `Super+Shift+T` | menu (fuzzel) para escolher o layout da waybar |

### Temas disponíveis

`nord` · `catppuccin-mocha` · `gruvbox-dark` · `everforest` · `dracula` ·
`rose-pine` · `kanagawa-wave` · `tokyo-night`

### Layouts da waybar

| Layout | Descrição |
|---|---|
| `minimal` | só workspaces, hora e bateria, tudo em uma única pílula |
| `medio` | o padrão |
| `gadgets` | cpu, memória, disco, rede, título da janela, etc. |

### Controles interativos da waybar

A waybar tem scripts que permitem ajustar o sistema direto pela barra, sem
abrir terminal:

| Módulo | Interação | Ação |
|---|---|---|
| Brilho | rolar (scroll) com o touchpad sobre o módulo | aumenta ou diminui o brilho da tela |
| Bateria | clicar no ícone | alterna o perfil de energia/desempenho (modo econômico e demais perfis) |

### Como funciona

Os scripts em `rice/scripts/` (`rice-apply-theme`, `rice-apply-waybar`,
`rice-theme-picker`, `rice-waybar-picker`) renderizam os templates de
`rice/templates/*.tpl` com `sed`, substituindo tokens como `@BG@` e `@FG@`
pelas cores do tema escolhido. O resultado é escrito direto em
`~/.config/{niri,waybar,fuzzel,mako,kitty}/`, no lugar dos symlinks do
home-manager. Por isso a troca é instantânea:

- niri recarrega sozinho
- waybar é reiniciada
- mako recarrega a configuração

Cada `nixos-rebuild switch` reaplica o tema e o layout atuais
(`home.activation.riceReseed` em `rice.nix`), então alterar templates e rodar
`switch` também funciona.

### Adicionando um tema

1. Crie `home/<usuario>/rice/themes/nome.sh` com os mesmos campos dos outros
   temas (um `VAR="#hex"` por linha).
2. Rode o `switch`. O tema já aparece no menu.

### Fora do sistema de temas

Estes componentes ficam sempre em Tokyo Night (definido em `theme.nix`):
**wlogout**, **swaylock** e **gtk/qt**. O fastfetch também usa essa paleta
estática.

## Atalhos do niri

`Super` é a tecla do Windows/Command.

### Janelas e foco

| Atalho | Ação |
|---|---|
| `Super+Enter` | abre o terminal (kitty) |
| `Super+Q` | fecha a janela em foco |
| `Super+Espaço` | abre o launcher (fuzzel) |
| `Super+Setas` | move o foco entre janelas/colunas |
| `Super+Shift+Setas` | move a janela em foco de coluna/workspace |
| `Super+F` | maximiza a coluna |
| `Super+Shift+F` | tela cheia |
| `Super+V` | alterna janela flutuante |
| `Super+O` | overview nativo do niri |

### Workspaces

| Atalho | Ação |
|---|---|
| `Super+1..5` | vai para o workspace 1–5 |
| `Super+Shift+1..5` | envia a janela para o workspace 1–5 |

### Rice e ferramentas

| Atalho | Ação |
|---|---|
| `Super+T` | seletor de tema |
| `Super+Shift+T` | seletor de layout da waybar |
| `Super+Shift+V` | histórico do clipboard (cliphist + fuzzel) |
| `Super+Shift+S` | print de região com anotação (grim + slurp + swappy) |
| `Print` | print rápido nativo do niri (região, copia para o clipboard) |

### Sessão

| Atalho | Ação |
|---|---|
| `Super+L` | bloqueia a tela |
| `Super+Shift+E` | menu de power (wlogout) |

## Segurança e privacidade

### Rede

- MAC do wifi randomizado a cada conexão nova (NetworkManager)
- Connectivity check do NetworkManager desligado
- Firewall via nftables: nega tudo por padrão, sem log de recusados
- IPv6 privacy extensions (endereços temporários)
- DNS-over-TLS oportunista via `systemd-resolved`, com fallback nos resolvers
  da Mullvad
- `macchanger` disponível para troca manual de MAC (ex.: conexão por cabo)

### Anonimato

- **Tor**: daemon cliente local com SOCKS5 em `127.0.0.1:9050`, mais `torsocks`
- **Tor Browser** instalado para navegação anônima
- **Mullvad VPN** (daemon + GUI) instalado e habilitado

### Navegador e sessão

- Firefox com telemetria e Pocket desligados, HTTPS-Only, tracking protection
  e DNS-over-HTTPS pela Mullvad
- Bloqueio de tela após 5 min de inatividade (swayidle + swaylock); o monitor
  desliga após 10 min

## Solução de problemas

| Problema | O que fazer |
|---|---|
| A sessão niri não aparece no GDM | confirme o `switch`, reinicie o GDM (ou o PC) e abra o menu de sessão na engrenagem |
| Algo quebrou após o switch | reinicie e escolha a geração anterior no menu do systemd-boot |
| Quero validar sem aplicar | `nixos-rebuild build --flake .#nixos` e `nix flake check` |
| Config do niri com erro | `niri validate` |
| Tema não muda ao editar `~/.config` | normal: esses arquivos são regerados; edite os templates/temas em `rice/` e rode o `switch` |