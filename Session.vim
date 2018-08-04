let SessionLoad = 1
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd /Volumes/Swap/drive/trx/doc/code/etcetera
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +11 deploy/data/tmux.conf
badd +7 core.etc
badd +257 deploy/data/init.vim
badd +1 deploy/data/zshrc
badd +110 src/etc.m4
badd +73 docs/spec.txt
badd +15 makefile
badd +19 src/etc_util.m4
badd +25 src/makefile
badd +1 deploy/data/i3status.conf
badd +3 src/test.m4
badd +60 src/etc_make.m4
badd +38 src/etc_pkg.m4
badd +15 src/pkg.csv
badd +1 src/etc_pkg.
badd +20 src/etc_pkg.csv
badd +17 man://divert(4)
badd +6 deploy/core.etc
badd +9 deploy/etc_pkg.csv
badd +1 out
badd +1 src/file_Test.m4
badd +1 test
badd +1 ~/Google\ Drive/trx/doc/code/etcetera/makefile
badd +6 src/etcetera.sh
badd +11 deploy/data/i3.conf
badd +1 deploy/deployment.etc
badd +1 README.md
badd +259 deploy/dotfiles/init.vim
badd +28 deploy/dotfiles/zshrc
argglobal
silent! argdel *
edit deploy/dotfiles/zshrc
set splitbelow splitright
set nosplitright
wincmd t
set winminheight=1 winminwidth=1 winheight=1 winwidth=1
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 1 - ((0 * winheight(0) + 34) / 69)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
tabedit deploy/deployment.etc
set splitbelow splitright
set nosplitright
wincmd t
set winminheight=1 winminwidth=1 winheight=1 winwidth=1
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 166 - ((67 * winheight(0) + 34) / 69)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
166
normal! 0
tabnext 1
if exists('s:wipebuf') && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 winminheight=1 winminwidth=1 shortmess=filnxtToOc
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
let g:this_session = v:this_session
let g:this_obsession = v:this_session
let g:this_obsession_status = 2
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
