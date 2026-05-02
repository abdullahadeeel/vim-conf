local parser_install_dir = vim.fn.stdpath("data") .. "/site"

-- 2. Ensure Neovim's runtimepath includes this directory
vim.opt.runtimepath:append(parser_install_dir)
require'nvim-treesitter'.setup({
    -- A list of parser names, or "all"
    ensure_installed = { "html", "css", "c","python", "go", "php", "javascript","typescript","lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = true,

    -- Automatically install missing parsers when entering buffer
    auto_install = true,

    highlight = {
        enable = true,              -- false will disable the whole extension
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true
    },
})
