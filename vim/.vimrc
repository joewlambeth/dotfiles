set number
set rnu
set ai
syntax enable
set hlsearch
set showmatch
set softtabstop=4
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set showtabline=4
set showcmd
set ruler
set listchars=tab:››,eol:¶,space:·,precedes:«,extends:»
set clipboard=unnamed
set splitright
set wrap           
set formatoptions-=t 
set shortmess-=S
set scrolloff=5
set showcmd
set ignorecase
set smartcase

set nocompatible
filetype plugin on

let g:vimwiki_hl_cb_checked=1
let g:vimwiki_hl_headers=1

hi VimwikiCheckBoxDone ctermfg=174 cterm=none
hi VimwikiHeader1 ctermfg=65 cterm=bold
hi VimwikiHeader2 ctermfg=108 cterm=bold
hi VimwikiHeader3 ctermfg=78 cterm=bold

imap <C-F> <ESC>
tmap <ESC> <C-\><C-N>
tmap <C-F> <C-\><C-N>
nmap <C-H> <C-W>h
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-L> <C-W>l
nnoremap <silent> <enter> :noh <enter><enter>
let g:maplocalleader="\<Space>"
let g:mapleader="\<Space>"
nnoremap <Leader>wt :VimwikiMakeDiaryNote<CR>
nnoremap <Leader>wy :VimwikiMakeYesterdayDiaryNote<CR>
nnoremap <Leader>wm :VimwikiMakeTomorrowDiaryNote<CR>
nnoremap <Leader>ws :VWS 
nnoremap <Leader>wf <Plug>VimwikiDiaryNextDay
nnoremap <Leader>wb <Plug>VimwikiDiaryPrevDay
map <silent> gdt :r!now <enter>
map <silent> gd :r!today <enter>

com! T vert bo term

autocmd VimResized * wincmd = 
autocmd BufEnter *.tsv :set list
autocmd BufEnter *.sh :set noexpandtab
autocmd InsertEnter * :set nornu
autocmd InsertLeave * :set rnu
autocmd InsertLeave *.wiki :set nowrap
" autocmd BufNewFile */diary/*.wiki :silent 0r !python ~/scripts/vimwiki-diary.py '%'

