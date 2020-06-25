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
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" We only need ALE when working with javascript and php files.
Plug 'dense-analysis/ale', { 'for': ['javascript', 'php'] }

" NERDTree and vim-unimpaired each take > 5 ms to load, so defer them.
Plug 'preservim/nerdtree', { 'on': [] }
Plug 'tpope/vim-unimpaired', { 'on': [] }

call plug#end()

" Load NERDTree and vim-unimpaired after vim finishes starting.
autocmd VimEnter * call plug#load('nerdtree', 'vim-unimpaired')

" Use the Tomorow Night theme. Fail silently if the base16-vim plugin hasn't
" been installed yet.
silent! colorscheme base16-tomorrow-night

" vim-airline already shows the current mode, so there's no need to show it
" again at the bottom of the editor.
set noshowmode

" Let me use the mouse like a baby.
set mouse=a

" Set indentation settings. These are the defaults that vim-sleuth will
" usually override.
set noexpandtab
set shiftwidth=4
set tabstop=4

" Set a text width, but don't wrap long lines.
set nowrap
set textwidth=80

" Highlight the current line.
set cursorline

" Show a line next to the 80th and 100th columns.
set colorcolumn=+1,+21

" Always show a line and column before and after the cursor.
" set scrolloff=1
" set sidescrolloff=1

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

" Map a few useful commands for querying the LSP.
nmap <silent> <M-]> :ALEGoToDefinition<CR>
nmap <silent> <C-H> :ALEHover<CR>

" Map a few useful commands for moving around the project.
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
