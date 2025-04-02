vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'

--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)


vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

require('lazy').setup({
  -- for git
  'tpope/vim-fugitive',
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  -- for wrapping
  'tpope/vim-surround',
  -- highlight the word under cursor
  'RRethy/vim-illuminate',
  -- start page with sessions support
  'mhinz/vim-startify',
  -- tables
  'dhruvasagar/vim-table-mode',
  'junegunn/vim-easy-align',
  -- restore last position in file
  'farmergreg/vim-lastplace',
  -- markdown preview
  { "ellisonleao/glow.nvim", config = true, cmd = "Glow" },
  'aklt/plantuml-syntax',
  -- colors
  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    opts = {
      style = 'deep'
    },
  },
  {
    "folke/tokyonight.nvim",
    opts = { style = "night" },
    config = function(_, opts)
      require('tokyonight').setup(opts)
      vim.cmd.colorscheme 'tokyonight'
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
  },
  {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
    lazy = false,
    priority = 1000
  },
  'rebelot/kanagawa.nvim',
  'Mofiqul/dracula.nvim',
  --

  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',  opts = {} },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns
        vim.keymap.set({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
        vim.keymap.set({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
      end,
    },
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = 'onedark',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = {},
        lualine_y = { 'filetype', 'fileformat' },
        lualine_z = { 'encoding' }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      },
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
  },

  {
    'numToStr/Comment.nvim',
    opts = {
      toggler = {
        line = ',c<space>',
        block = ',cb'
      },
      opleader = {
        line = ',c<space>',
        block = ',cb'
      }
    }
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      filesystem = {
        follow_current_file = { enabled = true }
      },
      buffers = {
        follow_current_file = { enabled = true }
      },
      window = {
        mappings = {
          ["/"] = "noop",
          ["f"] = "fuzzy_finder",
          ["F"] = "filter_on_submit",
          ["E"] = "expand_all_nodes",
        }
      },
      close_if_last_window = true
    },
    config = function(_, opts)
      require('neo-tree').setup(opts)
      vim.keymap.set('n', '<leader>e', "<Cmd>Neotree toggle<CR>")
      vim.keymap.set('n', '<leader>b', "<Cmd>Neotree buffers<CR>")
    end,
  },
  {
    'kevinhwang91/nvim-ufo',
    dependencies = {
      'kevinhwang91/promise-async'
    },
    run = ':TSUpdate',
    config = function()
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.o.foldcolumn = '2' -- '0' is not bad
      vim.o.foldlevel = 99   -- need a large value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      require('ufo').setup({
        provider_selector = function()
          return { 'treesitter', 'indent' }
        end,
        open_fold_hl_timeout = 400,
        close_fold_kinds = {},
        close_fold_kinds_for_ft = {},
        enable_get_fold_virt_text = false,
        preview = {
          win_config = {
            border = { '', '─', '', '', '', '─', '', '' },
            winhighlight = 'Normal:Folded',
            winblend = 0
          },
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    lazy = true,
    cmd = "ConformInfo",
    opts = {
      formatters_by_ft = {
        javascript = { 'prettier', stop_after_first = true },
        typescript = { 'prettier', stop_after_first = true },
        json = { 'prettier', stop_after_first = true },
        graphql = { 'prettier', stop_after_first = true },
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports", stop_after_first = false },
        sql = { 'pg_format', stop_after_first = true },
        terraform = { 'terraform_fmt' },
        go = { "goimports", "gofmt" },
        xml = { "xmlstarlet" },
      },
    },
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {}
  },
  {
    "robitx/gp.nvim",
    config = function()
      require("gp").setup({
        -- openai_api_key = { "pass", "show", "openai-first" },
        -- security add-generic-password -a mykola -s openai-first -w $(pass show openai-first)
        openai_api_key = { "security", "find-generic-password", "-s", "openai-first", "-w" },
        chat_template = require("gp.defaults").short_chat_template,
        agents = {
          {
            name = "ChatGPT4o-my",
            chat = true,
            command = false,
            model = { model = "gpt-4o", temperature = 1.1, top_p = 1 },
            system_prompt = "You are a general AI assistant.\n\n"
                .. "The user provided the additional info about how they would like you to respond:\n\n"
                .. "- If you're unsure don't guess and say you don't know instead.\n"
                .. "- Use Socratic method to improve your thinking and coding skills.\n"
                .. "- Don't elide any code from your output if the answer requires coding.\n",
          },
          -- {
          --   name = "o1-preview",
          --   chat = true,
          --   command = false,
          --   model = { model = "o1-preview", temperature = 1.1, top_p = 1 },
          --   -- system_prompt = require("gp.defaults").chat_system_prompt,
          --   system_prompt = "You are a general AI assistant.\n\n"
          --       .. "The user provided the additional info about how they would like you to respond:\n\n"
          --       .. "- If you're unsure don't guess and say you don't know instead.\n"
          --       .. "- Use Socratic method to improve your thinking and coding skills.\n"
          --       .. "- Don't elide any code from your output if the answer requires coding.\n",
          -- },
          -- {
          --   name = "o1-preview4commands",
          --   chat = false,
          --   command = true,
          --   -- string with model name or table with model name and parameters
          --   model = { model = "o1-preview", temperature = 1.1, top_p = 1 },
          --   -- system prompt (use this to specify the persona/role of the AI)
          --   system_prompt = "You are an AI working as a code editor.\n\n"
          --       .. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
          --       .. "START AND END YOUR ANSWER WITH:\n\n```",
          -- },
        }
      })
    end,
  },
  { 'echasnovski/mini.nvim', version = false },
}, {})

require('mini.trailspace').setup()

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
  require('conform').format({ async = true, lsp_fallback = true })
end, { desc = 'Format w/ formatter' })

--vim.keymap.set('v', '=', function()
--require('conform').format({ async = true, lsp_fallback = true })
--end, { desc = 'Format w/ formatter' })

--vim.keymap.set('n', '==', function()
--require('conform').format({ async = true, lsp_fallback = true })
--end, { desc = 'Format w/ formatter' })




-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false

-- Enable mouse mode
vim.o.mouse = 'a'


-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    path_display = { 'smart' },
    layout_config = {
      vertical = {
        width = 0.95
      },
      horizontal = {
        width = 0.95
      }
    },
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    modules = {},
    ensure_installed = {
      "bash",
      "c",
      "diff",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "jsonc",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
      "latex",
      "sql",
      "terraform",
      "go",
      "gomod",
      "graphql",
    },
    sync_install = false,
    ignore_install = {},
    auto_install = false,
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = { enable = false },
      swap = { enable = false },
    },
  }
end, 0)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- document existing key chains
-- require('which-key').register {
--   { '<leader>c', group = '[C]ode' },
--   --['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
--   { '<leader>g', group = '[G]it' },
--   { '<leader>h', group = 'More git' },
--   { '<leader>r', group = '[R]ename' },
--   { '<leader>s', group = '[S]earch' },
--   { '<leader>w', group = '[W]orkspace' },
-- }

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

-- Enable the following language servers
local servers = {
  -- clangd = {},
  -- gopls = {},
  pyright = {},
  -- rust_analyzer = {},
  ts_ls = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
}

vim.o.cursorline = false
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.wrap = true

vim.opt.listchars = { eol = '↵', space = '·', tab = '|·', trail = '~', extends = '>', precedes = '<' }
vim.o.list = false
vim.keymap.set({ 'n', 'i', 'v' }, '<leader>l', '<esc>:set list!<cr>')
-- F1
vim.wo.number = true
vim.o.relativenumber = true
vim.keymap.set({ 'n', 'i', 'v' }, '<F1>', function()
  if vim.o.nu then
    vim.o.number = false
    vim.o.relativenumber = false
  else
    vim.o.number = true
    vim.o.relativenumber = true
  end
end, { desc = 'Toggle numbers line' })
-- F2 save
vim.keymap.set('n', '<F2>', ':w<cr>')
vim.keymap.set('v', '<F2>', '<esc>:w<cr>')
vim.keymap.set('i', '<F2>', '<c-o>:w<cr>')
-- F3
vim.keymap.set({ 'n', 'i', 'v' }, '<F3>', '<esc>:set wrap!<cr>')
-- tabs
vim.keymap.set({ 'n' }, '<leader>_', '<esc>:buffers<cr>', { desc = 'Show/list buffers' })
vim.keymap.set({ 'n' }, '<leader>=', '<esc>:tabedit<CR>', { desc = 'New tab' })
vim.keymap.set({ 'n' }, '<leader>-', '<esc>:bd!<cr>', { desc = 'Close tab' })
vim.keymap.set({ 'n' }, '<leader>[', '<esc>:tabprev<cr>', { desc = 'Prev tab' })
vim.keymap.set({ 'n' }, '<leader>]', '<esc>:tabnext<cr>', { desc = 'Next tab' })
vim.keymap.set({ 'n' }, '<leader>{', '<esc>:tabm -1<cr>', { desc = 'Move tab left' })
vim.keymap.set({ 'n' }, '<leader>}', '<esc>:tabm +1<cr>', { desc = 'Move tab right' })
-- F5
vim.keymap.set({ 'n', 'v', 'i' }, '<F5>', '<esc>:cd %:h<cr>')
-- F6
vim.keymap.set({ 'n', 'v', 'i' }, '<F6>', '<esc>:bn<cr>')


vim.keymap.set('n', '<leader>rc', ':e $MYVIMRC<cr>')
vim.keymap.set('n', '<leader>re', ':source $MYVIMRC<cr>')

vim.keymap.set('n', '<leader>tm', ':TableModeToggle<cr>')

vim.keymap.set('x', 'ga', ':EasyAlign')
vim.keymap.set('n', 'ga', ':EasyAlign')


vim.keymap.set('n', '<S-Up>', '<Cmd>resize +1<CR>')             -- increase window size vertically
vim.keymap.set('n', '<S-Down>', '<Cmd>resize -1<CR>')           -- decrease window size vertically
vim.keymap.set('n', '<S-Right>', '<Cmd>vertical resize +1<CR>') -- increase window size horizontally
vim.keymap.set('n', '<S-Left>', '<Cmd>vertical resize -1<CR>')  -- decrease window size horizontally


-- vim.o.paste = true
-- vim.o.clipboard = 'unnamedplus'
if vim.fn.has('wsl') == 1 then
  -- vim.keymap.set('v', '"+y', "<esc>:'<,'>:w !clip.exe<cr><cr>")
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = 'clip.exe',
      ['*'] = 'clip.exe',
    },
    paste = {
      ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end

vim.cmd('autocmd FileType tex map <F9> :w<CR>:!xelatex -output-directory=%:p:h %<cr>')
vim.cmd('autocmd FileType tex vmap <F9> <esc>:w<CR>:!xelatex -output-directory=%:p:h %<cr>')
vim.cmd('autocmd FileType tex imap <F9> <esc>:w<CR>:!xelatex -output-directory=%:p:h %<cr>')

vim.cmd('autocmd FileType plantuml map <F9> :w<CR>:!plantuml -tpng -output %:p:h %<cr>')
vim.cmd('autocmd FileType plantuml vmap <F9> <esc>:w<CR>:!plantuml -tpng -output %:p:h %<cr>')
vim.cmd('autocmd FileType plantuml imap <F9> <esc>:w<CR>:!plantuml -tpng -output %:p:h %<cr>')

vim.api.nvim_create_augroup('terraform_ft', {})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = 'terraform_ft',
  pattern = { '*.tf', '*.tfvars' },
  callback = function()
    vim.bo.filetype = 'terraform'
  end,
})


if vim.g.neovide then
  vim.o.guifont = "VictorMono Nerd Font:h12"
  -- vim.o.guifont = "BlexMono Nerd Font:h12"
end

vim.opt.spelllang = 'en_us'
vim.keymap.set({ 'n', 'v', 'i' }, '<F7>', '<esc>:set invspell<cr>')

require("which-key").add({
  {
    mode = { "v" },
    nowait = true,
    remap = false,
    { "<C-g><C-t>", ":<C-u>'<,'>GpChatNew tabnew<cr>",   desc = "ChatNew tabnew" },
    { "<C-g><C-v>", ":<C-u>'<,'>GpChatNew vsplit<cr>",   desc = "ChatNew vsplit" },
    { "<C-g><C-x>", ":<C-u>'<,'>GpChatNew split<cr>",    desc = "ChatNew split" },
    { "<C-g>a",     ":<C-u>'<,'>GpAppend<cr>",           desc = "Visual Append (after)" },
    { "<C-g>b",     ":<C-u>'<,'>GpPrepend<cr>",          desc = "Visual Prepend (before)" },
    { "<C-g>c",     ":<C-u>'<,'>GpChatNew<cr>",          desc = "Visual Chat New" },
    { "<C-g>g",     group = "generate into new .." },
    { "<C-g>ge",    ":<C-u>'<,'>GpEnew<cr>",             desc = "Visual GpEnew" },
    { "<C-g>gn",    ":<C-u>'<,'>GpNew<cr>",              desc = "Visual GpNew" },
    { "<C-g>gp",    ":<C-u>'<,'>GpPopup<cr>",            desc = "Visual Popup" },
    { "<C-g>gt",    ":<C-u>'<,'>GpTabnew<cr>",           desc = "Visual GpTabnew" },
    { "<C-g>gv",    ":<C-u>'<,'>GpVnew<cr>",             desc = "Visual GpVnew" },
    { "<C-g>i",     ":<C-u>'<,'>GpImplement<cr>",        desc = "Implement selection" },
    { "<C-g>n",     "<cmd>GpNextAgent<cr>",              desc = "Next Agent" },
    { "<C-g>p",     ":<C-u>'<,'>GpChatPaste<cr>",        desc = "Visual Chat Paste" },
    { "<C-g>r",     ":<C-u>'<,'>GpRewrite<cr>",          desc = "Visual Rewrite" },
    { "<C-g>s",     "<cmd>GpStop<cr>",                   desc = "GpStop" },
    { "<C-g>t",     ":<C-u>'<,'>GpChatToggle popup<cr>", desc = "Visual Toggle Chat" },
  },
  {
    mode = { "n" },
    nowait = true,
    remap = false,
    { "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>",   desc = "New Chat tabnew" },
    { "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>",   desc = "New Chat vsplit" },
    { "<C-g><C-x>", "<cmd>GpChatNew split<cr>",    desc = "New Chat split" },
    { "<C-g>a",     "<cmd>GpAppend<cr>",           desc = "Append (after)" },
    { "<C-g>b",     "<cmd>GpPrepend<cr>",          desc = "Prepend (before)" },
    { "<C-g>c",     "<cmd>GpChatNew<cr>",          desc = "New Chat" },
    { "<C-g>f",     "<cmd>GpChatFinder<cr>",       desc = "Chat Finder" },
    { "<C-g>g",     group = "generate into new .." },
    { "<C-g>ge",    "<cmd>GpEnew<cr>",             desc = "GpEnew" },
    { "<C-g>gn",    "<cmd>GpNew<cr>",              desc = "GpNew" },
    { "<C-g>gp",    "<cmd>GpPopup<cr>",            desc = "Popup" },
    { "<C-g>gt",    "<cmd>GpTabnew<cr>",           desc = "GpTabnew" },
    { "<C-g>gv",    "<cmd>GpVnew<cr>",             desc = "GpVnew" },
    { "<C-g>n",     "<cmd>GpNextAgent<cr>",        desc = "Next Agent" },
    { "<C-g>r",     "<cmd>GpRewrite<cr>",          desc = "Inline Rewrite" },
    { "<C-g>s",     "<cmd>GpStop<cr>",             desc = "GpStop" },
    { "<C-g>t",     "<cmd>GpChatToggle popup<cr>", desc = "Toggle Chat" },
  },
  {
    mode = { "i" },
    nowait = true,
    remap = false,
    { "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>",   desc = "New Chat tabnew" },
    { "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>",   desc = "New Chat vsplit" },
    { "<C-g><C-x>", "<cmd>GpChatNew split<cr>",    desc = "New Chat split" },
    { "<C-g>a",     "<cmd>GpAppend<cr>",           desc = "Append (after)" },
    { "<C-g>b",     "<cmd>GpPrepend<cr>",          desc = "Prepend (before)" },
    { "<C-g>c",     "<cmd>GpChatNew<cr>",          desc = "New Chat" },
    { "<C-g>f",     "<cmd>GpChatFinder<cr>",       desc = "Chat Finder" },
    { "<C-g>g",     group = "generate into new .." },
    { "<C-g>ge",    "<cmd>GpEnew<cr>",             desc = "GpEnew" },
    { "<C-g>gn",    "<cmd>GpNew<cr>",              desc = "GpNew" },
    { "<C-g>gp",    "<cmd>GpPopup<cr>",            desc = "Popup" },
    { "<C-g>gt",    "<cmd>GpTabnew<cr>",           desc = "GpTabnew" },
    { "<C-g>gv",    "<cmd>GpVnew<cr>",             desc = "GpVnew" },
    { "<C-g>n",     "<cmd>GpNextAgent<cr>",        desc = "Next Agent" },
    { "<C-g>r",     "<cmd>GpRewrite<cr>",          desc = "Inline Rewrite" },
    { "<C-g>s",     "<cmd>GpStop<cr>",             desc = "GpStop" },
    { "<C-g>t",     "<cmd>GpChatToggle popup<cr>", desc = "Toggle Chat" },
  },
})

-- vim: ts=2 sts=2 sw=2 et
