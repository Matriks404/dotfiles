" Enable syntax higlighting.
syntax on


" Set spacebar as the leader shortcut key.
let mapleader = "\<Space>"


" Delete to black hole register (no clipboard overwrite).
vnoremap <leader>d "_d
nnoremap <leader>dd "_dd


" Various settings.
set backup
set display+=lastline
set scrolloff=8


" Code indentation and tab spacing rules.
set autoindent
set smartindent
set expandtab

set shiftwidth=4
set softtabstop=4
set tabstop=4

filetype plugin indent on


" User interface preferences.
set number
set showcmd
set wildmenu
set background=dark


" Search behavior tweaks.
set hlsearch
set incsearch


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


" Enable 24-bit RGB true color in terminal.
if has('termguicolors')
    set termguicolors
endif


" Add 'matchit' optional package.
if has ('syntax') && has('eval')
    packadd! matchit
endif


augroup HelpMouse
    autocmd!

    " Enable mouse in help buffers
    autocmd FileType help setlocal mouse=a
    "
    " Reset mouse when entering any other buffer type
    autocmd BufEnter * if &filetype !=# 'help' | set mouse= | endif
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

    autocmd BufWritePost * if &filetype == '' | filetype detect | endif
augroup END
