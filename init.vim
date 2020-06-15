" Detect if vim-plug, our plugin manager of choice, is missing. If it is,
" offer to automatically download it. This usually happens when running vim
" for the first time.
let s:plug_path = stdpath('data') . '/site/autoload/plug.vim'
let s:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
if empty(glob(s:plug_path))
	if input('vim-plug is missing. Download it? (y/n) ') =~? '^y'
		silent execute '!curl -fLo' s:plug_path '--create-dirs' s:plug_url
		echo 'Done! You should probably now run :PlugInstall and restart vim.'
	else
		quitall!
	endif
endif

call plug#begin(stdpath('data') . '/plugged')

" Eagerly load most plugins.
Plug 'chriskempson/base16-vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'noisysocks/vim-airline'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline-themes'

" We only need ALE when working with javascript and php files.
Plug 'dense-analysis/ale', { 'for': ['javascript', 'php'] }

" NERDTree and vim-unimpaired both take > 5 ms to load, so wait for VimEnter.
Plug 'preservim/nerdtree', { 'on': [] }
Plug 'tpope/vim-unimpaired', { 'on': [] }

call plug#end()

" Load NERDTree and vim-unimpaired after startup.
autocmd VimEnter * call plug#load('nerdtree', 'vim-unimpaired')

" Use the Tomorow Night theme. Fail silently if the base16-vim plugin hasn't
" been installed yet.
silent! colorscheme base16-tomorrow-night

" Highlight where text will wrap.
set colorcolumn=+1

" Highlight the current line.
set cursorline

" vim-airline already shows the current mode, so there's no need to show it
" again at the bottom of the editor.
set noshowmode

" Don't wrap long lines.
set nowrap

" Make tabs display a little smaller.
set tabstop=4

" Let me use the mouse like a baby.
set mouse=a

" Ignore case when searching, unless the search query has capitals in it.
set smartcase ignorecase

" Keep buffers open in the background when we go to a different buffer. This
" makes it quick to navigate around using [b / ]b or :bprev / :bnext.
set hidden

" Use ALE for our user completion function. This gives us IntelliSense-like
" autocompletion when we want it by pressing CTRL-X CTRL-U.
set completefunc=ale#completion#OmniFunc

" Make CTRL-L clear any highlighted search terms.
nmap <silent> <C-L> :nohlsearch<CR>

" Map a few useful commands to leader key (\) shortcuts.
nmap <silent> <Leader>b :Buffers<CR>
nmap <silent> <Leader>f :Files<CR>
nmap <silent> <Leader>h :History<CR>
nmap <silent> <Leader>n :NERDTreeToggle<CR>
nmap <silent> <Leader>o :BTags<CR>
nmap <silent> <Leader>t :Tags<CR>

" Make ALE automatically fix errors when the buffer is saved.
let g:ale_fix_on_save = 1

" Tell ALE which linters to use on which filetypes.
let g:ale_fixers = {
\	'javascript': ['eslint'],
\	'php': ['phpcbf'],
\}

" Make Gutentags only build tags from the files that rg indexes. This makes
" ctags not index .git, node_modules, etc.
let g:gutentags_file_list_command = 'rg --files'

" Make Gutentags store the tags file away from the project directory. This
" keeps it from showing up in git.
let g:gutentags_cache_dir = stdpath('cache') . '/tags'
