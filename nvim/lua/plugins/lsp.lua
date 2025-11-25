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
        "j-hui/fidget.nvim",
        "Julian/lean.nvim",
        --"nvim-java/nvim-java",
        "mfussenegger/nvim-jdtls",
        "JavaHello/spring-boot.nvim",
    },

    config = function()
        require("fidget").setup({})
        require("mason").setup()
        --require("java").setup()
        require("mason-lspconfig").setup()
        require("spring_boot").init_lsp_commands()

        local capabilities = vim.tbl_deep_extend( "force",
            {}, vim.lsp.protocol.make_client_capabilities(), require("cmp_nvim_lsp").default_capabilities())

        --require('lspconfig').jdtls.setup({})
        --vim.lsp.enable("jdtls")

        vim.lsp.config('lua_ls', {
            capabilities = capabilities,
            settings = {
                Lua = {
                    --runtime = { version = "Lua 5.1" },
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

        vim.lsp.config('jdtls', {
            capabilities = capabilities,
            cmd = {
                vim.fn.exepath('jdtls'),
                string.format('--jvm-arg=-javaagent:%s', vim.fn.expand('$MASON/share/jdtls/lombok.jar')),
            },
            init_options = {
                bundles = require('spring_boot').java_extensions(),
            },
        })

        local cmp = require('cmp')
        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ['<Tab>']     = cmp.mapping.confirm({ select = true }),
                ['<C-Space>'] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({ { name = 'nvim_lsp' }, }, { { name = 'buffer' }, })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = { focusable = false, style = "minimal", border = "rounded", source = "always", header = "", prefix = "", },
        })
    end
}
