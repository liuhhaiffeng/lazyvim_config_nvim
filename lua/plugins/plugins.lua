-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
-- if true then return {} end

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you an:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
    -- 在nvim中执行 nvim 或 shell 命令时, 我不喜欢 popup 弹出式的方式, 我觉得它
    -- 目前还存在一些问题, 如:
    -- 1. 执行 nvim 命令  : verbose map gd , 展示的结果, 过几秒中popup窗口就自动
    --    关闭了, 而我希望能永久停留, 直到我执行任意操作(如: 按下 enter)后再消失
    -- 2. vim 中 :!git log 即执行外部命令时, 可以进行交互, 而 cmdline 和 popup
    --    窗口只能接收"outpu结果", 不能像 vim 那样, 可以进行 类似 "more"那样的
    --    交互操作
    -- 3. 注: 使用下面方法将 nvim 还原到以前的方式后, 执行 :!git log 发现 nvim
    --        相比 vim 还是存在一点缺陷, 众所周知, 执行 git log, 其输出结果可能
    --        很多, vim 中, 执行 :!git log 默认是 :!git log|more 或 :!git log|less
    --        而 nvim 中, 会傻傻的将 git log 全部输出出来, 结果导致很卡顿.
    --    解决: 在 nvim 中执行的 shell 命令若结果很多时, 应该应该这些执行:
    --          :!xx|more  或 :!xx|less
    -- 4. 注2: 实测 nvime -u NONE 下, 执行 :git log|more 或 :!git log|less 还是
    --         不起作用, 仍然会尝试将 git log 所有记录output完, 由此导致很卡顿,
    --         找到了解决, 这说明此问题是 nvim 本身的一个 bug.
    --    解决: git log -n 展示前n条(注: 是前 n commit 条数), git log --stat -n
    --          也要如此
    -- https://github.com/LazyVim/LazyVim/discussions/1275
    {
        "folke/noice.nvim",
        opts = {
            cmdline = { enabled = false, },
            messages = { enabled = false, },
        },
    },
    {
        -- how to show file encoding in statusbar
        --  https://github.com/LazyVim/LazyVim/discussions/672
        "nvim-lualine/lualine.nvim",
        opts = function(_, opts)
            table.insert(opts.sections.lualine_x, "encoding")
            table.insert(opts.sections.lualine_x, "fileformat")
            table.insert(opts.sections.lualine_x, "filetype")
            table.insert(opts.sections.lualine_y, "%L")   -- 显示总行数
            table.insert(opts.sections.lualine_y, "selectioncount")
            -- table.insert(opts.sections.lualine_y, "diagnostics")    -- 左侧默认已经有了，这里就不冗余添加了
            table.remove(opts.sections.lualine_z)  -- 去除 时间显示

            -- 某些场景下，我需要显示 full path， 通过此设定
            -- 参考：https://github.com/LazyVim/LazyVim/discussions/3010
            -- 参考2： ~/.local/share/nvim/lazy/lualine.nvim/doc/lualine.txt 736
            -- table.insert(opts.sections.lualine_c, {
            --     "filename",
            --     path = 3,
            -- })
        end,
    },
    {
        "nvim-mini/mini.pairs",
        -- 参考： h mini.pars 中 MiniPairs.config 
        -- 非 "editor insert" 下, 输入"括号等", 不要"画蛇添足"的自动匹配
        opts = {
            modes = { insert = true, command = false, terminal = false },
        }
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            -- autoformat = false,
            -- easymotion 时，clangd diagnostics 会大片显示出来，很烦，暂禁止
            -- 参考： ~/.local/share/nvim/lazy/LazyVim/lua/lazyvim/util/extras.lua 217
            -- diagnostics = {
            --     virtual_text = false,
            --     signs = false,
            --     underline = false,
            -- },
            -- CXX 下不习惯 inlay_hints， 禁止掉
            inlay_hints = { enabled = false },
        },
    },
    -- lazyVim 之前使用 nvim-cmp 来自动补全，更新后使用 blink.cmp， 后者默认使用
    -- enter 进行补全，使用不习惯，修改为 tab 上下选择和确认补全
    -- https://github.com/LazyVim/LazyVim/discussions/5152
    --
    -- blink.cmp as nvim-cmp’s alternative #4679
    -- https://github.com/LazyVim/LazyVim/discussions/4679
    {
        "Saghen/blink.cmp",
        opts = {
            keymap = {
                -- 使用 enter 选中
                -- preset = "enter",
                -- 使用 tab 选中
                preset = "super-tab",
                ["<Tab>"] = { "select_next", "fallback" },
                ["<S-Tab>"] = { "select_prev", "fallback" },
                ['<C-y>'] = { 'select_and_accept' },
            },
            -- maybe optional 
            -- blink.cmp 升级后，再次 nv 打开文件时报错：
            --   blink.cmp utils.lua:28: completion.list.   selection: expected table, got string
            -- 原因是这里对应的配置也要同步修改如下：
            -- https://github.com/Saghen/blink.cmp/issues/948
            -- completion = { list = { selection = "auto_insert" } },
            completion = { list = { selection = { preselect = false, auto_insert = true } },

                -- https://cmp.saghen.dev/configuration/general.html
                -- Disable auto brackets
                -- NOTE: some LSPs may add auto brackets themselves anyway
                accept = { auto_brackets = { enabled = false }, },
            },

            -- blink.cmp  Falling back to Lua implementation due to error while 
            -- downloading pre-built binary, set fuzzy.implementation to  
            -- "prefer_rust"  or  "lua"  to disable this warning.
            fuzzy = { implementation = "lua" },

        },
    },

}
