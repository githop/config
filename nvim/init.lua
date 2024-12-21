-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Tab and indent
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- cursor
vim.o.cursorline = true

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

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

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', nbsp = '␣' }

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- FOLD
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevel = 99

-- [[ Basic Keymaps ]]
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- clear search highlights
vim.keymap.set('n', '<leader>nh', ':nohl<CR>', { desc = 'Clear search highlights' })

--window management
vim.keymap.set('n', '<leader>sv', '<C-w>v', { desc = 'Split window vertically' })
vim.keymap.set('n', '<leader>sh', '<C-w>s', { desc = 'Split window horizontally' })
vim.keymap.set('n', '<leader>se', '<C-w>=', { desc = 'Make split windows equal width and height' })
vim.keymap.set('n', '<leader>sx', ':close<CR>', { desc = 'Close current split window' })
vim.keymap.set('n', '<leader>[', ':bp<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<leader>]', ':bn<CR>', { desc = 'Next buffer' })

-- move selection
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set('n', '<leader>e', function()
  require('oil').toggle_float(nil)
end, { desc = 'Open parent dir' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- yank filepath relative
vim.keymap.set('n', '<leader>cf', ":call setreg('+', expand('%:.'))<CR>", { desc = '[c]opy [f]ile path' })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Install package manager
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

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  'windwp/nvim-ts-autotag',
  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'saghen/blink.cmp',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          -- See `:help K` for why this keymap
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
          map('<leader>ca', require('fzf-lua').lsp_code_actions, '[C]ode [A]ction')
          map('gd', function()
            require('fzf-lua').lsp_definitions {
              jump_to_single_result = true,
            }
          end, '[G]oto [D]efinition')
          map('gr', require('fzf-lua').lsp_references, '[G]oto [R]eferences')
          map('gI', require('fzf-lua').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>D', require('fzf-lua').lsp_typedefs, 'Type [D]efinition')
          map('<leader>ds', require('fzf-lua').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('fzf-lua').lsp_live_workspace_symbols, '[W]orkspace [S]ymbols')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end

          -- Change diagnostic symbols in the sign column (gutter)
          if vim.g.have_nerd_font then
            local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
            local diagnostic_signs = {}
            for type, icon in pairs(signs) do
              diagnostic_signs[vim.diagnostic.severity[type]] = icon
            end
            vim.diagnostic.config { signs = { text = diagnostic_signs } }
          end

          vim.diagnostic.config {
            float = {
              border = 'rounded',
            },
          }
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())
      local lspconfig = require 'lspconfig'

      local servers = {
        html = { filetypes = { 'html', 'hbs' } },
        cssls = {},
        jsonls = {},
        eslint = {
          on_attach = function(_, bufnr)
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = bufnr,
              command = 'EslintFixAll',
            })
          end,
          settings = {
            workingDirectory = { mode = 'location' },
          },
          root_dir = lspconfig.util.find_git_ancestor,
        },
        pyright = {},
        yamlls = {
          settings = {
            yaml = {
              format = {
                enable = true,
              },
              customTags = {
                '!Base64 scalar',
                '!Cidr scalar',
                '!And sequence',
                '!Equals sequence',
                '!If sequence',
                '!Not sequence',
                '!Or sequence',
                '!Condition scalar',
                '!FindInMap sequence',
                '!GetAtt scalar',
                '!GetAtt sequence',
                '!GetAZs scalar',
                '!ImportValue scalar',
                '!Join sequence',
                '!Select sequence',
                '!Split sequence',
                '!Sub scalar',
                '!Transform mapping',
                '!Ref scalar',
              },
            },
          },
        },
        graphql = { filetypes = { 'graphql' } },
        lua_ls = {
          -- cmd = {...},
          -- filetypes { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              runtime = { version = 'LuaJIT' },
              workspace = {
                checkThirdParty = false,
                -- Tells lua_ls where to find all the Lua files that you have loaded
                -- for your neovim configuration.
                library = {
                  '${3rd}/luv/library',
                  unpack(vim.api.nvim_get_runtime_file('', true)),
                },
                -- If lua_ls is really slow on your computer, you can try this instead:
                -- library = { vim.env.VIMRUNTIME },
              },
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      require('mason').setup()
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format lua code
        'typos-lsp',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  {
    'saghen/blink.cmp',
    dependencies = 'rafamadriz/friendly-snippets',
    version = 'v0.*',
    opts = {
      keymap = {
        preset = 'default',
        ['<C-k>'] = { 'select_prev', 'fallback' },
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-l>'] = { 'select_and_accept', 'fallback' },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
      },
      signature = { enabled = true },
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = {
          completeopt = 'menu,menuone,noinsert',
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-k>'] = cmp.mapping.select_prev_item(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        },
      }
    end,
  },

  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    event = 'VeryLazy', -- Sets the loading event to 'VimEnter'
    opts = {},
    spec = {
      { '<leader>c', group = '[C]ode' },
      { '<leader>d', group = '[D]ocument' },
      { '<leader>r', group = '[R]ename' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>w', group = '[W]orkspace' },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    },
  },

  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Jump to next hunk' })

        map({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Jump to previous hunk' })

        -- Actions
        -- visual mode
        map('v', '<leader>hs', function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'stage git hunk' })
        map('v', '<leader>hr', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'reset git hunk' })
        -- normal mode
        map('n', '<leader>hs', gs.stage_hunk, { desc = 'git stage hunk' })
        map('n', '<leader>hr', gs.reset_hunk, { desc = 'git reset hunk' })
        map('n', '<leader>hS', gs.stage_buffer, { desc = 'git Stage buffer' })
        map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
        map('n', '<leader>hR', gs.reset_buffer, { desc = 'git Reset buffer' })
        map('n', '<leader>hp', gs.preview_hunk, { desc = 'preview git hunk' })
        map('n', '<leader>hb', function()
          gs.blame_line { full = false }
        end, { desc = 'git blame line' })
        map('n', '<leader>hd', gs.diffthis, { desc = 'git diff against index' })
        map('n', '<leader>hD', function()
          gs.diffthis '~'
        end, { desc = 'git diff against last commit' })

        -- Toggles
        map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'toggle git blame line' })
        map('n', '<leader>td', gs.toggle_deleted, { desc = 'toggle git show deleted' })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
      end,
    },
  },

  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    config = function()
      require('kanagawa').load 'dragon'
    end,
  },

  {
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()
    end,
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = { theme = 'kanagawa' },
      }
    end,
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    main = 'ibl',
    opts = {},
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'ibhagwan/fzf-lua',
    -- optional for icon support
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      -- calling `setup` is optional for customization
      require('fzf-lua').setup { 'fzf-native' }
      require('fzf-lua').setup {
        winopts = {
          height = 0.9,
          width = 0.9,
        },
        lsp = {
          code_actions = {
            previewer = 'codeaction_native',
          },
        },
      }

      vim.keymap.set('n', '<leader>?', require('fzf-lua').oldfiles, { desc = '[?] Find recently opened files' })
      vim.keymap.set('n', '<leader><space>', require('fzf-lua').buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>/', require('fzf-lua').lgrep_curbuf, { desc = '[/] Fuzzily search in current buffer' })
      vim.keymap.set('n', '<leader>gf', require('fzf-lua').git_files, { desc = 'Search [G]it [F]iles' })
      vim.keymap.set('n', '<leader>gs', require('fzf-lua').git_status, { desc = '[G]it [S]tatus' })
      vim.keymap.set('n', '<leader>sf', require('fzf-lua').files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>she', require('fzf-lua').help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sw', require('fzf-lua').grep_cword, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', require('fzf-lua').live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', require('fzf-lua').diagnostics_document, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('v', '<leader>sv', function()
        require('fzf-lua').grep_visual { rg_opts = '--multiline' }
      end, { desc = '[S]earch [V]isual' })
      vim.keymap.set('n', '<leader>sb', require('fzf-lua').builtin, { desc = '[S]earch [B]uiltin' })
      vim.keymap.set('n', '<leader>tr', require('fzf-lua').resume, { desc = '[R]esume' })
      vim.keymap.set('n', '<leader>to', require('fzf-lua').oldfiles, { desc = '[O]ldfiles' })
      vim.keymap.set('n', '<leader>sn', function()
        require('fzf-lua').live_grep { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim' })
    end,
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
    'stevearc/oil.nvim',
    opts = {},
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('oil').setup {
        win_options = {
          signcolumn = 'yes:1',
        },
        view_options = {
          show_hidden = true,
        },
        float = {
          padding = 1,
          max_width = 66,
        },
      }
    end,
  },

  {
    'refractalize/oil-git-status.nvim',
    dependencies = {
      'stevearc/oil.nvim',
    },
    config = function()
      require('oil-git-status').setup {}
    end,
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },

  {
    'mfussenegger/nvim-lint',
    lazy = true,
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      lint.linters_by_ft = {
        javascript = { 'biomejs' },
        typescript = { 'biomejs' },
        javascriptreact = { 'biomejs' },
        typescriptreact = { 'biomejs' },
        scss = { 'stylelint' },
      }
      vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },

  {
    'stevearc/conform.nvim',
    lazy = true,
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local conform = require 'conform'

      conform.setup {
        formatters_by_ft = {
          javascript = { 'biome' },
          typescript = { 'biome' },
          javascriptreact = { 'biome' },
          typescriptreact = { 'biome' },
          css = { 'prettier' },
          html = { 'prettier' },
          json = { 'biome' },
          yaml = { 'prettier' },
          markdown = { 'prettier' },
          graphql = { 'prettier' },
          lua = { 'stylua' },
          ruby = { 'rubocop' },
        },
        format_on_save = {
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        },
      }
    end,
  },

  {
    'vuki656/package-info.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require('package-info').setup {}

      vim.keymap.set('n', '<leader>ns', require('package-info').show, { desc = 'Show npm package info' })
      vim.keymap.set('n', '<leader>nt', require('package-info').toggle, { desc = 'Toggle npm package info' })
      vim.keymap.set('n', '<leader>nu', require('package-info').update, { desc = 'Update npm package' })
      vim.keymap.set('n', '<leader>nc', require('package-info').change_version, { desc = 'Change npm package' })
    end,
  },

  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        panel = {
          enabled = false,
        },
        suggestion = {
          enabled = true,
          keymap = {
            accept = '<C-l>',
          },
        },
      }
    end,
  },

  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {},
    config = function()
      require('typescript-tools').setup {}
    end,
  },

  {
    'goolord/alpha-nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local alpha = require 'alpha'
      local dashboard = require 'alpha.themes.dashboard'

      local header = [[
 ██████╗ ██╗████████╗██╗  ██╗ ██████╗ ██████╗
██╔════╝ ██║╚══██╔══╝██║  ██║██╔═══██╗██╔══██╗
██║  ███╗██║   ██║   ███████║██║   ██║██████╔╝
██║   ██║██║   ██║   ██╔══██║██║   ██║██╔═══╝
╚██████╔╝██║   ██║   ██║  ██║╚██████╔╝██║
 ╚═════╝ ╚═╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝
      ]]
      dashboard.section.header.val = vim.split(header, '\n')
      dashboard.section.buttons.val = {
        dashboard.button('f', '  find file', '<cmd>FzfLua files<CR>'),
        dashboard.button('r', '  recent', '<cmd>FzfLua oldfiles<CR>'),
        dashboard.button('g', '  search', '<cmd>FzfLua live_grep_glob<CR>'),
        dashboard.button('q', '󰅚  Quit NVIM', ':qa<CR>'),
      }
      local handle = io.popen 'fortune'
      local fortune = handle:read '*a'
      handle:close()
      dashboard.section.footer.val = fortune

      dashboard.config.opts.noautocmd = true

      vim.cmd [[autocmd User AlphaReady echo 'ready']]

      alpha.setup(dashboard.config)
    end,
  },

  {
    'ruifm/gitlinker.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitlinker').setup {}
    end,
  },

  {
    'folke/trouble.nvim',
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = 'Trouble',
    keys = {
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>cl',
        '<cmd>Trouble lsp toggle focus=false win.type=float<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      {
        '<leader>xL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>xQ',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)',
      },
    },
  },

  {
    'kdheepak/lazygit.nvim',
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
  },

  {
    'dmmulroy/tsc.nvim',
    config = function()
      require('tsc').setup {
        run_as_monorepo = true,
        use_trouble_qflist = true,
        pretty_errors = true,
      }
    end,
  },
  -- require 'kickstart.plugins.debug',
}, {})

-- [[ detect .env files ]]
vim.filetype.add {
  -- Detect and assign filetype based on the extension of the filename
  extension = {
    env = 'sh',
  },
  -- Detect and apply filetypes based on the entire filename
  filename = {
    ['.env'] = 'sh',
    ['env'] = 'sh',
  },
  -- Detect and apply filetypes based on certain patterns of the filenames
  pattern = {
    -- INFO: Match filenames like - ".env.example", ".env.local" and so on
    ['%.env%.[%w_.-]+'] = 'sh',
  },
}

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'lua', 'python', 'ruby', 'tsx', 'typescript', 'graphql', 'json', 'javascript', 'vimdoc', 'vim', 'html', 'css', 'bash' },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,

    autotag = {
      enable = true,
    },

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
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
