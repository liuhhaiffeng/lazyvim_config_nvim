return {
    -- add gruvbox
    { "ellisonleao/gruvbox.nvim" },

    {
        -- https://github.com/maxmx03/solarized.nvim
        'maxmx03/solarized.nvim',
        lazy = false,
        priority = 1000,
        -- config = function()
        --     vim.o.background = 'dark' -- or 'light'

        --     vim.cmd.colorscheme 'solarized'
        -- end,
    },

    -- Configure LazyVim to load gruvbox
    -- {
    --     "LazyVim/LazyVim",
    --     opts = {
    --         colorscheme = "gruvbox",
    --     },
    -- },
    

    -- lazyvim 自动补全菜单背景透明, 导致前景内容看不清楚, 解决之
    -- https://github.com/LazyVim/LazyVim/discussions/2360
    -- https://github.com/LazyVim/LazyVim/discussions/419#discussioncomment-5802918
    -- case1: 此内容未解决问题
    -- {
    --     "hrsh7th/nvim-cmp",
    --     opts = function(_, opts)
    --         local cmp = require("cmp")
    --         opts.window = {
    --             completion = cmp.config.window.bordered(),
    --             documentation = cmp.config.window.bordered(),
    --         }
    --     end,
    -- },

    -- case2: 此内容解决了问题
    {
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
            vim.api.nvim_set_hl(0, "PopMenu", { bg = "#1F2335", blend = 0 })
            local cmp = require("cmp")
            local win_opt = {
                col_offset = 0,
                side_padding = 1,
                winhighlight = "Normal:PopMenu,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
            }
            opts.window = {
                completion = cmp.config.window.bordered(win_opt),
                documentation = cmp.config.window.bordered(win_opt),
            }
            opts.experimental = {
                ghost_text = true,
            }
        end,
    },
}

