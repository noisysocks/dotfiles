" We don't care about vi compatibility
set nocompatible

" Enable filetype plugins
filetype plugin on

" Enable syntax highlighting
syntax on

" Use the badass Dracula theme
let g:dracula_colorterm = 0
let g:dracula_italic = 0
colorscheme dracula

" Let me click on things as if it's my first day using vim
set mouse=a

" Indentation settings
" Note that vim-sleuth will magically set some of these
set noexpandtab
set tabstop=4
set shiftwidth=4
set autoindent
set smartindent

" Ignore case of search term when it's all lowercase
set ignorecase
set smartcase

" Highlight the current line
set cursorline

" Highlight the current search term
set hlsearch

" Highlight column 120
set colorcolumn=120

" Show line numbers
set number

" Don't wrap long lines
set nowrap

" Keep old buffers open in the background
set hidden

" Disable .swp files - we have git for that
set updatecount=0

" Make \\ go to the previous buffer
nnoremap <silent> <leader><leader> :b#<cr>

" Make \t toggle NERDTree
nnoremap <silent> <leader>t :NERDTreeToggle<cr>

" Make \f, \b, and \m toggle CtrlP's various modes
nnoremap <silent> <leader>f :CtrlP<cr>
nnoremap <silent> <leader>b :CtrlPBuffer<cr>
nnoremap <silent> <leader>m :CtrlPMRUFiles<cr>

" Make :Ack use ag instead of ack
if executable('ag')
	let g:ackprg = 'ag --vimgrep'
endif

" Exit vim if we quit a buffer and have only help, quickfix or NERDTree buffers leftover
" Stolen from https://yous.be/2014/11/30/automatically-quit-vim-if-actual-files-are-closed/
function! CheckLeftBuffers()
	if tabpagenr('$') == 1
		let i = 1
		while i <= winnr('$')
			if getbufvar(winbufnr(i), '&buftype') == 'help' ||
				\ getbufvar(winbufnr(i), '&buftype') == 'quickfix' ||
				\ exists('t:NERDTreeBufName') && bufname(winbufnr(i)) == t:NERDTreeBufName
				let i += 1
			else
				break
			endif
		endwhile
		if i == winnr('$') + 1
			qall
		endif
		unlet i
	endif
endfunction
autocmd BufEnter * call CheckLeftBuffers()

" Show JSX highlighting in non .jsx files
let g:jsx_ext_required = 0

" Allow project .vimrc files, but guard against naughty ones
set exrc
set secure
