" 1. Essential Vim initalization
filetype plugin indent on


" 2. Source some configuration files
source ~/vimfiles/config/options.vim
source ~/vimfiles/config/autocmds.vim
source ~/vimfiles/config/mappings.vim


" 3. Load optional built-in packages
if has('vim_starting') && has('syntax') && has('eval')
    silent! packadd! comment
    silent! packadd! hlyank | let g:hlyank_duration = 250
    silent! packadd! matchit
    silent! packadd! nohlsearch
endif


" 4. Custom commands
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif


" 5. Syntax and color scheme setup
if &t_Co > 1
    syntax on

    set background=dark

    if !empty($XDG_CURRENT_DESKTOP)
        colorscheme habamax
    else
        colorscheme darkblue
    endif
endif




