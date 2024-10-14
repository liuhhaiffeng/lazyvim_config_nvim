-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- https://zhuanlan.zhihu.com/p/532486519
-- https://www.zhihu.com/tardis/zm/art/435680085?source_id=1005
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- https://www.zhihu.com/tardis/zm/art/435680085?source_id=1005
-- j / k 移动太慢， ctrl + u / ctrl + d 默认移动半屏，翻太快，一不留神就不知道翻到哪了
-- 我喜欢把 ctrl + u / ctrl + d 设置成移动 9 行，
map("n", "<C-u>", "9k", opts)
map("n", "<C-d>", "9j", opts)

map("n", "k", "kzz", opts)
map("n", "j", "jzz", opts)

map("i", "jj", "<esc>", opts)


map("n", "<leader>mb", "<Plug>(easymotion-b)", opts)
map("n", "<leader>mw", "<Plug>(easymotion-w)", opts)
-- 取消默认的 <leader><leader> Find Files (root dir) 按键映射
vim.api.nvim_del_keymap("n", "<leader><leader>")
map("n", "<leader><leader>b", "<Plug>(easymotion-b)", opts)
map("n", "<leader><leader>w", "<Plug>(easymotion-w)", opts)

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- git-blame.vim
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- https://github.com/zivyangll/git-blame.vim
-- map("n", "<leader><leader>ghB", ":<C-u>call gitblame#echo()<CR>", opts)
map("n", "<leader>ghB", ":<C-u>call gitblame#echo()<CR>", opts)

-- 由于目前对 nvim 还不熟悉, 因此将自定义的 vim 脚本函数添加到 git-blame 中来实现
-- 加载
-- /home/uxdb/.local/share/nvim/lazy/git-blame.vim/autoload
-- map("n", "<leader>F", ":<C-u>echo gitblame#GetProtoLine()<CR>", opts)

-- 鼠标功能打开与关闭
-- mo : mouse on
-- mf : mouse off
map("n", "<leader>mo", ":set mouse=a<CR>", opts)
map("n", "<leader>mf", ":set mouse=<CR>", opts)

-- 当前 cxx lsp-server (注: clangd) 默认不启动(注: 尽管设置为 autostart), 原因未知,
-- 因此使用快捷键来手动开启
map("n", "<leader>lspo", ":LspStart<CR>", opts)
map("n", "<leader>lspf", ":LspStop<CR>", opts)
map("n", "<leader>lspi", ":LspInfo<CR>", opts)
