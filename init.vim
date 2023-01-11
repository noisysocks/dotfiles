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
Plug 'github/copilot.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'sheerun/vim-polyglot'
Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" We only need ALE when working with javascript(ish) and php files.
Plug 'dense-analysis/ale', { 'for': [ 'javascript', 'typescript', 'typescriptreact', 'php' ] }

" Defer plugins that take a few ms to load.
" https://www.liooo.dev/en/post/2020-04-05-faster-vim-start-up-time-by-lazy-loading-plugins/
Plug 'preservim/nerdtree', { 'on': [] }
Plug 'tpope/vim-unimpaired', { 'on': [] }

call plug#end()

" Load deferred plugins after vim has finished starting.
autocmd VimEnter * call plug#load('nerdtree', 'vim-unimpaired')

" Use the One Half theme and true colors.
colorscheme onehalfdark " or onehalflight
set termguicolors

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
set scrolloff=1
set sidescrolloff=1

" Ignore case when searching, unless the search query has capitals in it.
set smartcase ignorecase

" Keep buffers open in the background when we go to a different buffer. This
" makes it quick to navigate around using [b / ]b or :bprev / :bnext.
set hidden

" Use ALE for our omnicompletion function. This gives us IntelliSense-like
" autocompletion when we want it by pressing CTRL-X CTRL-O.
set omnifunc=ale#completion#OmniFunc

" Exclude useless files from wildcard matches.
set wildignore+=.git/*,node_modules/*,*/build/*,*/build-module/*

" Use rg instead of grep.
set grepprg=rg\ --vimgrep

" Make CTRL-L clear any highlighted search terms.
nmap <silent> <C-L> :nohlsearch<CR>

" Use option key for querying what's under the cursor.
nmap <silent> <M-g> :grep '\b<cword>\b'<CR>
nmap <silent> <M-]> :ALEGoToDefinition<CR>
nmap <silent> <M-t> :ALEGoToTypeDefinition<CR>
nmap <silent> <M-f> :ALEFindReferences<CR>
nmap <silent> <M-h> :ALEHover<CR>
nmap <silent> <M-d> :ALEDetail<CR>
nmap <silent> <M-r> :ALERename<CR>
nmap <silent> <M-i> :ALEImport<CR>

" Use leader key for moving around the project.
nmap <silent> <Leader>n :NERDTreeFind<CR>
nmap <silent> <Leader>N :NERDTree<CR>
nmap <silent> <Leader>b :Buffers<CR>
nmap <silent> <Leader>f :Files<CR>
nmap <silent> <Leader>h :History<CR>
nmap <silent> <Leader>o :BTags<CR>
nmap <silent> <Leader>t :Tags<CR>
nmap <silent> <Leader>g :Rg<CR>

" Make vim-airline use ASCII characters. (The unicode stuff is weird.)
let g:airline_symbols_ascii = 1

" Truncate long git branch names in vim-airline.
let g:airline#extensions#branch#displayed_head_limit = 20

" Make ALE automatically fix errors when the buffer is saved.
let g:ale_fix_on_save = 1

" Tell ALE which fixers to use on which filetypes. We use our own lambda
" function instead of the built-in phpcbf fixer so as to not pass the
" --stdin-path argument which messes up older phpcbf versions.
let g:ale_fixers = {
\	'javascript': ['eslint'],
\	'typescript': ['eslint'],
\	'typescriptreact': ['eslint'],
\	'php': [
\		{buffer -> { 'command': ale#Escape(ale#fixers#phpcbf#GetExecutable(buffer)) . ' -' }}
\	],
\}

" Make Gutentags only build tags from the files that rg indexes. This makes
" ctags not index .git, node_modules, etc.
let g:gutentags_file_list_command = 'rg --files'

" Make Gutentags store the tags file away from the project directory. This
" keeps it from showing up in git.
let g:gutentags_cache_dir = stdpath('cache') . '/tags'

" Tells Gutentags to start doing its thing straight after opening vim.
let g:gutentags_generate_on_empty_buffer = 1

" Make Gutentags tell ctags that .tsx is a TypeScript file.
let g:gutentags_ctags_extra_args = ['--map-TypeScript=+.tsx']

" Make Copilot use system version of node.
if executable('/opt/homebrew/bin/node')
	let g:copilot_node_command = '/opt/homebrew/bin/node'
endif
