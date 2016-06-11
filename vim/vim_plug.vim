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
Plugin 'SirVir/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'edkolev/tmuxline.vim'
Plugin 'Shougo/vimproc.vim'
Plugin 'neitanod/vim-clevertab'
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
nmap <leader>psl :Errors<cr>

colorscheme solarized

let g:neocomplete#enable_at_startip=1
let g:neocomplete#max_list=100
let g:neocomplete#max_keyword_width=1000
let g:neocomplete#auto_completetion_start_length=2
let g:neocomplete#min_keyword_length=2
let g:neocomplete#enable_ignore_case=1
