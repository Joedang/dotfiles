" TODO: figure out how to make stuff reference this variable, rather than
" copy-pasting it everywhere
" let g:checkboxregex=/\(^\s*- \[\)\@<=[^XCTSFxctsf]\(\] \)\@=/

" highlight open TODO items
syn match mdcheckbox /\(^\s*- \[\)\@<=[^XCTSFxctsf]\(\][ -]\)\@=/
hi link mdcheckbox Todo

" highlight priority
syn match mdpriority /\(^\s*- \[[^XCTSFxctsf]\]-([uie-]*\)\@<=[uie]\([uie-]*)\)\@=/
hi link mdpriority Todo
syn match mdexclam /\(^\s*- \[[^XCTSFxctsf]\]-\)\@<=(!*)/
hi link mdexclam Error

syn match mdTODO /\C\<TODO\>/
hi link mdTODO Todo

syn match mdTODONT /\C\<TODON['"]\?T\>/
hi link mdTODONT Error

syn match mdDONT /\C\<DON['"]\?T\>/
hi link mdDONT Error

syn match mdDONE /\C\<DONE\>/
hi link mdDONE Structure

syn match mdNOTE /\C\<NOTE\>/
hi link mdNOTE Todo

syn match mdBINGLE /\<\cbingle\>/
hi mdBINGLE cterm=bold,italic ctermbg=Magenta ctermfg=Green

" find todo list item (any todo that isn't completed (X), cancelled (C), transferred (T), or failed (F))
nmap <Leader>/td   /\(^\s*- \[\)\@<=[^XCTSFxctsf]\(\] \)\@=/<Return>

"autocmd FileType markdown nmap <Leader>/td   /\[[^XCTSFxctsf]\]<Return>
imap <c-l>/td <Esc>/\(^\s*- \[\)\@<=[^XCTSFxctsf]\(\] \)\@=/<Return>

" (add a) TODO list item  (pneumonic: To Do)
nmap <Leader>td o- [ ] 
imap <c-l>td <Esc>o- [ ] 

" tick-off a TODO item (pneumonic: TicK)
nmap <Leader>tk 0f[lrX<Esc>
imap <c-l>tk <Esc>0f[lrX<Esc>
nmap <Leader>tx 0f[lrX<Esc>
imap <c-l>tx <Esc>0f[lrX<Esc>

" reassign a TODO item
nmap <Leader>tr 0f[lr
imap <c-l>tr <Esc>0f[lr

" mark a TODO item as critical
nmap <Leader>tc 0f]a<Space>(!)<Esc>
imap <c-l>tc <Esc>0f]a<Space>(!)<Esc>

" uncheck a TODO item
nmap <Leader>tu 0f[lr <Esc>
imap <c-l>tu 0f[lr <Esc>

" turn on spell-checking for markdown
set spell

" define the function for setting fold level
" (heading level equals fold level, instead of fold level minus 1)
function! MarkdownLevel()
    let h = matchstr(getline(v:lnum), '^#\+')
    if empty(h)
        return "="
    else
        return ">" . len(h)
    endif
endfunction
setlocal foldexpr=MarkdownLevel()
setlocal foldmethod=expr
