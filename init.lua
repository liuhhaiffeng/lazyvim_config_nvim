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
-- vim.api.nvim_command([[autocmd CursorHold   * lua require 'git_blame_utils'.blameVirtText()]])
-- vim.api.nvim_command([[autocmd CursorMoved  * lua require 'git_blame_utils'.clearBlameVirtText()]])
-- vim.api.nvim_command([[autocmd CursorMovedI * lua require 'git_blame_utils'.clearBlameVirtText()]])

-- hi! link GitLens Comment
-- vim.cmd("hi! link GitLens Comment")
-- vim.api.nvim_command([[hi! link GitLens Comment]])
-- 上面两句(hi! link)不清楚什么意思, 并且也没有生效, 下面设置生效了
--   (让 gitlens virtual text 改变颜色了)
-- vim.api.nvim_command("hi GitLens ctermfg=green guifg=green")
-- ----------------------------------------------------------------

-- 说明: 下面两个命令效果等价
-- vim.cmd("hi Comment ctermfg=blue guifg=blue")
vim.api.nvim_command("hi Comment ctermfg=blue guifg=blue")
