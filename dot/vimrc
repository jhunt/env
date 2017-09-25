"
" ~/.vimrc - Vim Runtime Control file
"
" These are my handy-dandy settings for Vim
"
" author:    James Hunt <james@niftylogic.com>
" created:   2008-06-27
" updated:   almost every day since then
"

"################################################################################
"#### GLOBAL PARAMETERS #########################################################

" UTF-8 is awesome
"set encoding=utf-8
"set fileencodings=utf-8
"setglobal fileencoding=utf-8

" viminfo - remember all the things!
"   '10   remember marks for last 10 files
"   "100       ... last 100 lines (per register)
"   :20        ... last 20 commands
"   %          ... list of buffers
"   n     Where to save viminfo data
"
set viminfo='10,\"100,:20,%,n~/.viminfo

if exists("pathogen#infect")
	execute pathogen#infect()
endif

let g:n7_rainbow=1

" case matters
if exists("+nocompatible")
	set nofileignorecase
endif

" handle looooong lines in YAML files
set maxmempattern=8192

" Tabs are 4 columns wide, and use the TAB character
set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab

" Disable all sorts of bells and visual alerts
set visualbell t_vb=
set novisualbell

" Autoindent, I love you
filetype indent on
set autoindent

" Allow backspace / delete in insert mode
set backspace=start,eol,indent

" Add 'o' formatoption to continue comment characters during F2/F3
set formatoptions=tcqo

" Turn on search term highlighting
set hlsearch

" Print representations of trailing spaces, tabs and end-of-line
highlight SpecialKey ctermfg=DarkGrey
highlight NonText    ctermfg=DarkGrey
set listchars=tab:\\-,trail:.,eol:$
set list
"set nolist number " for demo only!

" Show line numbers in Dark Gray, and use as little space
" as possible on the left margin for displaying them.
set number
set numberwidth=1
highlight LineNr ctermfg=DarkGray

" Turn on syntax higlighting on a dark background.
" Some update must have turned this off, jrh - 2008-11-28
syntax on
set background=dark
" ... and don't forget gvim
if has('gui_running')
	color slate
endif

" Turn on modeline processing, so we can force certain vim
" parameters when we don't match an autocommand.
set modeline

" Turn on marker foldmethod, to make things easier
set foldmethod=marker

" Turn off stupid cindent rules, until I can figure out
" how to customize them to my coding style.
set nocindent

set laststatus=2
set stl=[%n]\ file:%-50F\ %y%r%m\ byte:0x%B%=line:%l:%c/%L\ %p%%

set nowildmenu
set wildmode=longest,list



"################################################################################
"#### MAPPED COMMANDS ###########################################################

""" ###   Custom Vim Environment Header Helpers   ############################
map <F7> :!/bin/sh -c 'clear && grep ^\"\"\" ~/.vimrc \| sed -e s/^...//'<CR>

"""
""" ###   File Creation / Update Header Helpers   ############################
"""
"""   F2 - insert header listing author and creation date.
map <F2> o author:  James Hunt <james@niftylogic.com><Esc>ocreated: <Esc>:read !date +"\%Y-\%m-\%d"<CR>kJ<Esc>
"""   F3 - insert a header line listing an update
map <F3> oupdated: <Esc>:read !date +"\%Y-\%m-\%d"<CR>kJA, jrh: 
"""   F4 - insert blank Pod at the end of the document
map <F4> Go<CR>=head1 NAME<CR><CR>=head1 DESCRIPTION<CR><CR>=head1 METHODS<CR><CR>=head1 AUTHOR<CR><CR>Written by James Hunt <james@niftylogic.com><CR><CR>=cut<Esc>
"""   F9 - insert [ jrh, <date> ] at cursor
map <F9> A[ jrh,<esc>:read !date +"\%Y-\%m-\%d"<CR>kJA ]<Esc>o

inoremap <F6> <Esc>:let @a=system("uuidgen <Bar> tr A-Z a-z")<CR>a<C-R>a<Esc>kJxa
inoremap <F7> <Esc>:let @a=system("pwgen 32 1")<CR>a<C-R>a<Esc>kJxa

"""
"""
""" ###   Easy .vimrc Management   ###########################################
"""

let mapleader=";"

"""   ;v - cpen .vimrc in a new buffer for editing
"map <leader>v :sp ~/.vimrc<CR>

"""   ;u - Reload .vimrc (in current buffer)
"map <leader>u :source ~/.vimrc<CR>

"""
"""
""" ###   Copy/Paste Support   ###############################################
"""

"""   ;cp - Set for COPY mode (turn off non-printing chars)
map <leader>cp :set nonumber<CR>:set nolist<CR>

"""   ;pc - Opposite of ;cp - turns on non-printing chars
map <leader>pc :set number<CR>:set list<CR>

"""   ;l6
map <leader>lw a<C-R>=system("lipsum 1 1")<CR>
map <leader>lt a<C-R>=system("lipsum 4 7")<CR>
map <leader>lp a<C-R>=system("lipsum 20 40")<CR>
map <leader>lP a<C-R>=system("lipsum 40 120")<CR>
map <leader>ll a<C-R>=system("lipsum 4 16")<CR>

"""
"""
""" ###   Whitespace Management   ############################################
"""

"""   ;n - Collapse successive empty (spaces or tabs allowed) lines
map <leader>n GoZ<Esc>:g/^[ <Tab>]*$/.,/[^ <Tab>]/-j<CR>Gdd

"""   ;c - Clear leading spaces and enter insertion mode
map <leader>c :,s/^[ <Tab>]*//g<CR>i

"""
"""
""" ###   Miscellany   #######################################################
"""

"""   ;h - Write current file out in highlighted HTML
map <leader>h :source $VIM/vimcurrent/syntax/2html.vim<CR>:w<CR>:close<CR>

map <leader>t :!vimtest %<CR>
map <leader>m :!upmake local <CR>
map <leader>b :!upmake build <CR>
map <leader>l :!perl -Ilib -c %<CR>

map <leader>= :let _s=@/<Bar>,/^$/-1!column -t<CR>:let @/=_s<CR>

command! -nargs=* -complete=shellcmd R new | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>

"################################################################################
"#### AUTOCOMMANDS ##############################################################

if has("autocmd")
  " Jump to last cursor position, per ~/.viminfo
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

  " Wrap text in git commit message at 72 characters, as I type.
  au BufNewFile,BufRead *.git/COMMIT_EDITMSG    set tw=72 wrap | call setpos('.', [0, 1, 1, 0])

  " Treat *.tt as HTML
  au BufNewFile,BufRead *.tt                    set ft=html et ts=2 sts=2 sw=2

  " HTML/CSS/JS files ought not have tabs
  au BufNewFile,BufRead *.html,*.css,*.js       set et ts=2 sts=2 sw=2

  " Treat *.lsp, *.ll, *.lisp as LISP
  au BufNewFile,BufRead *.lsp,*.ll,*.lisp       set ft=lisp et ts=2 sts=2 sw=2

  " Treat *.tt as HTML
  au BufNewFile,BufRead *.jst                   set ft=atlas

  " Treat *.md as Markdown
  au BufNewFile,BufRead *.md                    set ft=markdown tw=66

  " Treat *.scm as Scheme source code
  au BufNewFile,BufRead *.scm                   set ft=scheme et

  " Treat *.gcov as GNU gcov code coverage reports
  au BufNewFile,BufRead *.gcov                  set ft=gcov

  " Treat *.1 as man page source files
  au BufNewFile,BufRead *.1,*.2,*.3,*.4,*.5,*.6,*.7,*.8,*.9 set ft=nroff

  " Treat *.ya?ml as YAML
  au BufNewFile,BufRead *.yml                   set ft=yaml et ts=2 sts=2 sw=2
  au BufNewFile,BufRead *.yaml                  set ft=yaml et ts=2 sts=2 sw=2

  " Rubyists practice the heresy of spaces-over-tabs
  au BufNewFile,BufRead *.rb                    set et ts=2 sts=2 sw=2

  " Always set cursor position to 0,0 for git commit messages
  au FileType gitcommit call setpos('.', [0, 1, 1, 0])

  "au BufNewFile *.t 0r ~/.vim/templates/test.t
  au BufNewFile *.t set ft=perl

  " Handle Bash-specific syntax for modelines that set ft=bash
  function! BashSyntax()
    if &ft == "bash"
      let b:is_bash=1
      set ft=sh
    endif
  endfunction
  au FileType * call BashSyntax()

endif

"################################################################################
"#### HEX MODE ##################################################################

nnoremap <C-H> :Hexmode<CR>
inoremap <C-H> <Esc>:Hexmode<CR>
vnoremap <C-H> :<C-U>Hexmode<CR>

" ex command for toggling hex mode - define mapping if desired
command! -bar Hexmode call ToggleHex()

" helper function to toggle hex mode
function! ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd -g 1
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction

function! CursorPing()
	set cursorline cursorcolumn
	redraw
	sleep 1250m
	set nocursorline nocursorcolumn
endfunction

map <C-L> :call CursorPing()<CR>
