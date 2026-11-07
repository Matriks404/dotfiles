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


" Set up custom highlight colors.
augroup CustomColors
    autocmd!

    autocmd ColorScheme habamax
        \ highlight StatusLine cterm=bold gui=bold guifg=#ffffff guibg=#1e3a8a |
        \ highlight StatusLineNC cterm=NONE gui=NONE guifg=#334155 guibg=#e2e8f0

    autocmd ColorScheme darkblue
        \ highlight Normal guibg=#000b1e |
        \ highlight NonText guibg=#000b1e
augroup END
