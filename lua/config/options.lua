-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- utf8
vim.g.encoding = "UTF-8"
vim.o.fileencoding = "utf-8"

vim.opt.shiftwidth = 4 -- Size of an indent
vim.opt.tabstop = 4
-- 缩进4个空格等于一个Tab
vim.bo.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftround = true

-- 右侧参考线，超过表示代码太长了，考虑换行
vim.wo.colorcolumn = "81,121"

-- 空格替代tab
vim.o.expandtab = true
vim.bo.expandtab = true

-- 其实，不同的编程语言可能会有各自不同的缩进方案，可以开启vim文件类型检测功能，
-- 然后根据文件类型加载不同的缩进配置。
-- lhf 注: 尝试解决 打出 大括号后, 其对齐不正常问题, 到底能不能解决未知, 暂先将其
--         设置上
-- https://vi.stackexchange.com/questions/37186/how-do-i-port-a-filetype-command-to-neovims-lua-format
-- https://vi.stackexchange.com/questions/233/how-can-i-automatically-indent-on-new-lines
-- vim.api.nvim_command('filetype indent on')
vim.api.nvim_command('filetype plugin indent on')

-- 关闭鼠标
-- lhf: lazyvim 打开鼠标操作感觉更加好用(像vscode)一样, 故禁止如下行
vim.opt.mouse = ""

-- 学习 helix 做法, 插入模式下, 显示绝对行号
-- vim 自动命令: https://zhuanlan.zhihu.com/p/98360630
-- au InsertEnter * :set nornu
-- au InsertLeave * :set rnu

--  自动命令lua写法参考: https://neovim.discourse.group/t/autocmd-to-lua-for-filetype/3840
vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  callback = function()
    -- :set nornu
    vim.wo.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    -- :set rnu
    vim.wo.relativenumber = true
  end,
})

-- 注: 实际测试发现, 多个分割窗口中, 仅仅用下面命令, 即可达到目的:
-- 即非焦点的其他窗口不显示"相对行号", 上面的 BufEnter 或 FocusLost
-- 等可以不需要
-- au WinEnter * :set rnu
-- au WinLeave * :set nornu

vim.api.nvim_create_autocmd("WinEnter", {
  pattern = "*",
  callback = function()
    -- :set rnu
    vim.wo.relativenumber = true
  end,
})

vim.api.nvim_create_autocmd("WinLeave", {
  pattern = "*",
  callback = function()
    -- :set nornu
    vim.wo.relativenumber = false
  end,
})

-- How to disable autoformating on save on LazyVim
-- https://vi.stackexchange.com/questions/42597/how-to-disable-autoformating-on-save-on-lazyvim
--     {
--     "neovim/nvim-lspconfig",
--     opts = {
--       autoformat = false,
--     },
--   },
--
--  received a warning using the above answer. Looks like it should be set in
--
-- ~/.config/nvim/lua/config/options.lua
-- lhf: 目前, 我不喜欢自动保存时自动格式化, 先暂时禁止掉
vim.g.autoformat = false

-- lhf: layzvim 默认不支持折叠, 会报错: E350: Cannot create fold with current 'foldmethod'
-- 如下设置后OK
-- https://github.com/LazyVim/LazyVim/discussions/1233
vim.opt.foldmethod = "manual"

-- 自动 wrap
vim.opt.wrap = true
