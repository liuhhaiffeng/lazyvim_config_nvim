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
    { 'easymotion/vim-easymotion' },

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

    -- how to show file encoding in statusbar
    --  https://github.com/LazyVim/LazyVim/discussions/672
  {
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

    -- LeaderF 依赖 python2 或 python3
    -- 对于 vim --version 中要有 +python3, 否则需要手动编译(包含 python对应版本)
    -- 对于 nvim, 其默认不直接依赖python 
    -- 使用 echo has('python') 或 echo has('python3')) 查看时会发现均为 0,
    -- nvim 需要使用 pip3 install pynvim 安装 pynvim, 默认安装后, 再使用上述 
    -- echo xx 查询, 就 OK 了, 这时使用 Leaderf 才没有问题
    -- 参考: https://carakan.net/blog/2020/04/configuring-python3-on-neovim/
    {
        "Yggdroot/LeaderF",
        config = function()
            -- 取消默认快捷键映射
            local function unmap_leaderf_shortcuts()
                -- 方法1  实测不生效, 原因未知
                -- vim.g.Lf_ShortcutF = ''
                -- vim.g.Lf_ShortcutB = ''

                -- 方法2
                -- vim.keymap.del("n", "<leader>f")
                -- vim.keymap.del("n", "<leader>b")

                -- 方法3
                vim.cmd("let g:Lf_ShortcutF = ''")
                vim.cmd("let g:Lf_ShortcutB = ''")
            end
            unmap_leaderf_shortcuts()
        end,
    },
    {
        "vim-scripts/TagHighlight",
    },
}
