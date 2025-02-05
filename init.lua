-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Set color scheme in Neovim (Lua)
-- https://darryldias.me/2023/set-color-scheme-in-neovim-lua/
-- vim.cmd([[colorscheme tokyonight-storm]])
-- vim.cmd([[colorscheme torte]])

-- 不产生交换文件
-- lhf: 实测 cmd([[xx]]) 不生效, 下面的写法 ('xx') 生效, 原因未知
-- vim.cmd([[
-- noswapfile
-- ]])
vim.cmd("set noswapfile")

-- How do I turn off specific listchars in my current file?
-- In my .vimrc file I have listchars set to showing tabs and trailing spaces.
-- set listchars=trail:~,tab:>-
-- https://vi.stackexchange.com/questions/27115/how-do-i-turn-off-specific-listchars-in-my-current-file
-- 默认 tab 符号会被当作"尖括号"显示, 我不想显示, 这里使用 nolist 来解决
-- 注: 不要使用 setlocal 其只能在当前窗口, 切换buffer 后, 尖括号又出现了, 使用 全局的 set nolist 一劳永逸
-- vim.cmd('setlocal nolist')
vim.cmd("set nolist")

-- https://manujsdev.com/blog/config-nvim-with-lua-colorscheme
require("config.colorscheme")
local options = {
  -- ...others configs...
  termguicolors = true, -- Enables 24-bit RGB color
}

-- https://teukka.tech/vimtip-gitlens.html
-- 说明: 当前目录下的文件 git blame 不卡, 可是打开一个 git 项目, 就会很快, 原因未知
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- 特别说明：此 git blame 导致 lazyvim 快速上下移动时严重卡顿，故暂时禁止
-- vim.api.nvim_command([[autocmd CursorHold   * lua require 'git_blame_utils'.blameVirtText()]])
-- vim.api.nvim_command([[autocmd CursorMoved  * lua require 'git_blame_utils'.clearBlameVirtText()]])
-- vim.api.nvim_command([[autocmd CursorMovedI * lua require 'git_blame_utils'.clearBlameVirtText()]])

-- hi! link GitLens Comment
-- vim.cmd("hi! link GitLens Comment")
-- vim.api.nvim_command([[hi! link GitLens Comment]])
-- 上面两句(hi! link)不清楚什么意思, 并且也没有生效, 下面设置生效了
--   (让 gitlens virtual text 改变颜色了)
vim.api.nvim_command("hi GitLens ctermfg=green guifg=green")
-- ----------------------------------------------------------------

-- 说明: 下面两个命令效果等价
-- vim.cmd("hi Comment ctermfg=blue guifg=blue")
-- 说明：我的 y9000p 笔记屏幕，对于 blue 显示看不清楚， 暂时将其修改为
--       绿色
-- vim.api.nvim_command("hi Comment ctermfg=blue guifg=blue")
vim.api.nvim_command("hi Comment ctermfg=green guifg=green")

-- 高亮折叠行的颜色
-- https://vi.stackexchange.com/questions/17842/fold-highlight-folded-text-only
vim.api.nvim_command("hi Folded ctermfg=cyan guifg=cyan")

--
-- Leaderf
--
-- 禁止 pop 预览窗口
-- This option specifies whether to preview the result in a popup window.
-- Default value is 1.
-- 说明: 实测证明下面 vim.cmd() 和 vim.api.nvim_command() 的效果是等价的
--       需要说明的是, nvim 目前不支持 vim9 scrip 语法, vim8scrip 语法是
--       生效的
-- vim.cmd("g:Lf_PreviewInPopup = 0")       -- vim9 scrip style
vim.cmd("let g:Lf_PreviewInPopup = 0")      -- vim8 scrip style

-- # 说明: Leaderf 默认使用 rg 来索引文件, 而 rg 默认 repect .gitigore-files 的,
-- # 即 git-reposity 下 ignore-files 不会被查询到, 这个默认设置不符合本人的要求,
-- # 本人期望如下 "find xx" 的结果, 因此进行如下的设置
-- # Default value is 1
vim.cmd("let g:Lf_UseVersionControlTool = 0")
vim.cmd("let g:Lf_DefaultExternalTool = \"find\"")
vim.cmd("let g:Lf_ExternalCommand = 'find \"%s\" -type f'")

-- LazyVim is slow, Can I do something about it? #3427
-- https://github.com/LazyVim/LazyVim/discussions/3427
vim.cmd("let g:python_host_prog  = '/usr/bin/python2'")
vim.cmd("let g:python3_host_prog = '/usr/bin/python3'")



-- TODO: 为解决问题：
--
-- 1. 上下不卡顿
-- nv ~/.local/share/nvim/lazy/fzf-lua/lua/fzf-lua/core.lua +34
-- 2. 上下卡顿
-- cd ~/.local/share/nvim/lazy/fzf-lua
-- nv lua/fzf-lua/core.lua +34
-- 3. 上下卡顿
-- cd ~/.local/share/nvim/lazy/fzf-lua/lua/fzf-lua/
-- nv core.lua +34
