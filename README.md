# zellij-conf

Configuração pessoal do [Zellij](https://zellij.dev/) com atalhos para painéis, abas e sidecars de agentes.

## Instalação

```sh
brew install zellij
git clone https://github.com/IsraelAraujo70/zellij-conf ~/.config/zellij
```

Para iniciar o Zellij automaticamente em novos terminais, adicione ao fim do `~/.zshrc` ou `~/.bashrc`:

```sh
[ -r "$HOME/.config/zellij/shell/auto-start.sh" ] && \
  source "$HOME/.config/zellij/shell/auto-start.sh"
```

O script não cria sessões aninhadas dentro de tmux ou Zellij e não inicia o Zellij nos terminais do cmux, que já oferece workspaces e painéis. Para abrir temporariamente um shell sem o auto-start em outro terminal:

```sh
ZELLIJ_AUTO_START=false zsh
```

## Layouts

```sh
zellij --layout claude-sidecar
zellij --layout codex-sidecar
zellij --layout opencode-sidecar
```

## Validação

```sh
bash tests/check.sh
```
