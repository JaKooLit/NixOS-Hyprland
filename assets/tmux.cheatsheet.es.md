[English](./tmux.cheatsheet.md) | Español

# Tmux — Resumen y Cheatsheet

## 🚀 Resumen de modules/home/terminals/tmux.nix

### ⌨️ ¿Qué es el Prefijo de Tmux?

- El prefijo es una tecla especial que presionas antes de la mayoría de los comandos de tmux, para que tmux pueda distinguirlos de la escritura normal.
- Guía de notación utilizada a continuación:
    - C-x = mantén presionada la tecla Control y presiona x (ej., C-a significa Control+a)
    - M-x = mantén presionada la tecla Alt/Meta y presiona x (a veces se muestra como Alt+x)
    - S-x = mantén presionada la tecla Shift y presiona x (a menudo implícito para las letras mayúsculas)
- El prefijo predeterminado de Tmux es C-b (Control+b). En esta configuración se cambia a C-a (Control+a), lo que refleja el flujo de trabajo histórico de GNU Screen que muchos usuarios prefieren.

Ejemplos rápidos (con prefijo = C-a):

- Nueva ventana: presiona C-a y luego c
- Siguiente ventana: presiona C-a y luego n
- Dividir horizontalmente: presiona C-a y luego |
- Dividir verticalmente: presiona C-a y luego -
- Redimensionar a la izquierda: presiona C-a y luego C-h (mantén Control y presiona h)

- Programa
    - tmux habilitado; prefijo: C-a; modo de teclas: vi; baseIndex: 1; pane-base-index: 1
        - baseIndex: la numeración de las ventanas comienza en 1 en lugar de 0
        - pane-base-index: la numeración de los paneles dentro de una ventana comienza en 1 en lugar de 0
    - La terminal anula el RGB; la terminal se establece en "kitty"; shell: zsh
    - Ratón: habilitado; reloj de 12 horas; límite de historial: 5000; renumerar ventanas: activado

- Estado/UX
    - Barra de estado en la parte superior; passthrough: activado; confirmaciones reducidas (kill-pane sin aviso)

- Plugins
    - vim-tmux-navigator, sensible, catppuccin

---

## 🗝️ Cheatsheet de Atajos de Teclado

Navegación

- Prefijo h/j/k/l — seleccionar panel Izquierda/Abajo/Arriba/Derecha
- Prefijo o — seleccionar el siguiente panel
- C-Tab — siguiente ventana
- C-S-Tab — ventana anterior
- M-Tab — nueva ventana

Divisiones

- Prefijo | — dividir ventana -h (directorio actual)
- Prefijo \ — dividir ventana -fh (directorio actual)
- Prefijo - — dividir ventana -v (directorio actual)
- Prefijo \_ — dividir ventana -fv (directorio actual)

Redimensionar

- Prefijo C-h/C-j/C-k/C-l — redimensionar panel 15 columnas/filas en la dirección
- Prefijo m — alternar zoom (redimensionar panel -Z)

Ventanas

- Prefijo c — nueva ventana
- Prefijo n — siguiente ventana
- Prefijo p — ventana anterior (nota: la configuración asigna 'n' dos veces; se pretendía p para anterior)
- Prefijo t — modo reloj
- Prefijo q — mostrar paneles
- Prefijo u — refrescar cliente

Sesión/Recargar

- Prefijo r — cargar archivo ~/.config/tmux/tmux.conf
- Prefijo x — matar panel (sin aviso)

Ventanas Emergentes (display-popup)

- Prefijo C-y — lazygit (80%x80% en el directorio actual)
- Prefijo C-n — solicitar nombre de sesión; crear y cambiar
- Prefijo C-j — cambiar de sesión a través de fzf
- Prefijo C-r — yazi (90%x90% en el directorio actual)
- Prefijo C-z — nvim ~/ddubsos/flake.nix (90%x90%)
- Prefijo C-t — zsh (75%x75% en el directorio actual)

Menú (display-menu)

- Prefijo d — Menú de Dotfiles con entradas de apertura rápida:
    - f: flake.nix (ddubsOS)
    - c: paquetes principales (ddubsOS)
    - g: paquetes globales (ddubsOS)
    - k: atajos de teclado (Hyprland)
    - w: reglas de ventana (Hyprland)
    - z: ZaneyOS flake.nix
    - p: paquetes de ZaneyOS
    - q: Salir

Notas

- Los índices de paneles/ventanas comienzan en 1.
- Passthrough de terminal y RGB habilitados para color verdadero.
