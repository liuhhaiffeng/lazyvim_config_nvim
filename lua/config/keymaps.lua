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

-- 最新 lazyvim 中启用了一个“平滑滚动”的功能，此功能开启后，下面的映射，会导致
-- 连续上或下滚动时卡顿，故现暂将此功能禁止
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
--
-- 最后选用 ctrl-alt-n ctrl-alt-p 感觉最好
map("n", "<c-m-n>", ":cn<CR>", opts)
map("n", "<c-m-p>", ":cp<CR>", opts)

-- 注意: 这里要求命令字符串要在状态栏进行"回显", silent 要设置为 false
map("n", "<leader>G", ":Leaderf! rg -g !tags -g !*.taghl -s \"", { noremap = true, silent = false })

-- # 注： 使用下面连续多次搜索，偶现搜索结果“追加问题“， 原因未知？
map("n", "<leader>lg", ":<C-U><C-R>=printf(\"Leaderf! rg -g !tags -g !*.taghl --no-ignore -w -s -F %s \", expand(\"<cword>\"))<CR><CR>", opts)
map("n", "<leader>lo", ":<C-U><C-R>=printf(\"Leaderf! rg --recall %s\", \"\")<CR><CR>", opts)

-- # LeaderfFile 默认快捷键为 <leader>f, 因为我又定义了 <leader>fx 等其他快捷键，
-- # 此导致 <leader>f 反应慢， 原因是当前键入 <leader>f 后， vim
-- # 不知道我是要立即结束, 还是要输入 fx 其他命令，因此会等待一段时间，
-- # 为了解决此问题， 使用两个字母命令
map("n", "<leader>P", ":LeaderfFile<cr>", opts)

map("n" , "<leader>lr", ":<C-U><C-R>=printf(\"Leaderf! gtags -r %s --auto-jump\", expand(\"<cword>\"))<CR><CR>", opts);
map("n",  "<leader>lR", ":Leaderf! gtags -r ", { noremap = true, silent = false })

-- # 注意：若要执行两次命令，两个命令之间不要有空格，否则：首次打开vi时，执行
-- # 命令，仅能执行前一条，无法执行后一条，原因：就是两个命令中间不紧凑，
-- # 使用 ctags 来查找符号
map("n", "<leader>lt", ":LeaderfTag<CR>", opts)
-- # 使用 gtags 来查找符号
-- nnoremap <leader>lT :Leaderf gtags<cr>
-- map("n", "<leader>T", ":LeaderfTag<CR>", opts)
map("n", "<leader>T", ":Leaderf gtags<CR>", opts)

-- # Leaderf 查看当前文件函数列表快捷键
-- # 查看函数列表时，如果copen打开，那么将其关闭
-- # mz 记录当前光标位置，以便能够返回
-- map("n", "<leader>lf", "mz :LeaderfFunction!<cr>", opts)
map("n", "<leader>F", "mz :LeaderfFunction!<cr>", opts)

map("n", "<leader>/", ":LeaderfLine<cr>", opts)
map("n", "<leader>/w", ":LeaderfLineCword<cr>", opts)

map("n", "<c-p>", ":Leaderf --previous<cr>", opts)
map("n", "<c-n>", ":Leaderf --next<cr>", opts)

-- 注: 3次容易误按, 暂时先设置为4次
-- nnoremap <esc><esc><esc> <c-w>b<c-w>q
-- nnoremap <esc><esc><esc><esc> <c-w>b<c-w>q
-- map("n", "<esc><esc><esc><esc>", "<c-w>b<c-w>q", opts)
map("n", "<esc><esc><esc>", "<c-w>b<c-w>q", opts)

-- # 更新 ~/.LfCache/gtags
-- # 更多详情 vim 中查看帮助  :h g:Lf_Gtags
-- # mygl 中我启用了 ctags -R * 后, 执行下面命令时, 会报如下警告:
-- # ctags: Warning: ignoring null tag in ./scws-1.2.3/etc/rules.ini(line: 65)
-- # 暂解决如下: 将输出的警告给吃掉, 即使其不要显示到界面上来解决
-- # nnoremap <silent><leader>up :!bash mygl<cr>:Leaderf gtags --update<cr>
-- # :Leaderf gtags --update 会导致 gtags 一直 CPU 100%, 原因未知, 暂时将其禁止
-- # nnoremap <silent><leader>up :!bash mygl 1> /dev/null<cr>:Leaderf gtags --update<cr>
-- # 注: Leaderf 后面加了 ! 后, 好像 gtags 不 CPU 100 了
-- nnoremap <silent><leader>up :!bash mygl 1> /dev/null<cr>:Leaderf! gtags --update<cr>
map("n", "<leader>lup", ":!bash mygl 1> /dev/null<cr>:Leaderf! gtags --update<cr>", opts)


--- ----------------------------------------------------------
---   if  disable BufferLine
--- ----------------------------------------------------------

-- map("n", "<leader>1", ":BufferLineGoToBuffer 1<CR>", opts)
-- map("n", "<leader>2", ":BufferLineGoToBuffer 2<CR>", opts)
-- map("n", "<leader>3", ":BufferLineGoToBuffer 3<CR>", opts)
-- map("n", "<leader>4", ":BufferLineGoToBuffer 4<CR>", opts)
-- map("n", "<leader>5", ":BufferLineGoToBuffer 5<CR>", opts)
-- map("n", "<leader>6", ":BufferLineGoToBuffer 6<CR>", opts)
-- map("n", "<leader>7", ":BufferLineGoToBuffer 7<CR>", opts)
-- map("n", "<leader>8", ":BufferLineGoToBuffer 8<CR>", opts)
-- map("n", "<leader>9", ":BufferLineGoToBuffer 9<CR>", opts)
-- map("n", "<leader>$", ":BufferLineGoToBuffer -1<CR>", opts)
-- map("n", "<leader>bm", ":e ~/bm<CR>", opts)

--- ----------------------------------------------------------
---   else  enable tabxx
--- ----------------------------------------------------------

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
