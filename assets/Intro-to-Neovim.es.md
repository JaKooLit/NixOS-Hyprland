# Introducción a Neovim

¡Bienvenido! Esta chuleta introduce Neovim tal y como está configurado en nixvim

Se centra en tareas para principiantes y los plugins/atajos clave de este setup.

Aspectos destacados

- UI moderna: tema Catppuccin, Lualine, bufferline, iconos
- Explorador de archivos: Neo‑tree
- Búsqueda: Telescope (buscar archivos, ripgrep en vivo)
- LSP: autocompletado/diagnósticos/formateo al guardar
- Diagnósticos UI: Trouble; which‑key; notificaciones
- Terminal: ToggleTerm; integración con LazyGit
- Markdown: previsualización en vivo
- Movimientos: hop y leap para saltos rápidos
- Comentado, autocompletado, snippets, autopairs

Tecla Leader

- “Leader” es un prefijo para atajos personalizados. En esta config suele ser Space. Pulsa Space para ver which‑key con grupos disponibles.
- Notación: <leader>ff significa Space, luego f y f.

Primeros pasos

- Abrir Neovim:
    ```bash path=null start=null
    nvim
    ```
- Ayuda: <leader>h para :help, o <leader>H para ayuda de la palabra bajo el cursor.
- Salir de Insert: escribe jk rápido (mapeado a <Esc>).

Navegación y modos

- Modos: Normal, Insert (i), Visual (v), Comando (:)
- Movimiento: h izq, j abajo, k arriba, l der
- Palabras: w siguiente, b anterior, e fin
- Líneas: 0 inicio, ^ primer no blanco, $ fin
- Pantallas: Ctrl‑f avanza, Ctrl‑b retrocede
- Buscar: /patrón, n siguiente, N anterior; limpia resaltado con <leader>nh

Abrir/crear/leer archivos

- Abrir archivo:
    ```vim path=null start=null
    :e ruta/al/archivo
    ```
- Crear (editar un nombre nuevo):
    ```vim path=null start=null
    :e nuevo.txt
    ```
- Leer archivo en el buffer actual:
    ```vim path=null start=null
    :r ruta/a/otro
    ```
- Leer salida de un comando:
    ```vim path=null start=null
    :r !ls -la
    ```

Guardar y salir

- Guardar: :w
- Salir: :q
- Guardar y salir: :wq (o :x)
- Salir sin guardar: :q!
- Guardar todo: :wa
- Cerrar buffer (mantener ventana): :bd

Ventanas y buffers

- Dividir: :sp (horizontal), :vsp (vertical)
- Mover entre ventanas: Ctrl‑w h/j/k/l
- Siguiente/anterior buffer: :bnext / :bprevious
- Listar buffers: :ls

Portapapeles, copiar/pegar

- Esta config habilita el portapapeles del sistema (unnamedplus). Los yanks van al portapapeles.
- Copiar: y (yy línea entera)
- Pegar: p / P
- Portapapeles explícito: "+y para copiar, "+p para pegar

Explorador (Neo‑tree)

- Toggle: <leader>e o <leader>fe
- Atajos típicos: Enter abre; a añadir; r renombrar; d borrar; y copiar, p pegar; s/v split/vsplit

Búsqueda (Telescope)

- Buscar archivos: <leader>ff
- Grep en vivo: <leader>lg
- Controles: Arriba/Abajo, Enter, Ctrl‑q a quickfix, Esc cierra

Terminal y LazyGit

- Toggle terminal: <leader>t
- En terminal: Ctrl‑\ y luego Ctrl‑n para Normal
- LazyGit:
    ```vim path=null start=null
    :LazyGit
    ```

Diagnósticos y LSP

- Lista de diagnósticos (Trouble): <leader>dt
- Siguiente/anterior diagnóstico: <leader>dj / <leader>dk
- Mostrar diagnóstico de la línea actual: <leader>dl
- Formatear:
    ```vim path=null start=null
    :lua vim.lsp.buf.format()
    ```
- Info LSP:
    ```vim path=null start=null
    :LspInfo
    ```

Comentarios, completado, pares, snippets

- Comentarios: gcc (línea), gc en visual (selección)
- nvim‑cmp: autocompletado; Enter/Tab según tu preferencia
- Autopairs: cierra brackets/comillas
- Snippets (luasnip): expande con Tab/Enter (según contexto)

Markdown preview

- Toggle: <leader>mp

Mociones

- hop y leap habilitados; consulta :help hop y :help leap

Corrección ortográfica

- Inglés habilitado con wordlist. Comandos:
    - Activar/desactivar: :set spell / :set nospell
    - Siguiente/anterior error: ]s / [s
    - Sugerencias: z=
    - Añadir palabra: zg; deshacer: zw

Git

- Gitsigns muestra cambios en el margen.
- Diffview:
    ```vim path=null start=null
    :DiffviewOpen
    :DiffviewClose
    ```

Notificaciones y ayuda

- nvim‑notify muestra avisos.
- F1 desactivado. Usa:
    - <leader>h :help
    - <leader>H ayuda contextual

Which‑key y chuletas

- Pulsa Space para ver which‑key.
- Hay un plugin de chuleta interactiva.

Solución de problemas

- Salud:
    ```vim path=null start=null
    :checkhealth
    ```
- Mensajes:
    ```vim path=null start=null
    :messages
    ```
- Reiniciar LSP:
    ```vim path=null start=null
    :LspRestart
    ```

Referencia rápida

- Modos: i, v, Esc, :
- Guardar/salir: :w / :q / :wq / :q!
- Abrir/crear: :e archivo
- Leer a buffer: :r archivo
- Buscar: /patrón; n/N; limpiar <leader>nh
- Explorador: <leader>e
- Archivos: <leader>ff; Grep: <leader>lg
- Terminal: <leader>t; LazyGit: :LazyGit
- Diagnósticos: <leader>dt, <leader>dj / <leader>dk, <leader>dl
- Ayuda: <leader>h, <leader>H

Consejo: empieza con which‑key. Pulsa Space y sigue las pistas en pantalla.
