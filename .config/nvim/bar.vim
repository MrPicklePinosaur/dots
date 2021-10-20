
" statusline
function! StatusModeColor()
    if (mode() =~# '\v(n|no)')
        hi StatusLine cterm=None gui=None ctermfg=black ctermbg=Yellow
    elseif (mode() =~# '\v(v|V|)')
        hi StatusLine cterm=None gui=None ctermfg=black ctermbg=Red
    elseif (mode() ==# 'i')
        hi StatusLine cterm=None gui=None ctermfg=black ctermbg=LightBlue
    elseif (mode() ==# 'c') 
        hi StatusLine cterm=None gui=None ctermfg=black ctermbg=Green
    else
        hi StatusLine cterm=None gui=None ctermfg=black ctermbg=DarkGrey
    endif
endfunction

function! StatusModifiedColor()
    if &mod
        hi User1 cterm=None gui=None ctermfg=Black ctermbg=Magenta
    else
        hi User1 cterm=None gui=None ctermfg=White ctermbg=Black
    endif
endfunction

function! ReloadBar()
    call StatusModeColor()
    call StatusModifiedColor()
    return ''
endfunction

function! BufCount()
    return printf("%d/%d", bufnr("%"), len(getbufinfo({'buflisted':1})))
endfunction

autocmd BufEnter * call ReloadBar()
autocmd BufWritePost <buffer> call ReloadBar()

set laststatus=2
set statusline=
set statusline+=%{ReloadBar()}
set statusline+=%1*\ | 
set statusline+=%0*\ nvim\ \[%{mode()}\]
set statusline+=\[%{BufCount()}\]
set statusline+=\ %1*\ %{expand('%:~:.')}\ %m
set statusline+=%=
set statusline+=%y
set statusline+=\ %0*
set statusline+=\ %r\[%{v:register}\]
set statusline+=\ %l/%L:%c\ |
set statusline+=%1*\ |

" Tab line
hi TabLineSel   cterm=Bold ctermfg=Yellow
hi TabLine      cterm=None ctermfg=Grey ctermbg=Black
hi TabLineFill  cterm=None ctermbg=Black

" Templates
augroup templates
    autocmd BufNewFile *.tex 0r ~/.vim/templates/skeleton.tex
    autocmd BufNewFile *.html 0r ~/.vim/templates/skeleton.html
    autocmd BufNewFile *.rkt 0r ~/.vim/templates/skeleton.rkt
    autocmd BufNewFile *.xml 0r ~/.vim/templates/skeleton.xml
augroup END
