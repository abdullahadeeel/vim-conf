-- conform
require("conform").setup({
  formatters_by_ft = {}
})

local cmp = require("cmp")
local cmp_lsp = require("cmp_nvim_lsp")

local capabilities = vim.tbl_deep_extend(
  "force",
  {},
  vim.lsp.protocol.make_client_capabilities(),
  cmp_lsp.default_capabilities()
)

require("fidget").setup({})
require("mason").setup()

local lspconfig = require("lspconfig")

require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "rust_analyzer",
    "gopls",
    "vtsls",
    "tailwindcss",
  },
  handlers = {
    function(server_name)
      lspconfig[server_name].setup({
        capabilities = capabilities
      })
    end,

    zls = function()
      lspconfig.zls.setup({
        root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
        settings = {
          zls = {
            enable_inlay_hints = true,
            enable_snippets = true,
            warn_style = true,
          },
        },
      })
      vim.g.zig_fmt_parse_errors = 0
      vim.g.zig_fmt_autosave = 0
    end,

    ["lua_ls"] = function()
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            format = {
              enable = true,
              defaultConfig = {
                indent_style = "space",
                indent_size = "2",
              }
            },
          }
        }
      })
    end,

    ["tailwindcss"] = function()
      lspconfig.tailwindcss.setup({
        capabilities = capabilities,
        filetypes = {
          "html","css","scss",
          "javascript","javascriptreact",
          "typescript","typescriptreact",
          "vue","svelte","heex"
        },
      })
    end,
  }
})

-- cmp
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),
  sources = cmp.config.sources({
    { name = "copilot", group_index = 2 },
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
  }),
})

-- diagnostics UI
vim.diagnostic.config({
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})
