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
-- map("n", "<C-u>", "9k", opts)
-- map("n", "<C-d>", "9j", opts)

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
-- map("n", "<leader>ghB", ":<C-u>call gitblame#echo()<CR>", opts)
-- ghB 和 lazyvim 内置的冲突了， ga 没有使用，可以用
map("n", "<leader>ga", ":<C-u>call gitblame#echo()<CR>", opts)

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

map("n", "<F9>", "zfi{", opts)
map("n", "<F10>", "zo", opts)

-- <c-k> <c-j> (包括 <c-h> <c-l>) 被 lazyvim 默认映射为在多个窗口中跳转,
-- 因此使用 <c-n> <c-p> 作为 quickfix 的遍历方式
--
-- 注意: <m-n> <m-p> 也被 lazyvim 默认映射为 函数内当前 word 的遍历查找
--
-- <s-n> <s-p> 试了一下未被使用, 后续可以作为他用
map("n", "<c-n>", ":cn<CR>", opts)
map("n", "<c-p>", ":cp<CR>", opts)


-- 注意: 这里要求命令字符串要在状态栏进行"回显", silent 要设置为 false
-- map("n", "<leader>lG", ":cclose<cr>:Leaderf! rg -g !tags -g !*.taghl -s \"", { noremap = true, silent = false })
map("n", "<leader>G", ":cclose<cr>:Leaderf! rg -g !tags -g !*.taghl -s \"", { noremap = true, silent = false })
-- # 注： 使用下面连续多次搜索，偶现搜索结果“追加问题“， 原因未知？
map("n", "<leader>lg", ":<C-U><C-R>=printf(\"Leaderf! rg -g !tags -g !*.taghl --no-ignore -w -s -F %s \", expand(\"<cword>\"))<CR><CR>", opts)
map("n", "<leader>lo", ":<C-U><C-R>=printf(\"Leaderf! rg --recall %s\", \"\")<CR><CR>", opts)

-- # LeaderfFile 默认快捷键为 <leader>f, 因为我又定义了 <leader>fx 等其他快捷键，
-- # 此导致 <leader>f 反应慢， 原因是当前键入 <leader>f 后， vim
-- # 不知道我是要立即结束, 还是要输入 fx 其他命令，因此会等待一段时间，
-- # 为了解决此问题， 使用两个字母命令
-- map("n", "<leader>lP", ":cclose<cr>:LeaderfFile<cr>", opts)
map("n", "<leader>P", ":cclose<cr>:LeaderfFile<cr>", opts)

map("n" , "<leader>lr", ":cclose<CR>:<C-U><C-R>=printf(\"Leaderf! gtags -r %s --auto-jump\", expand(\"<cword>\"))<CR><CR>", opts);
map("n",  "<leader>lR", ":Leaderf! gtags -r ", { noremap = true, silent = false })

-- # 注意：若要执行两次命令，两个命令之间不要有空格，否则：首次打开vi时，执行
-- # 命令，仅能执行前一条，无法执行后一条，原因：就是两个命令中间不紧凑，
-- # 有空格,  错误的写法：noremap <leader>ft :cclose<cr> :Leaderf gtags<cr>
-- # 使用 ctags 来查找符号
map("n", "<leader>lt", ":cclose<cr>:LeaderfTag<CR>", opts)
-- # 使用 gtags 来查找符号
-- nnoremap <leader>lT :cclose<cr>:Leaderf gtags<cr>
map("n", "<leader>T", ":cclose<cr>:LeaderfTag<CR>", opts)

-- # Leaderf 查看当前文件函数列表快捷键
-- # 查看函数列表时，如果copen打开，那么将其关闭
-- # mz 记录当前光标位置，以便能够返回
-- map("n", "<leader>lf", "mz :cclose<cr>:LeaderfFunction!<cr>", opts)
map("n", "<leader>F", "mz :cclose<cr>:LeaderfFunction!<cr>", opts)

map("n", "<leader>/", ":LeaderfLine<cr>", opts)
map("n", "<leader>/w", ":LeaderfLineCword<cr>", opts)

map("n", "<c-p>", ":Leaderf --previous<cr>", opts)
map("n", "<c-n>", ":Leaderf --next<cr>", opts)

-- 注: 3次容易误按, 暂时先设置为4次
-- nnoremap <esc><esc><esc> <c-w>b<c-w>q
-- nnoremap <esc><esc><esc><esc> <c-w>b<c-w>q
-- map("n", "<esc><esc><esc><esc>", "<c-w>b<c-w>q", opts)
map("n", "<esc><esc><esc>", "<c-w>b<c-w>q", opts)
