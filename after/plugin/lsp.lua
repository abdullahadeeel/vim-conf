
-- ============================================================================
-- VISUAL CONFIGURATION - Diagnostic Signs & Styling
-- ============================================================================
local signs = {
  Error = "󰅚 ",
  Warn = "󰀪 ",
  Hint = "󰌶 ",
  Info = " "
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    spacing = 4,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
    padding = 1,
    max_width = 80,
  },
})

-- Hover & Signature Help Styling
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = "rounded",
    padding = 1,
    max_width = 80,
  }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    border = "rounded",
    padding = 1,
    max_width = 80,
  }
)

-- Float Window Colors (adjust to match your colorscheme)
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e1e2e", fg = "#cdd6f4" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1e1e2e", fg = "#89b4fa" })

-- ============================================================================
-- CONFORM
-- ============================================================================
require("conform").setup({
  formatters_by_ft = {}
})

-- ============================================================================
-- CMP SETUP
-- ============================================================================
local cmp = require("cmp")
local cmp_lsp = require("cmp_nvim_lsp")
local capabilities = vim.tbl_deep_extend(
  "force",
  {},
  vim.lsp.protocol.make_client_capabilities(),
  cmp_lsp.default_capabilities()
)

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
  window = {
    completion = cmp.config.window.bordered({
      border = "rounded",
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
    }),
    documentation = cmp.config.window.bordered({
      border = "rounded",
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
    }),
  },
})

-- ============================================================================
-- LSP SETUP WITH PROJECT-BASED ATTACHMENT
-- ============================================================================
require("fidget").setup({})
require("mason").setup()

local lspconfig = require("lspconfig")

-- Project markers for each LSP
local project_markers = {
  lua_ls = { ".luarc.json", ".stylua.toml", "stylua.toml" },
  rust_analyzer = { "Cargo.toml", "rust-project.json" },
  gopls = { "go.mod", "go.work" },
  vtsls = { "package.json", "tsconfig.json", "jsconfig.json" },
  tailwindcss = { "tailwind.config.js", "tailwind.config.ts", "tailwind.config.cjs" },
  zls = { "build.zig", "zls.json" },
}

-- Function to check if we're in a valid project
local function should_attach_lsp(server_name, bufnr)
  local markers = project_markers[server_name]
  if not markers then return true end  -- Always attach if no markers defined
  
  local root_dir = lspconfig.util.root_pattern(unpack(markers))(vim.api.nvim_buf_get_name(bufnr))
  return root_dir ~= nil
end

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
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          if not should_attach_lsp(server_name, bufnr) then
            vim.lsp.stop_client(client.id)
            return
          end
        end,
      })
    end,
    
    zls = function()
      lspconfig.zls.setup({
        capabilities = capabilities,
        root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
        on_attach = function(client, bufnr)
          if not should_attach_lsp("zls", bufnr) then
            vim.lsp.stop_client(client.id)
            return
          end
        end,
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
        on_attach = function(client, bufnr)
          if not should_attach_lsp("lua_ls", bufnr) then
            vim.lsp.stop_client(client.id)
            return
          end
        end,
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
        on_attach = function(client, bufnr)
          if not should_attach_lsp("tailwindcss", bufnr) then
            vim.lsp.stop_client(client.id)
            return
          end
        end,
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
