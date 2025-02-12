-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- 为自定义文件类型添加语法高亮
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
-- vim 为新添加的文件后缀支持语法高亮
-- 某个工程下的C代码都是以.pgc为后缀名命名的，
-- 如果直接用默认配置的vim打开该文件，则vim不
-- 认为这个文件时c文件，因此不会启动语法高亮。
-- 解决办法如下:
vim.api.nvim_command [[au BufNewFile,BufRead *.pgc set filetype=c]]
vim.api.nvim_command [[au BufNewFile,BufRead *.smi set filetype=sql]]
vim.api.nvim_command [[au BufNewFile,BufRead *.std set filetype=sql]]
vim.api.nvim_command [[au BufNewFile,BufRead *.nc set filetype=sql]]
vim.api.nvim_command [[au BufNewFile,BufRead *.out set filetype=sql]]

-- lhf 注: 将 markdown 设置为 c-type 后, clangd 会显示"好多语法" lint 提示,
--         因此暂时将此"特别修改"禁掉
-- vim 中 markdown 没有语法, 看的人眼睛疼, 因此这里特别修改为 c-type, 给
-- 单调的文档加一点色彩
-- vim.api.nvim_command [[au BufNewFile,BufRead *README* set filetype=c]]

vim.api.nvim_command [[au BufNewFile,BufRead *README* set filetype=markdown]]
-- 刘海峰~/bm (bookmark)书签高亮
vim.api.nvim_command [[au BufNewFile,BufRead bm set filetype=c]]
-- 刘海峰~/bm (bookmark)书签高亮
vim.api.nvim_command [[au BufNewFile,BufRead bookmark set filetype=c]]
-- 刘海峰~/bm (bookmark)书签高亮
vim.api.nvim_command [[au BufNewFile,BufRead bm_pg set filetype=c]]
-- 刘海峰~/bm (bookmark)书签高亮
vim.api.nvim_command [[au BufNewFile,BufRead bookmark_pg set filetype=c]]


-- .local/share/nvim/lazy/nvim-lspconfig/lua/lspconfig/configs/fsautocomplete.lua:`autocmd BufNewFile,BufRead *.fs,*.fsx,*.fsi set filetype=fsharp`
-- cxx 类型文件的 lsp 默认无法自动开启, 故增加配置开启
vim.api.nvim_command [[au BufNewFile,BufRead *.c,*.cpp,*.cxx,*.C,*.objc,*.duda,*.proto,*.h,*.hpp,*.hxx :LspStart]]

-- lazyvim markdown codeblock tags(即 tab按键上面的那个“撇”符号， ```sh  ```) 
-- 默认不显示，通过如下设置让其显示：
-- How to get markdown always to display the source code？
-- https://github.com/LazyVim/LazyVim/discussions/269
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "markdown" },
  callback = function()
    vim.wo.conceallevel = 0
  end,
})


-- ctrl + / 可以打开内置 terminal, 在其中，double <esc> 可以从 terminal 切换到
-- normal 模式，这样就可以在 terminal 中使用按键上下滚动了，但默认设置有个问题：
-- 从 terminal 中跳到其他 editor buffer 然后再跳回来，默认变成了 terminal 模式，
-- 这个行为不符合我的习惯用法
--
-- snacks.terminal 默认行为如下：
-- ~/.local/share/nvim/lazy/snacks.nvim/lua/snacks/terminal.lua
-- vim.api.nvim_create_autocmd("BufEnter", {
--   buffer = terminal.buf,
--   callback = function()
--     vim.cmd.startinsert()
--   end,
-- })
--
-- 目前不清楚如何在配置文件中修改，因此，直接在 snacks.terminal 源码中直接修改
-- 修改如下：terminal BufEnter 去除 vim.cmd.startinsert
-- vim.api.nvim_create_autocmd("BufEnter", {
--   buffer = terminal.buf,
--   callback = function()
--     -- vim.cmd.startinsert()
--   end,
-- })
