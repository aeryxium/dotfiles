" $XDG_CONFIG_HOME/nvim/init.vim
"
" Neovim config file

" -- Plugins {{{
" Download plugged if it doesn't exist already
if empty(glob('$XDG_DATA_HOME/nvim/site/autoload/plug.vim'))
    silent !curl -fLo $XDG_DATA_HOME/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugin list
call plug#begin('$XDG_DATA_HOME/nvim/site/plugged')
	Plug 'arcticicestudio/nord-vim'
	Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
	Plug 'itchyny/lightline.vim'
	Plug 'junegunn/fzf'
	Plug 'junegunn/fzf.vim'
	Plug 'junegunn/vim-easy-align'
	Plug 'mzlogin/vim-markdown-toc'
	Plug 'preservim/nerdtree'
	Plug 'semanser/vim-outdated-plugins'
	Plug 'vimwiki/vimwiki'
	Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
call plug#end()

" Plugin settings
let g:nord_uniform_status_lines = 1
let g:lightline = {
	\ 'colorscheme': 'nord',
	\ 'active': {
	\     'right': [ [ 'lineinfo'], ['percent'], ['filetype'] ] },
	\ 'component': {
	\     'filename': '%F'}
	\ }
let g:livepreview_previewer = 'zathura'
let g:livepreview_cursorhold_recompile = 0
let g:vimwiki_list = [ {'path':'~/notebook/content', 'syntax': 'markdown', 'ext': '.md', 'links_space_char': '-'} ]
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
let g:vimwiki_markdown_link_ext = 0
let g:markdown_folding = 1
" -- }}}

" -- Formatting {{{
" Set indenting
filetype plugin indent on

" Set syntax highlighting
syntax enable
syntax on

" Set autocompletion
set wildmode=longest,list,full

" Disable automatic commenting on newline
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Set general tabs and spacing
set shiftwidth=8
set tabstop=8
set softtabstop=8
set noexpandtab

" Set filetype-dependent tabs and spacing
autocmd FileType html setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType vimwiki setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType md setlocal shiftwidth=4 tabstop=4 softtabstop=4
" -- }}}

" -- User Interface {{{
" General UI options
set cursorline
set laststatus=2
set modeline
set modelines=1
set number relativenumber
set showcmd
set showmatch
set splitbelow splitright
set linebreak
set spelllang=en_ca,fr
autocmd FileType markdown setlocal spell
autocmd FileType gitcommit setlocal spell

" Colors and highlighting
colorscheme nord
set background=light
hi LineNr       ctermfg=blue
hi Visual       cterm=inverse
hi CursorLineNr cterm=inverse ctermfg=blue

" Highlight todo and fixme
augroup HiglightTODO
    autocmd!
    autocmd WinEnter,VimEnter * :silent! call matchadd('Todo', 'TODO', -1)
augroup END

" ColorColumn for PKGBUILDS
map <F2> :set cc=0<CR>
map <F3> :set cc=80,100 \| match ErrorMsg '\%>119v.\+'<CR>
map <F4> :set cc=40,45,80<CR>

" Fix esc key delays
set timeoutlen=1000 ttimeoutlen=0

" Show tabs vs spaces, and highlight (possibly) unwanted whitespace
set list listchars=nbsp:¬,tab:»·,trail:·,extends:>
hi ExtraWhitespace ctermbg=red guifg=red
match ExtraWhitespace /\s\+$\| \+\ze\t \| [^\t]\zs\t\+/
autocmd colorscheme * hi ExtraWhitespace ctermbg=red guifg=red

" Set undo
set undofile

" Remove all previous autocmds and set terminal options
augroup TerminalStuff
	autocmd!
	autocmd TermOpen * setlocal nonumber norelativenumber
	autocmd TermOpen term://* startinsert
augroup END
" -- }}}

" -- Folding ----------------- {{{
" Settings
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=syntax
set fillchars=fold:\ " remove trailing characters
let g:sh_fold_enabled=5
let g:is_bash=1
nnoremap <space> za

" Set look of folds
function! MyFoldText()
    " Clean up folded text
    let line = getline(v:foldstart)

	" Set width of fold text
    let nucolwidth = &fdc + &number * &numberwidth
	" Full screen width fold text
    " let windowwidth = winwidth(0) - nucolwidth - 3
	" 80-column fold text
	let windowwidth = 80 - nucolwidth
    let foldedlinecount = v:foldend - v:foldstart

    " Expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    " Remove open curly braces or `() {`
    let line = strpart(line, 0, strlen(line) - 4)

    let line = strpart(line, 0, windowwidth - 7 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - 5
    return line . ' ' . repeat("-",fillcharcount) . ' '
		\ . foldedlinecount . " lines"
endfunction
set foldtext=MyFoldText()
" -- }}}

" -- Keymaps {{{
" Fix home/end
if $TERM =~ '^screen-256color'
    map <Esc>OH <Home>
    map! <Esc>OH <Home>
    map <Esc>OF <End>
    map! <Esc>OF <End>
endif
" -- }}}

" -- diff {{{
" Toggle diffing all open windows
function ToggleDiff()
	if &diff
		diffoff!
	else
		windo diffthis
	endif
endfunction

" Open real version of current file
function OpenDiff()
	let dotfile = expand('%:p')
	let realfile = "~" . dotfile[23:]
	execute 'vs' realfile
	call ToggleDiff()
endfunction
map <leader>cd :call OpenDiff()<return>

function NextDiff()
	wincmd h
	only
	n
	call OpenDiff()
endfunction
map <leader>cn :call NextDiff()<return>

" -- }}}

" vim:foldmethod=marker:foldlevel=0
