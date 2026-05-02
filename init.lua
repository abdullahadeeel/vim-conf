require("abdullahadeel")
vim.opt.runtimepath:append(vim.fn.stdpath('data') .. '/site')

-- Disable old vim regex syntax, let treesitter fully take over
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'python', 'go', 'rust', 'javascript', 'typescript', 'zig', 'c' },
    callback = function()
        vim.treesitter.start()
        vim.bo.syntax = ''
    end,
})
vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost" }, {
  pattern = { "*.vue" },
  callback = function()
    vim.schedule(function()
      -- 'zx' forces a fold update, allowing it to "see" the functions inside <script>
      vim.cmd("normal! zx")
    end)
  end,
})

-- Replace your current foldexpr with this built-in Lua version
-- Use the modern expression for better multi-language support (Neovim 0.10+)
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Keep folds open by default so you can choose what to toggle
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- lsp activations configuration
