" Set 'nocompatible' mode to prevent unintended behaviour
set nocompatible

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
if has('filetype')
	filetype indent plugin on
endif

" Enable syntax highlighting
if has('syntax')
	syntax on
endif

" Enable hybrid line numbering
set number relativenumber
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
" Always show status line
set laststatus=2
" Set status line to contain full path to current file
set statusline+=%F
" Use visual bell instead of beeping
set visualbell
set t_vb=
" Set colour scheme
color desert

" Set syntax highlighting based on file extension
au BufNewFile,BufRead,BufReadPost *.conf set syntax=dosini
