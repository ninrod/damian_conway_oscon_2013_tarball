"====[ Make the 81st column stand out ]====================

    " EITHER the entire 81st column, full-screen...
    highlight ColorColumn ctermbg=magenta
    set colorcolumn=81

    " OR ELSE just the 81st column of wide lines...
    highlight ColorColumn ctermbg=magenta
    call matchadd('ColorColumn', '\%81v', 100)

    " OR ELSE on April Fools day...
    highlight ColorColumn ctermbg=red ctermfg=blue
    exec 'set colorcolumn=' . join(range(2,80,3), ',')


"=====[ Highlight matches when jumping to next ]=============

    " This rewires n and N to do the highlighing...
    nnoremap <silent> n   n:call HLNext(0.4)<cr>
    nnoremap <silent> N   N:call HLNext(0.4)<cr>


    " EITHER blink the line containing the match...
    function! HLNext (blinktime)
        set invcursorline
        redraw
        exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
        set invcursorline
        redraw
    endfunction

    " OR ELSE ring the match in red...
    function! HLNext (blinktime)
        highlight RedOnRed ctermfg=red ctermbg=red
        let [bufnum, lnum, col, off] = getpos('.')
        let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
        echo matchlen
        let ring_pat = (lnum > 1 ? '\%'.(lnum-1).'l\%>'.max([col-4,1]) .'v\%<'.(col+matchlen+3).'v.\|' : '')
                \ . '\%'.lnum.'l\%>'.max([col-4,1]) .'v\%<'.col.'v.'
                \ . '\|'
                \ . '\%'.lnum.'l\%>'.max([col+matchlen-1,1]) .'v\%<'.(col+matchlen+3).'v.'
                \ . '\|'
                \ . '\%'.(lnum+1).'l\%>'.max([col-4,1]) .'v\%<'.(col+matchlen+3).'v.'
        let ring = matchadd('RedOnRed', ring_pat, 101)
        redraw
        exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
        call matchdelete(ring)
        redraw
    endfunction

    " OR ELSE briefly hide everything except the match...
    function! HLNext (blinktime)
        highlight BlackOnBlack ctermfg=black ctermbg=black
        let [bufnum, lnum, col, off] = getpos('.')
        let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
        let hide_pat = '\%<'.lnum.'l.'
                \ . '\|'
                \ . '\%'.lnum.'l\%<'.col.'v.'
                \ . '\|'
                \ . '\%'.lnum.'l\%>'.(col+matchlen-1).'v.'
                \ . '\|'
                \ . '\%>'.lnum.'l.'
        let ring = matchadd('BlackOnBlack', hide_pat, 101)
        redraw
        exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
        call matchdelete(ring)
        redraw
    endfunction

    " OR ELSE just highlight the match in red...
    function! HLNext (blinktime)
        let [bufnum, lnum, col, off] = getpos('.')
        let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
        let target_pat = '\c\%#\%('.@/.'\)'
        let ring = matchadd('WhiteOnRed', target_pat, 101)
        redraw
        exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
        call matchdelete(ring)
        redraw
    endfunction


"====[ Make tabs, trailing whitespace, and non-breaking spaces visible ]======

    exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
    set list


"====[ Swap : and ; to make colon commands easier to type ]======

    nnoremap  ;  :
    nnoremap  :  ;


"====[ Swap v and CTRL-V, because Block mode is more useful that Visual mode "]======

    nnoremap    v   <C-V>
    nnoremap <C-V>     v

    vnoremap    v   <C-V>
    vnoremap <C-V>     v


"====[ Always turn on syntax highlighting for diffs ]=========================

    " EITHER select by the file-suffix directly...
    augroup PatchDiffHighlight
        autocmd!
        autocmd BufEnter  *.patch,*.rej,*.diff   syntax enable
    augroup END

    " OR ELSE use the filetype mechanism to select automatically...
    filetype on
    augroup PatchDiffHighlight
        autocmd!
        autocmd FileType  diff   syntax enable
    augroup END


"====[ Open any file with a pre-existing swapfile in readonly mode "]=========

    augroup NoSimultaneousEdits
        autocmd!
        autocmd SwapExists * let v:swapchoice = 'o'
        autocmd SwapExists * echomsg ErrorMsg
        autocmd SwapExists * echo 'Duplicate edit session (readonly)'
        autocmd SwapExists * echohl None
        autocmd SwapExists * sleep 2
    augroup END

    " Also consider the autoswap_mac.vim plugin (but beware its limitations)


"====[ Mappings to activate spell-checking alternatives ]================

    nmap  ;s     :set invspell spelllang=en<CR>
    nmap  ;ss    :set    spell spelllang=en-basic<CR>

    " To create the en-basic (or any other new) spelling list:
    "
    "     :mkspell  ~/.vim/spell/en-basic  basic_english_words.txt
    "
    " See :help mkspell


"====[ Make CTRL-K list diagraphs before each digraph entry ]===============

    inoremap <expr> <C-K> ShowDigraphs()

    function! ShowDigraphs ()
        digraphs
        call getchar()
        return "\<C-K>"
    endfunction

    " But also consider the hudigraphs.vim and betterdigraphs.vim plugins,
    " which offer smarter and less intrusive alternatives

