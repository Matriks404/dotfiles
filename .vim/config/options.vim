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


" User interface preferences.
set background=dark

set number
set showcmd
set wildmenu

set laststatus=2
set mouse=a


" Search behavior tweaks.
set hlsearch
set incsearch


" History tweaks.
set history=1000


" Disable automatic comment insertion when opening a new line.
set formatoptions-=o


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
