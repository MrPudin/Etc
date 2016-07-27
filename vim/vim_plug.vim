"
" ~/etc/vim/vim_plug.vim
" Usr Config - Vim Plugin
" 
" Made by Zhu Zhan Yan
" Copyright (c) 2016. All Rights Reserved.
"

"Plug
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'scrooloose/syntastic'
Plugin 'Shougo/neocomplete.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'vim-airline/vim-airline'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-fugitive'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'edkolev/tmuxline.vim'
Plugin 'Shougo/vimproc.vim'
Plugin 'ervandew/supertab'
Plugin 'tclem/vim-arduino'
Plugin 'Shougo/context_filetype.vim'
Plugin 'Shougo/neoinclude.vim'
Plugin 'Shougo/neco-syntax'
Plugin 'Shougo/neopairs.vim'
call vundle#end()

let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline_detect_crypt=1
let g:airline_detect_spell=1
let g:airline_powerline_fonts=1
let g:airline_powerline_font=1
let g:airline#extensions#branch#enabled=1
let g:airline#extensions#syntastic#enabled=1
let g:airline#extensions#ctrlp#color_template='visual'
let g:airline#extensions#ctrlp#dshow_adjacent_modes=1
let g:airline#extensions#tabline#enabled=1

set statusline+=%#warning_msg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=1
let g:syntastic_check_on_open=1
let g:syntastic_check_on_wq=0
let g:syntastic_sort_aggregated_errors=1
let g:syntastic_auto_jump=3
nmap <leader>pss :SyntasticCheck<cr>
nmap <leader>psr :SyntasticReset<cr>
nmap <leader>psl :Errors<cr>

colorscheme solarized

let g:neocomplete#enable_at_startup=1
let g:neocomplete#max_list=100
let g:neocomplete#max_keyword_width=1000
let g:neocomplete#auto_completetion_start_length=2
let g:neocomplete#min_keyword_length=2
let g:neocomplete#enable_ignore_case=1
let g:neocompleteenable_smart_case=1
let g:neocompleteuse_vimproc=1
let g:neocomplete#enable_auto_delimiter=1
nmap <leader>pnn :NeoCompleteLock<cr>
nmap <leader>pnt :NeoCompleteToggle<cr>
nmap <leader>pnc :NeoCompleteBufferMakeCache<bar>NeoCompleteDictionaryMakeCache<cr>

let g:SuperTabDefaultCompletionType='<c-n>'

nmap <leader>ptt :NERDTreeToggle<cr>
nmap <leader>ptb :Bookmark
nmap <leader>pto :OpenBookmark
nmap <leader>ptr :ClearBook
let g:NERDTreeHijackNetrw=1

let g:ctrlp_switch_buffer='Evht'
let g:ctrlp_clear_cache_on_exit=0
let g:ctrlp_prompt_mappings = {
\ 'PrtBS()':              ['<bs>', '<c-]>'],
\ 'PrtDelete()':          ['<del>'],
\ 'PrtDeleteWord()':      ['<c-w>'],
\ 'PrtClear()':           ['<c-u>'],
\ 'PrtSelectMove("j")':   ['<c-j>'],
\ 'PrtSelectMove("k")':   ['<c-k>'],
\ 'PrtSelectMove("t")':   ['<Home>', '<kHome>'],
\ 'PrtSelectMove("b")':   ['<End>', '<kEnd>'],
\ 'PrtSelectMove("u")':   ['<PageUp>', '<kPageUp>'],
\ 'PrtSelectMove("d")':   ['<PageDown>', '<kPageDown>'],
\ 'PrtHistory(-1)':       ['<down>'],
\ 'PrtHistory(1)':        ['<up>'],
\ 'AcceptSelection("e")': ['<cr>', '<2-LeftMouse>'],
\ 'AcceptSelection("h")': ['<c-x>', '<c-cr>', '<c-s>'],
\ 'AcceptSelection("t")': ['<c-t>'],
\ 'AcceptSelection("v")': ['<c-v>', '<RightMouse>'],
\ 'ToggleFocus()':        ['<s-tab>'],
\ 'ToggleRegex()':        ['<c-r>'],
\ 'ToggleByFname()':      ['<c-d>'],
\ 'ToggleType(1)':        ['<c-f>'],
\ 'ToggleType(-1)':       ['<c-b>'],
\ 'PrtExpandDir()':       ['<tab>'],
\ 'PrtInsert("c")':       ['<MiddleMouse>', '<insert>'],
\ 'PrtInsert()':          ['<c-\>'],
\ 'PrtCurStart()':        ['<c-a>'],
\ 'PrtCurEnd()':          ['<c-e>'],
\ 'PrtCurLeft()':         ['<c-h>', '<left>', '<c-^>'],
\ 'PrtCurRight()':        ['<c-l>', '<right>'],
\ 'PrtClearCache()':      ['<F5>'],
\ 'PrtDeleteEnt()':       ['<F7>'],
\ 'CreateNewFile()':      ['<c-p>'],
\ 'MarkToOpen()':         ['<c-m>'],
\ 'OpenMulti()':          ['<c-o>'],
\ 'PrtExit()':            ['<esc>', '<c-c>', '<c-g>'],
\ }

let g:UltiSnipUsePythonVersion=2
let g:UltiSnipsEnableSnipMate=1
let g:UltiSnipsExpandTrigger="<c-x>"
