-- ~/.config/nvim/init.lua

-- Ensure packer is on the runtimepath
vim.cmd([[packadd packer.nvim]])

-- Packer configuration
return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  
  -- 🔽 Add your plugins below 🔽
  
  -- Example: Colorscheme
  use { 'catppuccin/nvim', as = 'catppuccin' } 
  -- Example: Telescope (fuzzy finder)
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- Add BEFORE plugin setup


  use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function()
          require('nvim-treesitter').setup {
              -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
              install_dir = vim.fn.stdpath('data') .. '/site'
          }
          require('nvim-treesitter').install {'go', 'rust', 'javascript', 'zig','c','python','javascript','typescript' }
      end,
  }
  use({'theprimeagen/harpoon'})
  use({'tpope/vim-fugitive'})

  use {
      "neovim/nvim-lspconfig"
  }

  use "williamboman/mason.nvim"
  use "williamboman/mason-lspconfig.nvim"
  use "stevearc/conform.nvim"
  use "j-hui/fidget.nvim"

  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-cmdline"
  use "L3MON4D3/LuaSnip"
  use "saadparwaiz1/cmp_luasnip"



end)
