" Enable syntax higlighting.
syntax on


" Set spacebar as the leader shortcut key.
let mapleader = "\<Space>"


" Delete to black hole register (no clipboard overwrite).
vnoremap <leader>d "_d
nnoremap <leader>dd "_dd


" Go to the next and previous link.
nnoremap <leader>j /\|\zs.\{-}\ze\|<CR>
nnoremap <leader>k ?\|\zs.\{-}\ze\|<CR>


" Disable hlsearch temporarily after following a link.
nnoremap <C-]> <C-]>:noh<CR>


" Don't use Q for Ex mode, use it for formatting (except for select mode).
map Q gq
sunmap Q


" CTRL+U in insert mode deletes a lot. Use CTRL+G u to first break undo,
" so that CTRL+U can be undone after inserting a line break.
inoremap <C-U> <C-G>u<C-U>


" Keymap key bindings for English, Russian, and Ukrainian.
nnoremap <leader>ge :set keymap=<CR>
nnoremap <leader>gr :set keymap=russian-jcukenwin<CR>
nnoremap <leader>gu :set keymap=ukrainian-jcuken<CR>


" Various settings.
set display+=lastline
set scrolloff=8
set nrformats-=octal

" Code indentation and tab spacing rules.
set autoindent
set smartindent
set expandtab

set shiftwidth=4
set softtabstop=4
set tabstop=4


" Enable filetype magic.
filetype plugin indent on


" User interface preferences.
set number
set showcmd
set wildmenu
set background=dark


" Search behavior tweaks.
set hlsearch
set incsearch


" History tweaks.
set history=1000


" Persistent undo.
if has('persistent_undo')
    if !isdirectory(expand('~/.vim/undodir'))
        call mkdir(expand('~/.vim/undodir'), 'p')
    endif

    set undodir=~/.vim/undodir
    set undofile
endif


" Centralized swap files.
if !isdirectory(expand('~/.vim/swapdir'))
    call mkdir(expand('~/.vim/swapdir'), 'p')
endif

set directory=~/.vim/swapdir//


" Centralized backup files.
if has('writebackup')
    if !isdirectory(expand('~/.vim/backupdir'))
        call mkdir(expand('~/.vim/backupdir'), 'p')
    endif

    set backupdir=~/.vim/backupdir//
endif


" Enable 24-bit RGB true color in terminal.
if has('termguicolors')
    set termguicolors
endif


" Load optional built-in packages safely on startup
if has('vim_starting') && has('syntax') && has('eval')
    silent! packadd! comment
    silent! packadd! matchit
endif


" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif


augroup HelpMouse
    autocmd!

    " Enable mouse in help buffers
    autocmd FileType help set mouse=a

    " Reset mouse when entering any other buffer type
    autocmd BufEnter *
        \ if &filetype ==# 'help' |
        \   setlocal mouse=a |
        \ else |
        \   setlocal mouse= |
        \ endif
augroup END


" Set color scheme.
set background=dark

if !empty($XDG_CURRENT_DESKTOP)
    colorscheme habamax
else
    colorscheme darkblue

    highlight Normal guibg=#000b1e
    highlight NonText guibg=#000b1e
endif


" Automatically remove trailing whitespace before saving.
augroup StripTrailingWhitespace
    autocmd!

    autocmd BufWritePre * %s/\s\+$//e
augroup END


" When editing/viewing text or markdown files use the ignorecase and smartcase
" options.
augroup NotesCase
    autocmd!

    autocmd FileType markdown,text setlocal ignorecase smartcase
augroup END


" Re-detect filetype when saving a file that currently has no filetype.
augroup DynamicFiletype
    autocmd!

    autocmd BufWritePost * if empty(&filetype) | filetype detect | endif
augroup END
