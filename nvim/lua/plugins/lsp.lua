return {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "mason-org/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
        "Julian/lean.nvim",
        "nvim-java/nvim-java",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()
        require("java").setup()
        require("mason-lspconfig").setup({
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    --local lspconfig = require("lspconfig")
                    --lspconfig.lua_ls.setup {
                    vim.lsp.config('lua_ls', {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    })
                end,

--                ts_ls = function()
--                    local lspconfig = require("lspconfig")
--
--                    lspconfig.ts_ls.setup {
--                        capabilities = capabilities,
--                        init_options = {
--                            plugins = {
--                                {
--                                    name = "@vue/typescript-plugin",
--                                    location = "/home/lucas/.local/share/nvim/mason/packages/vue-language-server/node_modules/@vue/language-server",
--                                    languages = { "vue" },
--                                },
--                            },
--                        },
--                        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
--                    }
--
--                    lspconfig.volar.setup {}
--                end,

--                jdtls = function()
--                    require('lspconfig').jdtls.setup({})
--                end,
            }
        })
        require('lspconfig').jdtls.setup({})
--        vim.lsp.enable('jdtls')
        vim.lsp.config('lua_ls', {
            capabilities = capabilities,
            settings = {
                Lua = {
                    runtime = { version = "Lua 5.1" },
                    diagnostics = {
                        globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                    }
                }
            }
        })
        vim.lsp.config('vtsls', {
            capabilities = capabilities,
            settings = {
                vtsls = {
                    tsserver = {
                        globalPlugins = {
                            { name = '@vue/typescript-plugin', location = vim.fn.expand("$MASON/packages/vue-language-server/node_modules/@vue/language-server"), languages = { 'vue' }, configNamespace = 'typescript', }
                        },
                    },
                },
            },
            filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = "copilot", group_index = 2 },
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
