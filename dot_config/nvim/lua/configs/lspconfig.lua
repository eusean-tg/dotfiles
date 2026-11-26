require("nvchad.configs.lspconfig").defaults()

-- read :h vim.lsp.config for changing options of lsp servers

-- Must precede vim.lsp.enable below. nvim-lspconfig loads on NvChad's
-- "User FilePost" event, which fires after the buffer is already open, so
-- vim.lsp.enable can attach a client synchronously using whatever config is
-- registered at that instant. Registering settings afterwards means the first
-- Go file of a session silently starts a gopls with none of them applied.
vim.lsp.config("gopls", {
  settings = {
    gopls = {
      -- staticcheck stays off here on purpose: golangci-lint bundles it (v2
      -- enables it by default), so turning it on too reports every finding
      -- twice -- once from gopls, once from nvim-lint.
      staticcheck = false,

      -- Cheap analyses gopls runs as you type, chosen to not overlap with
      -- golangci-lint's default set (errcheck, govet, ineffassign, unused).
      analyses = {
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },

      completeUnimported = true,
      usePlaceholders = true,
    },
  },
})

vim.lsp.config("jsonls", {
  settings = {
    json = {
      -- SchemaStore.nvim vendors the schemastore.org catalog as a Lua table.
      -- jsonls itself bundles schemas for a handful of VS Code files only, so
      -- without the catalog a package.json, tsconfig.json or .eslintrc.json
      -- resolves to no schema at all: no key completion, nothing validated.
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
})

vim.lsp.config("vtsls", {
  settings = {
    typescript = {
      tsserver = {
        -- vtsls caps tsserver's heap at 3 GB. kiyotaka-frontend needs more:
        -- tsserver aborts at the cap and vtsls restarts it in a loop, so no
        -- diagnostics or navigation ever arrive. 8 GB matches the heap that
        -- project's own typecheck script sets. V8 takes only what it uses,
        -- so smaller projects are unaffected.
        maxTsServerMemory = 8192,
      },
    },
  },
})

vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      -- Use SchemaStore.nvim's catalog instead of yamlls fetching schemastore.org itself.
      schemaStore = { enable = false, url = "" },
      schemas = require("schemastore").yaml.schemas(),
    },
  },
})

local servers = {
  "html",
  "cssls",
  "gopls",
  "jsonls",
  "vtsls",
  "terraformls",
  "terragrunt_ls",
  "helm_ls",
  "yamlls",
  "bashls",
}
vim.lsp.enable(servers)
