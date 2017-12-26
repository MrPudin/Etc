"
" ~/etc/nvim/init.vim
" NeoVim Configuration
" 
" Made by Zhu Zhan Yan
" Copyright (c) 2017.
" 

"Editing Settings
set autoread
set ruler
set number
set smartcase
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set noshowmode
set showtabline=2
set wildmode=longest,list,full
set wildmenu
set laststatus=2
set completeopt=longest,menu,preview
set ignorecase

"File Settings
set encoding=utf8
set path+=/usr/local/include/,/usr/local/include/c++/7.1.0/,/usr/include/
filetype plugin on
filetype plugin indent on
autocmd Filetype scheme set tabstop=2
autocmd Filetype make set noexpandtab

"Display Settings
set hlsearch
set background=dark
colorscheme desert

"Keyboard Bindings
let g:mapleader = ","
nmap <leader>H H
nmap <leader>L L
nmap <leader>M M
nmap H <c-o>
nmap L <c-i>
nmap <leader>e :e
nmap <leader>l :lopen<cr>
nmap <leader>n :lnext<cr>
nmap <leader>N :lNext<cr>
nmap <leader>a :args<cr>
nmap <leader>aa :argadd %<cr>
nmap <leader>aq :argdelete %<cr>
nmap <leader>an :next<cr>
nmap <leader>aN :Next<cr>
nmap <leader>a, :rewind<cr>
nmap <leader>a. :last<cr>
nmap <leader>a: :argdo
nmap <leader>b :ls<cr>
nmap <leader>t :tabs<cr>
nmap <leader>tt :tabnew<cr>
nmap <leader>tq :tabclose<cr>
nmap <leader>tn :tabnext<cr>
nmap <leader>tN :tabNext<cr>
nmap <leader>t, :tabrewind<cr>
nmap <leader>t. :tablast<cr>
nmap <leader>t> :tabmove -1<cr>
nmap <leader>t< :tabmove +1<cr>
nmap <leader>s :setl spell<cr>
nmap <leader>sn ]s
nmap <leader>sN [s
nmap <leader>ss z=
nmap <leader>/n :noh<cr>
nmap <leader>/i :set ignorecase!<cr>
nmap <leader>hl :setl background=light<cr>
nmap <leader>hd :setl background=dark<cr>
nmap <leader>\ :set colorcolumn=80<cr>

"Plugin
call plug#begin('~/.local/share/nvim/plugged')
Plug 'Shougo/denite.nvim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
Plug 'Shougo/neoinclude.vim'
Plug 'artur-shaik/vim-javacomplete2'
Plug 'landaire/deoplete-swift'
Plug 'zchee/deoplete-clang'
Plug 'neoclide/denite-git'
Plug 'chemzqm/denite-extra'
Plug 'clojure-vim/async-clj-omni'
Plug 'carlitux/deoplete-ternjs'
Plug 'fszymanski/deoplete-abook'
Plug 'Shougo/neco-syntax'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'sebastianmarkow/deoplete-rust'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'neomake/neomake'
Plug 'mileszs/ack.vim'
Plug 'chemzqm/unite-location'
Plug 'tmux-plugins/tmux-resurrect'
Plug 'tpope/vim-obsession'
Plug 'ervandew/supertab'

Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'

call plug#end()

"Plugin Configuration
"Denite
call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'default_opts',
        \ ['-i', '--vimgrep'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])
call denite#custom#var('file_rec', 'command',
	\ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])

"Deoplete
let g:deopleteA#enable_smart_case=1
let g:deoplete#auto_complete_delay=40
let g:deoplete#sources#clang#libclang_path="/usr/local/Cellar/llvm/4.0.1/lib/libclang.dylib"
let g:deoplete#sources#clang#clang_header="/usr/local/Cellar/llvm/4.0.1/include/clang"

"Neomake
call neomake#configure#automake('w')

"Plugin Bindings
nmap <C-p> :Denite file_rec<cr>
nmap <leader>l :Denite location_list<cr>`
nmap <leader>/ :Denite grep<cr>
nmap <leader>? :Denite outline<cr>
nmap <leader>" :Denite register<cr>
nmap <leader>: :Denite command<cr>
nmap <leader>H :Denite colorscheme<cr>

call denite#custom#map('normal', '<Esc>', '<C-c>',
      \'noremap')
call denite#custom#map('normal', 'i', '<denite:enter_mode:insert>',
      \'noremap')
call denite#custom#map('normal', 'j', '<denite:move_to_next_line>',
      \'noremap')
call denite#custom#map('normal', 'k', '<denite:move_to_previous_line>',
      \'noremap')
call denite#custom#map('normal', 'J', '<denite:jump_to_next_source>',
      \'noremap')
call denite#custom#map('normal', 'K', '<denite:jump_tp_previous_source>',
      \'noremap')
call denite#custom#map('normal', 'a', '<denite:append>',
      \'noremap')
call denite#custom#map('normal', 'A', '<denite:append_to_line>',
      \'noremap')
call denite#custom#map('normal', 'e', '<denite:move_caret_to_end_of_word>',
      \'noremap')
call denite#custom#map('normal', 'w', '<denite:move_caret_to_next_word>',
      \'noremap')
call denite#custom#map('normal', 'cc', '<denite:change_line>',
      \'noremap')
call denite#custom#map('normal', 'cd', '<denite:change_path>',
      \'noremap')
call denite#custom#map('normal', ',', '<denite:choose_action>',
      \'noremap')
call denite#custom#map('insert', '<Esc>', '<denite:enter_mode:normal>',
      \'noremap')
call denite#custom#map('insert', '<C-j>', '<denite:move_to_next_line>',
        \'noremap')
call denite#custom#map('insert','<C-k>', '<denite:move_to_previous_line>',
      \ 'noremap')
call denite#custom#map('insert', '<C-v>', '<denite:do_action:vsplit>',
      \'noremap')
call denite#custom#map('insert', '<C-x>', '<denite:do_action:split>',
      \'noremap')
call denite#custom#map('insert', '<C-t>', '<denite:do_action:tabopen>',
      \'noremap')

nmap <leader>cc :call deoplete#toggle()<cr>

let g:SuperTabDefaultCompletionType="context"
let g:SuperTabContextDefaultCompletionType="<C-n>"
let g:UltiSnipsExpandTrigger="<C-x>"
let g:SuperTabLongestEnhanced=1
let g:SuperTabCrMapping=1

"Plugin Display Setting
colorscheme solarized

"Autocommands
autocmd InsertLeave * pclose
autocmd InsertEnter * call deoplete#enable()
autocmd FileType crontab setl backupcopy=yes
autocmd FileType java setlocal omnifunc=javacomplete#Complete
