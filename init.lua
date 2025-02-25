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



local function get_current_function_info()
    -- 获取当前缓冲区的所有行
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    -- 当前光标位置
    local cursor = vim.api.nvim_win_get_cursor(0)
    -- local current_line = cursor[1] - 1 -- 行号从 0 开始
    local current_line = cursor[1] -- 行号从 1 开始

    -- 查找函数的起始位置（向后查找第一个 '{'）
    local start_line = current_line
    while start_line >= 0 do
        local line_content = lines[start_line + 1]
        -- if line_content:match("%f[^%s]}%s*{") then
        local match1 = line_content:match("^%{%s*")
        -- %([%s%w_]*%) 中的 [%s%w_]* 无法匹配所以场景, 如: 
        --    ShutdownXLOG(int code, Datum arg) {
        -- 因此, 目前暂使用 ".*" 来泛匹配吧
        -- local match2 = line_content:match("[%w_]+%s*%([%s%w_]*%)%s*%{")
        local match2 = line_content:match("[%w_]+%s*%(.*%)%s*%{")
        if match1 or match2 then
            if (match2) then
                start_line = start_line + 1
            end
            -- print(string.format("start_line(%d), match1(%s), match2(%s)", start_line, match1, match2))
            break
        end
        start_line = start_line - 1
    end

    -- 检查是否找到了函数的起始位置
    if start_line < 0 then
        vim.notify("Cursor is not inside a function.", vim.log.levels.WARN)
        return
    end

    -- 提取函数名称（从起始行向上查找函数定义）
    local function_name = "Unknown"
    for i = start_line, 0, -1 do
        -- local line_content = lines[i + 1]
        local line_content = lines[i]
        -- 匹配函数定义行（简化版正则表达式）

        -- case 1
        -- 仅仅返回函数名称
        -- 举例:
        --   DWORD VDSViewer::ConnectTranThread(int i, int j)
        --   match 为 ConnectTranThread
        -- local match = line_content:match("([%w_]+)%s*%(.*")

        -- case 2
        -- 返回函数名称及后面的所有内容
        -- 举例:
        --   DWORD VDSViewer::ConnectTranThread(int i, int j)
        --   match 为 ConnectTranThread(int i, int j)
        local match = line_content:match("[%w_]+%s*%(.*")
        if match then
            -- case 1
            -- 获取函数名称匹配的类容
            -- 举例:
            --   DWORD VDSViewer::ConnectTranThread()
            --   match 为 ConnectTranThread()
            -- function_name = match

            -- case 2
            -- 返回函数名称所在行(全部内容)
            -- 举例:
            --   DWORD VDSViewer::ConnectTranThread()
            --   line_content 为 DWORD VDSViewer::ConnectTranThread()
            function_name = line_content
            -- print(string.format("function_name(%s)", function_name))
            break
        end
    end

    -- 查找函数的结束位置（向前查找第一个 '}'）
    local end_line = current_line
    while end_line < #lines do
        -- local line_content = lines[end_line + 1]
        local line_content = lines[end_line]
        -- 注: gmatch 会导致结果不正确
        -- if line_content:gmatch("^%}%s*") then
        if line_content:match("^%}%s*") then
            -- print(string.format("end_line(%d), #lines(%d), line_content(%s)", end_line, #lines, line_content))
            break
        end
        end_line = end_line + 1
    end

    -- 检查是否找到了函数的结束位置
    if end_line >= #lines then
        vim.notify("Failed to find the end of the function.", vim.log.levels.WARN)
        return
    end

    -- 计算函数的行数
    local function_lines = end_line - start_line + 1

    local percent = 0
    if current_line >= 0 and function_lines > 0 then
        percent = ((current_line - start_line + 1) * 100) / function_lines;
    end

    -- 显示结果
    -- vim.notify(string.format("Function Name: %s\nFunction Lines: %d\nPercentage: %d\n", function_name, function_lines, percent), vim.log.levels.INFO)
    print(string.format("%s %d %d%%", function_name, function_lines, percent))
end

local function move_to_cxx_function_start()
    -- 获取当前缓冲区的所有行
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    -- 当前光标位置
    local cursor = vim.api.nvim_win_get_cursor(0)
    -- local current_line = cursor[1] - 1 -- 行号从 0 开始
    local current_line = cursor[1] -- 行号从 1 开始

    -- 查找函数的起始位置（向后查找第一个 '{'）
    local start_line = current_line
    while start_line >= 0 do
        local line_content = lines[start_line + 1]
        -- if line_content:match("%f[^%s]}%s*{") then
        local match1 = line_content:match("^%{%s*")
        -- %([%s%w_]*%) 中的 [%s%w_]* 无法匹配所以场景, 如: 
        --    ShutdownXLOG(int code, Datum arg) {
        -- 因此, 目前暂使用 ".*" 来泛匹配吧
        -- local match2 = line_content:match("[%w_]+%s*%([%s%w_]*%)%s*%{")
        local match2 = line_content:match("[%w_]+%s*%(.*%)%s*%{")
        if match1 or match2 then
            if (match2) then
                start_line = start_line + 1
            end
            -- print(string.format("start_line(%d), match1(%s), match2(%s)", start_line, match1, match2))
            break
        end
        start_line = start_line - 1
    end

    -- 检查是否找到了函数的起始位置
    if start_line < 0 then
        vim.notify("Cursor is not inside a function.", vim.log.levels.WARN)
        return
    end

    vim.api.nvim_win_set_cursor(0, {start_line, 0})
end

local function move_to_cxx_function_end()
    -- 获取当前缓冲区的所有行
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    -- 当前光标位置
    local cursor = vim.api.nvim_win_get_cursor(0)
    -- local current_line = cursor[1] - 1 -- 行号从 0 开始
    local current_line = cursor[1] -- 行号从 1 开始

    -- 查找函数的结束位置（向前查找第一个 '}'）
    local end_line = current_line
    while end_line < #lines do
        -- local line_content = lines[end_line + 1]
        local line_content = lines[end_line]
        -- 注: gmatch 会导致结果不正确
        -- if line_content:gmatch("^%}%s*") then
        if line_content:match("^%}%s*") then
            -- print(string.format("end_line(%d), #lines(%d), line_content(%s)", end_line, #lines, line_content))
            break
        end
        end_line = end_line + 1
    end

    -- 检查是否找到了函数的结束位置
    if end_line >= #lines then
        vim.notify("Failed to find the end of the function.", vim.log.levels.WARN)
        return
    end

    vim.api.nvim_win_set_cursor(0, {end_line, 0})
end

-- 将函数绑定到快捷键（例如 <Leader>cf）
vim.keymap.set("n", "<Leader>fs", get_current_function_info, { desc = "Get current function name and line count" })
vim.keymap.set("n", "<Leader>fH", move_to_cxx_function_start, { desc = "Move to cxx function start" })
vim.keymap.set("n", "<Leader>fL", move_to_cxx_function_end, { desc = "Move to cxx function end" })
