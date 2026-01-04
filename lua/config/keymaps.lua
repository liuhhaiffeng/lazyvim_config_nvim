-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- https://zhuanlan.zhihu.com/p/532486519
-- https://www.zhihu.com/tardis/zm/art/435680085?source_id=1005
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- 最新 lazyvim 中启用了一个“平滑滚动”的功能，此功能开启后，下面的映射，会导致
-- 连续上或下滚动时卡顿，故现暂将此功能禁止
-- map("n", "k", "kzz", opts)
-- map("n", "j", "jzz", opts)

map("i", "jj", "<esc>", opts)


-- 鼠标功能打开与关闭
-- mo : mouse on
-- mf : mouse off
map("n", "<leader>mo", ":set mouse=a<CR>", opts)
map("n", "<leader>mf", ":set mouse=<CR>", opts)

map("n", "<F9>", "zfi{", opts)
map("n", "<F10>", "zo", opts)


-- 创建一个空白tab, , "$" 作用: 新建在已有 tab 的最右侧
map("n", "<leader>tn", ":$tabnew<CR>", opts)
-- 复制当前tab, mz 记住当前行, 以便在 tabnew % 中跳转到当前行
-- td: tab duplication
map("n", "<leader>td", "mz:$tabnew %<CR>", opts)
-- # 切换到tab1 (注： tab页从1开始)
map("n", "<leader>1",  ":tabn 1<cr>", opts)
map("n", "<leader>2",  ":tabn 2<cr>", opts)
map("n", "<leader>3",  ":tabn 3<cr>", opts)
map("n", "<leader>4",  ":tabn 4<cr>", opts)
map("n", "<leader>5",  ":tabn 5<cr>", opts)
map("n", "<leader>6",  ":tabn 6<cr>", opts)
map("n", "<leader>7",  ":tabn 7<cr>", opts)
map("n", "<leader>8",  ":tabn 8<cr>", opts)
map("n", "<leader>9",  ":tabn 9<cr>", opts)
-- tc: table close
map("n", "<leader>tc",  ":tabclose<cr>", opts)
map("n", "<leader>bm", ":$tabnew ~/bm<cr>", opts)

--- ----------------------------------------------------------
---   end if
--- ----------------------------------------------------------


-- 错误示例: 
--   最近使用 w, 进行单词移动时, 发现突然变得很慢, 原因就是我下面的
--   设置造成的, 我定义了个 wa, 所以按下 w 键, 会等待可能得 wa 输入,
--   所以导致 w 移动操作变慢
-- map("n", "wa", ":wa<cr>", opts)

map("n", "<leader>ao", ":LspClangdSwitchSourceHeader<cr>", opts)
