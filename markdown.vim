" TODO: figure out how to make stuff reference this variable, rather than
" copy-pasting it everywhere
" let g:checkboxregex=/\(^\s*- \[\)\@<=[^XCTFxctf]\(\] \)\@=/

" automatically highlight TODO items
syn match mdcheckbox /\(^\s*- \[\)\@<=[^XCTFxctf]\(\] \)\@=/
hi link mdcheckbox Todo

syn match mdTODO /\<T\cODO\>/
hi link mdTODO Todo

syn match mdTODONT /\<T\cODONT\>/
hi link mdTODONT Error

syn match mdNOTE /\<N\cOTE\>/
hi link mdNOTE Todo

" find todo list item (any todo that isn't completed (X), cancelled (C), transferred (T), or failed (F))
nmap <Leader>/td   /\(^\s*- \[\)\@<=[^XCTFxctf]\(\] \)\@=/<Return>

"autocmd FileType markdown nmap <Leader>/td   /\[[^XCTFxctf]\]<Return>
imap <c-l>/td <Esc>/\(^\s*- \[\)\@<=[^XCTFxctf]\(\] \)\@=/<Return>

" add TODO list item 
nmap <Leader>td o- [ ] 
imap <c-l>td <Esc>o- [ ] 

" check off a TODO item
nmap <Leader>ck 0f[lrX<Esc>
imap <c-l>ck <Esc>0f[lrX<Esc>

" mark a TODO item as critical
nmap <Leader>cr 0f]a<Space>(!)<Esc>
imap <c-l>cr <Esc>0f]a<Space>(!)<Esc>

" uncheck a TODO item
nmap <Leader>uk 0f[lr <Esc>
imap <c-l>uk 0f[lr <Esc>

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
