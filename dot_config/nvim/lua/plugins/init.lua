return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-live-grep-args.nvim", version = "^1.0.0" },
    },
    -- NvChad's extensions_list is never read, so extensions load here.
    config = function(_, opts)
      local telescope = require "telescope"
      telescope.setup(opts)
      telescope.load_extension "live_grep_args"
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { "b0o/SchemaStore.nvim" },
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "rmagatti/auto-session",
    lazy = false,
    opts = {
      suppressed_dirs = { "~/", "~/Downloads", "~/Desktop", "/" },
    },
  },

  {
    "mfussenegger/nvim-lint",
    event = { "User FilePost", "BufWritePost" },
    config = function()
      require "configs.lint"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "query",
        "bash",
        "regex",
        "diff",
        "json",
        "yaml",
        "toml",
        "ini",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "python",
        "go",
        "gomod",
        "gosum",
        "gowork",
        "rust",
        "c",
        "markdown",
        "markdown_inline",
        "dockerfile",
        "gitcommit",
        "gitignore",
        "sql",
      })
      opts.ensure_installed = vim.fn.uniq(vim.fn.sort(opts.ensure_installed))
    end,
    config = function(_, opts)
      local treesitter = require "nvim-treesitter"
      treesitter.setup(opts)
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("UserTreesitterIndent", { clear = true }),
        callback = function()
          local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
          if lang then
            local ok, loaded = pcall(vim.treesitter.language.add, lang)
            if ok and loaded then
              vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
          end
        end,
      })
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      opts.current_line_blame = true

      opts.current_line_blame_opts = vim.tbl_deep_extend("force", opts.current_line_blame_opts or {}, {
        delay = 500,
      })

      opts.current_line_blame_formatter = " <author>, <author_time:%R> "
    end,
  },

  {
    "lewis6991/satellite.nvim",
    lazy = false,
    opts = {
      excluded_filetypes = { "nvdash", "nvcheatsheet", "NvimTree", "TelescopePrompt", "lazy", "mason" },

      winblend = 30,

      handlers = {
        gitsigns = { enable = true },
        diagnostic = { enable = true },
        search = { enable = true },

        cursor = { enable = false },
        marks = { enable = false },
      },
    },
  },
}
