# Intro to Neovim

Welcome! This cheatsheet introduces Neovim as configured with nixvim

It focuses on beginner tasks and the key plugins and keymaps in this setup.

Highlights of this configuration

- Modern UI: Catppuccin theme, Lualine statusline, bufferline, icons
- File explorer: Neo‑tree
- Search: Telescope (find files, ripgrep live search)
- LSP: Language Server Protocol (syntax, diagnostics, formatting on save)
- Diagnostics UI: Trouble list; which‑key helper; notify popups
- Terminal: ToggleTerm (inline terminal); LazyGit integration
- Markdown: Live preview
- Motions: hop and leap for fast jumping
- Commenting, autocompletion, snippets, autopairs

What is the Leader key?

- The “leader” is a prefix for custom shortcuts. In this config, it’s typically Space. Try pressing Space and you should see a which‑key popup listing available groups.
- Notation: <leader>ff means press Space, then f, then f.

First steps

- Start Neovim: from a terminal, run:
    ```bash path=null start=null
    nvim
    ```
- Get help: press <leader>h to open a :help prompt, or <leader>H to open help for the word under cursor.
- Escape Insert mode: press jk quickly (mapped to <Esc>).

Basic navigation and modes

- Modes: Normal (default), Insert (i), Visual (v), Command (:)
- Move: h left, j down, k up, l right
- Words: w next word, b back word, e end of word
- Lines: 0 start, ^ first non‑blank, $ end
- Screens: Ctrl‑f forward page, Ctrl‑b back page
- Search: /pattern, n next, N previous; clear highlights with <leader>nh

Open, create, read files

- Open a file:
    ```vim path=null start=null
    :e path/to/file
    ```
- Create a new file (just edit a new name):
    ```vim path=null start=null
    :e newfile.txt
    ```
- Read a file into current buffer at cursor:
    ```vim path=null start=null
    :r path/to/otherfile
    ```
- Read command output into buffer:
    ```vim path=null start=null
    :r !ls -la
    ```

Save and quit

- Save: :w
- Quit: :q
- Save and quit: :wq (or :x)
- Quit without saving: :q!
- Save all: :wa
- Close buffer (keep window): :bd

Windows and buffers

- Split window: :sp (horizontal), :vsp (vertical)
- Move between windows: Ctrl‑w h/j/k/l
- Next/previous buffer: :bnext / :bprevious
- List buffers: :ls

Clipboard, copy/paste

- This config enables system clipboard (unnamedplus) and Wayland/X11 providers, so yanks go to your system clipboard.
- Copy text: y in normal/visual (yy for a whole line)
- Paste: p (after cursor) or P (before cursor)
- System clipboard explicitly: "+y to copy, "+p to paste

File explorer (Neo‑tree)

- Toggle Neo‑tree: <leader>e or <leader>fe
- In Neo‑tree (common defaults):
    - Enter: open
    - a: add file/directory
    - r: rename
    - d: delete
    - y: copy, p: paste (within Neo‑tree)
    - s / v: open in split / vsplit (varies by setup)

Search (Telescope)

- Find files by name: <leader>ff
- Live grep (ripgrep content search): <leader>lg
- Common Telescope controls: Up/Down to navigate, Enter to open, Ctrl‑q to send to quickfix list, Esc to close

Terminal and LazyGit

- Toggle inline terminal: <leader>t
- In the terminal buffer: press Ctrl‑\ then Ctrl‑n to return to Normal mode if needed
- LazyGit integration is enabled; run:
    ```vim path=null start=null
    :LazyGit
    ```

Diagnostics and LSP

- Diagnostic list (Trouble): <leader>dt (toggle)
- Next/previous diagnostic: <leader>dj / <leader>dk
- Show diagnostic for current line: <leader>dl
- Formatting on save is enabled where supported. You can also run:
    ```vim path=null start=null
    :lua vim.lsp.buf.format()
    ```
- LSP info / servers:
    ```vim path=null start=null
    :LspInfo
    ```

Comments, completion, pairs, snippets

- Comments (comment‑nvim defaults):
    - gcc to toggle comment on current line
    - gc in visual mode to toggle selection
- Autocompletion (nvim‑cmp): starts automatically; use Enter/Tab per your insert‑mode behavior
- Auto‑pairs: brackets/quotes auto‑close
- Snippets (luasnip): many language snippets are available; expand with Tab/Enter (depends on context)

Markdown preview

- Toggle Markdown live preview: <leader>mp

Motion helpers

- hop and leap are enabled for fast jumping; try searching for a character or pattern (consult :help hop and :help leap for details). Great for quickly moving around large files.

Spellcheck

- English spellcheck is enabled with a programming wordlist that auto‑updates on first run.
- Useful commands:
    - Toggle spell: :set spell / :set nospell
    - Next/prev misspelling: ]s / [s
    - Suggestions for word under cursor: z=
    - Add word to dictionary: zg
    - Undo added word: zw

Git integration

- Signs in the gutter (gitsigns) show added/changed lines.
- Diffview is available for rich diffs:
    ```vim path=null start=null
    :DiffviewOpen
    :DiffviewClose
    ```

Notifications and help

- Notifications appear via nvim‑notify.
- F1 is disabled to prevent accidental help popups; use:
    - <leader>h to open :help prompt
    - <leader>H for help on word under cursor

Which‑key and cheatsheet

- Press the leader (Space) to see a which‑key popup of available keys.
- A cheatsheet plugin is enabled—explore keymaps interactively.

Troubleshooting

- Check health:
    ```vim path=null start=null
    :checkhealth
    ```
- See messages/notifications:
    ```vim path=null start=null
    :messages
    ```
- If completion/diagnostics feel off, reload LSP:
    ```vim path=null start=null
    :LspRestart
    ```

Quick reference

- Modes: i (insert), v (visual), Esc (back to normal), : (command)
- Save/quit: :w / :q / :wq / :q!
- Open/create: :e file
- Read file into current: :r file
- Search: /pattern then n/N; clear highlights <leader>nh
- File explorer: <leader>e (Neo‑tree)
- Find files: <leader>ff; Live grep: <leader>lg
- Terminal: <leader>t; LazyGit: :LazyGit
- Diagnostics: <leader>dt (list), <leader>dj / <leader>dk (nav), <leader>dl (line)
- Help: <leader>h, <leader>H

Tip: Start with which‑key. Press Space and follow the on‑screen hints to discover available actions in this setup.
