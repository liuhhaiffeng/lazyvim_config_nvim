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
vim.api.nvim_command("filetype plugin indent on")

-- 关闭鼠标
-- lhf: lazyvim 打开鼠标操作感觉更加好用(像vscode)一样, 故禁止如下行
vim.opt.mouse = ""

-- 默认搜索和替换大小写敏感
vim.o.ignorecase = false

-- 学习 helix 做法, 插入模式下, 显示绝对行号
-- vim 自动命令: https://zhuanlan.zhihu.com/p/98360630
-- au InsertEnter * :set nornu
-- au InsertLeave * :set rnu

--  自动命令lua写法参考: https://neovim.discourse.group/t/autocmd-to-lua-for-filetype/3840
-- vim.api.nvim_create_autocmd("InsertEnter", {
--   pattern = "*",
--   callback = function()
--     -- :set nornu
--     vim.wo.relativenumber = false
--   end,
-- })
--
-- vim.api.nvim_create_autocmd("InsertLeave", {
--   pattern = "*",
--   callback = function()
--     -- :set rnu
--     vim.wo.relativenumber = true
--   end,
-- })

-- 注: 实际测试发现, 多个分割窗口中, 仅仅用下面命令, 即可达到目的:
-- 即非焦点的其他窗口不显示"相对行号", 上面的 BufEnter 或 FocusLost
-- 等可以不需要
-- au WinEnter * :set rnu
-- au WinLeave * :set nornu

-- vim.api.nvim_create_autocmd("WinEnter", {
--   pattern = "*",
--   callback = function()
--     -- :set rnu
--     vim.wo.relativenumber = true
--   end,
-- })
--
-- vim.api.nvim_create_autocmd("WinLeave", {
--   pattern = "*",
--   callback = function()
--     -- :set nornu
--     vim.wo.relativenumber = false
--   end,
-- })

-- 不太习惯相对行号，将其禁止 （注： 上面的 autocmd relativenumber 也要禁止掉）
vim.wo.relativenumber = false

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

-- https://github.com/LazyVim/LazyVim/discussions/2215
-- easymotion 时， clangd diagnostics 会显示出来，形成干扰，因此默认情况不开启
-- 诊断功能
-- 注： 当然也可以使用下面的方式：
--
-- 方法1
-- -- ~/.config/nvim/lua/plugins/lsp.lua
-- return {
--   {
--     "nvim-lspconfig",
--     opts = {
--       diagnostics = {
--         virtual_text = false,
--         signs = false,
--       },
--     },
--   },
-- }
--
-- 方法2
-- 此方法，每次启动 nvim 时，都会提示 diagnostics 已关闭，非常烦人
-- require("lazyvim.util").toggle.diagnostics()

-- lazyvim 将 vim 默认的 foldtext() 进行了重新, 详见
-- lazy/LazyVim/lua/lazyvim/util/ui.lua 中 M.foldtext()
-- 此导致, foldline 不显示 折叠的行数
-- vim.opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
-- 覆盖
-- lazy/LazyVim/lua/lazyvim/config/options.lua 中
--     129:  opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"    You • 1 month ago • 1. 快捷键增加 2. 支持 gtags插件 3. 支持 LeaderF
--
-- 扩展: vim 默认 foldtext() 返回内容中包含如下部分:
--    1. 折叠的行数 2. 折叠的首行内容
--
--  如果将 foldtext 设置为如下的 "", 则仅显示 "折叠的行数"
-- vim.opt.foldtext = ""
vim.opt.foldtext = "foldtext()"

-- lazyvim rootdir 默认识别为 /home/uxdb (注: :LazyRoot 查看), 导致查找等操作很慢,
-- 显式将其设置为启动 nvim 时的"当前目录"
vim.g.root_spec = { "cwd" }

-- 基于 snacks-picker 的 “float 窗口”感觉不好用，想回到 telescope,
-- 无奈 git clone 总是失败，暂时先禁止掉
vim.g.lazyvim_picker = "telescope"
-- vim.g.lazyvim_picker = "snacks"
-- vim.g.lazyvim_picker = "fzf"

-- neovim 相比 vim, 有一个我认为的副作用: 重新打开 lazyvim 后, 对原来已经关闭保存
-- 的文件进行 undo 撤销操作, 还会记忆到重新打开之前, 由此导致将重新打开之前的内容
-- 也给撤销掉了, 如果没有 git 保证, 会导致原来明明已经保存的内容, 因为 undo 撤销
-- 给删除掉了, 因此将此特性给禁止掉
-- 分析: 个人任务, lazyvim 估计在某个地方保留了所谓的"session 状态", 由此实现
--       undo 撤销上次内容, 但这个对我的使用造成负面影响
-- How to make LazyVim to undo changes made in the current session only without
-- affecting changes saved in the previous sessions? #789
-- https://github.com/LazyVim/LazyVim/discussions/789
vim.opt.undofile = false

-- to disable all animations, add the following to here
vim.g.snacks_animate = false


-- ctrl + / 在 win 下默认打开的 cmd.exe, 我需要 pwsh.exe
if vim.fn.has("win32") == 1 then
  vim.opt.shell = "pwsh.exe"

  vim.opt.shellcmdflag =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command " ..
    "[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();" ..
    "$PSDefaultParameterValues['Out-File:Encoding']='utf8';" ..
    "$PSStyle.OutputRendering='plaintext';"

  vim.opt.shellredir = "2>&1 | ForEach-Object { \"$_\" } | Out-File %s; exit $LastExitCode"
  vim.opt.shellpipe = "2>&1 | ForEach-Object { \"$_\" } | Tee-Object %s; exit $LastExitCode"

  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
end

