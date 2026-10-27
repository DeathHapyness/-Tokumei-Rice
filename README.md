# nixos-config — rice niri

Config completa via flake + home-manager. Já validada: `nix flake check`,
`nixos-rebuild build --flake .#nixos` e `niri validate` passaram limpos.

## Aplicar

```
cd ~/nixos-config
sudo nixos-rebuild switch --flake .#nixos
```

Isso reinicia o display manager (GDM) — se você estiver numa sessão gráfica
ativa, salve o que estiver fazendo antes. Depois do switch, na tela de
login do GDM escolha a sessão **"niri"** no menu de sessão (ícone de
engrenagem perto do botão de entrar).

Se algo der errado, a geração anterior (GNOME puro, como estava antes)
continua disponível no menu do systemd-boot ao reiniciar.

## Estrutura

- `flake.nix` — entrada, pins de nixpkgs (unstable) e home-manager
- `hosts/nixos/configuration.nix` — sistema: boot, rede, firewall,
  DNS, Tor, Mullvad, GDM+GNOME (mantido), niri habilitado como sessão
- `home/death/` — tudo do usuário (niri, kitty, fastfetch, wlogout,
  gtk/qt, swaylock/swayidle)
- `home/death/theme.nix` — paleta Tokyo Night estática, usada só por
  wlogout, swaylock e fastfetch (não trocam de tema em tempo real)
- `home/death/rice.nix` + `home/death/rice/` — sistema de temas e
  layouts de waybar trocáveis em tempo real (veja abaixo)

## Editar o rice

Mude os arquivos em `home/death/*.nix` (binds em `niri.nix`, cores
estáticas em `theme.nix`, etc.) e rode o `switch` de novo. Nada é
editado direto em `~/.config` — os arquivos lá são só symlinks gerados
pelo home-manager, **exceto** o que o sistema de temas descrito abaixo
gera dinamicamente.

## Sistema de temas (estilo omarchy)

`Super+T` abre um menu fuzzel minimalista com os temas disponíveis;
`Super+Shift+T` abre o mesmo tipo de menu pra escolher o layout da
waybar. Tudo em bash, sem precisar de rebuild:

- `home/death/rice/themes/*.sh` — um arquivo por tema (nord,
  catppuccin-mocha, gruvbox-dark, everforest, dracula, rose-pine,
  kanagawa-wave, tokyo-night), cada um só com `VAR="#hex"`
- `home/death/rice/waybar-layouts/{minimal,medio,gadgets}/` —
  três layouts de waybar: **minimal** (só workspaces + hora + bateria,
  tudo numa pílula só), **medio** (o padrão atual) e **gadgets** (cpu,
  memória, disco, rede, título da janela, etc.)
- `home/death/rice/templates/*.tpl` — templates com tokens `@BG@`,
  `@FG@` etc. pro niri, fuzzel, mako e kitty
- `home/death/rice/scripts/*.sh` — a lógica: `rice-apply-theme`,
  `rice-apply-waybar`, `rice-theme-picker`, `rice-waybar-picker`

Esses scripts renderizam os templates (com `sed`) direto em
`~/.config/{niri,waybar,fuzzel,mako,kitty}/`, substituindo os arquivos
que normalmente seriam symlinks do home-manager — por isso a troca é
instantânea (niri recarrega sozinho, waybar reinicia, mako recarrega).
Cada `nixos-rebuild switch` reaplica o tema/layout atual automaticamente
(`home.activation.riceReseed` em `rice.nix`), então mudar os templates
e dar `switch` também funciona.

Pra adicionar um tema novo: crie `home/death/rice/themes/nome.sh` com
os mesmos campos dos outros e rode `switch` — ele já aparece no menu.

**Fora do sistema de temas** (ficam sempre em Tokyo Night, definido em
`theme.nix`): wlogout, swaylock e o gtk/qt do sistema.

## Atalhos do niri

| Atalho | Ação |
|---|---|
| `Super+Enter` | abre terminal (kitty) |
| `Super+Q` | fecha janela em foco |
| `Super+Espaço` | abre o launcher (fuzzel) |
| `Super+Setas` | move o foco entre janelas/colunas |
| `Super+Shift+Setas` | move a janela em foco de coluna/workspace |
| `Super+1..5` | vai pro workspace 1-5 |
| `Super+Shift+1..5` | manda a janela pro workspace 1-5 |
| `Super+O` | overview nativo do niri (visão geral de todas as janelas) |
| `Super+F` | maximiza coluna |
| `Super+Shift+F` | tela cheia |
| `Super+V` | alterna janela flutuante |
| `Super+T` | seletor de tema (fuzzel, estilo omarchy) |
| `Super+Shift+T` | seletor de layout da waybar (fuzzel) |
| `Super+L` | bloqueia a tela |
| `Super+Shift+E` | menu de power (wlogout) |
| `Super+Shift+V` | histórico de clipboard (cliphist + fuzzel) |
| `Super+Shift+S` | print de região com anotação (grim+slurp+swappy) |
| `Print` | print rápido nativo do niri (região, copia pro clipboard) |

## Segurança / anonimato configurados

- MAC do wifi randomizado a cada conexão nova (NetworkManager)
- "Connectivity check" do NetworkManager desligado
- Firewall via nftables, negando tudo por padrão, sem log de recusados
- IPv6 privacy extensions (endereços temporários)
- DNS-over-TLS oportunista via `systemd-resolved`, fallback nos
  resolvers da Mullvad
- Tor (daemon cliente local, SOCKS5 em `127.0.0.1:9050`) + `torsocks`
- Tor Browser instalado para navegação anônima de verdade
- Mullvad VPN (daemon + GUI) instalado e habilitado
- `macchanger` disponível para trocar MAC manualmente (ex: cabo)
- Firefox com telemetria/Pocket desligados, HTTPS-Only, tracking
  protection e DNS-over-HTTPS pela Mullvad
- Auto-lock da tela após 5 min de inatividade (swayidle+swaylock),
  monitor desliga em 10 min

