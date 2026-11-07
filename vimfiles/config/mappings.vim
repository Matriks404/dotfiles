" Set spacebar as the leader shortcut key.
let mapleader = "\<Space>"


" Don't use Q for Ex mode, use it for formatting (except for select mode).
noremap Q gq
sunmap Q


" Remap :h to always open in a vertical split on the right.
cnoreabbrev h vert rightbelow help


" Delete to black hole register (no clipboard overwrite).
nnoremap <leader>dd "_dd
vnoremap <leader>d "_d


" CTRL+U in insert mode deletes a lot. Use CTRL+G u to first break undo,
" so that CTRL+U can be undone after inserting a line break.
inoremap <C-U> <C-G>u<C-U>


" Toggle line numbers
nnoremap <leader>n :set number!<CR>


" Quick save and quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>


" Go to the next and previous link in normal mode.
nnoremap <leader>j /\|\zs.\{-}\ze\|<CR>
nnoremap <leader>k ?\|\zs.\{-}\ze\|<CR>


" Disable hlsearch temporarily after following a link.
nnoremap <C-]> <C-]>:noh<CR>


" Insert a blank line below or above current one, without editing it.
nnoremap <CR> :put _<CR>
nnoremap <BS> :put! _<CR>


" Keymap key bindings for English, Russian, and Ukrainian.
nnoremap <leader>ge :set keymap=<CR>
nnoremap <leader>gr :set keymap=russian-jcukenwin<CR>
nnoremap <leader>gu :set keymap=ukrainian-jcuken<CR>


" Use <ESC> key in terminal mode to exit it easily.
tnoremap <leader><ESC> <C-\><C-n>
