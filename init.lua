package.path = package.path .. ";./?.lua"

vim.opt.number = true

local Plug = vim.fn['plug#']

vim.call('plug#begin')
vim.o.exrc = true
vim.opt.mouse = ""

Plug('nvim-lua/plenary.nvim', {['tag'] = 'v0.1.4'})
Plug('neovim/nvim-lspconfig', {['tag'] = 'v2.3.0'})
Plug('nvim-telescope/telescope.nvim', {['branch'] = '0.1.x'})
Plug('j-hui/fidget.nvim', {['tag'] = 'v1.6.1'})
Plug('lewis6991/gitsigns.nvim', {['tag'] = 'v1.0.2'})
Plug('navarasu/onedark.nvim',
     {['commit'] = '0e5512d1bebd1f08954710086f87a5caa173a924'})
Plug('hrsh7th/cmp-nvim-lsp',
     {['commit'] = '99290b3ec1322070bcfb9e846450a46f6efa50f0'})
Plug('hrsh7th/cmp-buffer',
     {['commit'] = '3022dbc9166796b644a841a02de8dd1cc1d311fa'})
Plug('hrsh7th/nvim-cmp', {['tag'] = 'v0.0.2'})

vim.call('plug#end')
vim.cmd('silent! colorscheme onedark')

require('telescope').setup({
    defaults = {
        file_ignore_patterns = {"^%.git/"},
        vimgrep_arguments = {
            "rg", "--color=never", "--no-heading", "--with-filename",
            "--line-number", "--column", "--smart-case", "--hidden"
        }
    },
    pickers = {find_files = {hidden = true}}
})
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files,
               {desc = 'Telescope find files'})
vim.keymap.set('n', '<leader>fg', builtin.live_grep,
               {desc = 'Telescope live grep'})

require("fidget").setup {
    notification = {window = {align = "top", winblend = 0}}
}

vim.keymap.del('n', 'gri')
vim.keymap.del('n', 'grr')
vim.keymap.del('n', 'gra')
vim.keymap.del('n', 'grn')
vim.keymap.del('n', 'gO')
vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition,
               {desc = 'Go to definition'})
vim.keymap.set('n', '<leader>fr', vim.lsp.buf.references,
               {desc = 'Find references'})
vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation,
               {desc = 'Go to implementation'})
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {desc = 'Rename'})
vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover, {desc = 'Hover'})
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action,
               {desc = 'Code action'})
vim.keymap.set("n", "<leader>bd", vim.diagnostic.setloclist,
               {desc = 'Buffer diagnostic'})
vim.keymap.set("n", "<leader>wd", function()
    vim.diagnostic.setqflist({severity = {min = vim.diagnostic.severity.WARN}})
end, {desc = 'Workspace diagnostic'})

vim.lsp.config('clangd', {
    cmd = {
        "clangd", "--background-index", "--clang-tidy",
        "--header-insertion=iwyu", "--completion-style=detailed",
        "--function-arg-placeholders", "--fallback-style=llvm"
    },
    filetypes = {'c', 'cpp'},
    root_markers = {'compile_commands.json'},
    capabilities = {
        textDocument = {
            completion = {completionItem = {snippetSupport = false}}
        }
    }
})
vim.lsp.enable('clangd')

local cmp = require('cmp')

cmp.setup({
    sources = {{name = 'nvim_lsp'}, {name = 'buffer'}},
    snippet = {expand = function(args) vim.snippet.expand(args.body) end},
    mapping = cmp.mapping.preset.insert({
        ['<CR>'] = cmp.mapping.confirm({select = true})
    })
})

vim.api.nvim_create_autocmd('TextYankPost', {
    pattern = '*',
    group = vim.api.nvim_create_augroup('highlight_yank', {clear = true}),
    desc = 'Highlight yanked block',
    callback = function() vim.highlight.on_yank({timeout = 100}) end
})

require('gitsigns').setup()
