" Enable line numbering
set number
" Enable syntax highlighting
set modeline
" Show a tab as this many spaces
set tabstop=2
" How many spaces when autoindenting
set shiftwidth=2
" Dont expand tabs to spaces
set noexpandtab
" Enable auto indent
set autoindent
" Enable copy/paste into/outof vim
vnoremap <C-c> "*y :let @+=@*<CR>
map <C-p> "+P
" Always show status line
set laststatus=2
" Set status line to contain full path to current file
set statusline+=%F

" Set syntax highlighting based on file extension
au BufNewFile,BufRead,BufReadPost *.conf set syntax=dosini
