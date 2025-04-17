-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Set color scheme in Neovim (Lua)
-- https://darryldias.me/2023/set-color-scheme-in-neovim-lua/
-- vim.cmd([[colorscheme tokyonight-storm]])
-- vim.cmd([[colorscheme torte]])
vim.cmd([[colorscheme gruvbox]])

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

-- # 参考： http://blog.itpub.net/267265/viewspace-2214837/
-- # 键入命令时，可以模糊匹配，有时候比 Ctrl-D 方便一些，使用 Tab和 Shift-Tab来进行选择
-- set wildmenu
-- # 此配置可以自动触发类似 Ctrl-D 预览的功能，这时候按下 Tab 键，就可以自动选择了
-- set wildmode=longest:list,full
-- lhf note: lazyvim 当前最新版, 命令补全预览窗口是"垂直的,并且还需要手动 ctrl-p/n 上线滚动",
--           不够直观, 下面的设置, 可以尽可能将补全内容全部展示出来, 更加好用
vim.cmd("set wildmenu")
vim.cmd("set wildmode=longest:list,full")

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
--
-- 详细说明: 使用此 git blame 脚本时, 缺失会导致上下移动卡顿, ps 查看进程, 发现
--           其会远程连接 github, 而国内 github 访问很卡或者根本无法访问, 由此
--           就导致的卡顿
--   \_ nvim comments.lua config.lua init.lua
--      \_ nvim --embed comments.lua config.lua init.lua
--            \_ /usr/libexec/git-core/git remote-https origin https://github.com/folke/ts-comments.nvim.git
--                \_ /usr/libexec/git-core/git-remote-https origin https://github.com/folke/ts-comments.nvim.git
--
--  原因分析: git_blame_utils.lua 逻辑导致, 其在获取本地 git blame 时, 可能触发了向 remote 获取信息的联网行为,
--            由此导致了卡顿
--
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

local function is_fake_func_name(line)
    -- 过滤 伪函数名称, 如:
    -- if ()
    -- else ()
    -- while ()
    -- do ()
    -- std::thread([this]() { })
    local fake_func_names = {
        "if",
        "else",
        "switch",
        "case",
        "default",
        "for",
        "while",
        "do",
        "break",
        "continue",
        "goto",
        "thread",
    }

    local is_fake = false
    for _, str in ipairs(fake_func_names) do
        if str == line then
            is_fake = true
            break
        end
    end

    return is_fake
end

local function is_fake_func_para(para)
    -- 过滤 伪函数参数, 如:
    --
    -- case1:
    -- std::thread([this]() { 
    -- })
    --  例外: int main(int argc, char *argv[]) {
    -- 解决: 对于 thread([]) 情况, 在上述 is_fake_func_name() 中通过 thread 关键词已经
    --       过滤, 这里就去除 [ 和 ], 避免误判 char *argv[] 这种情况
    --
    -- 违例, 需要注释:
    -- "%[",    -- 正则匹配时, 对于 [ ]  关键词, 需要使用 % 进行转义
    -- 违例, 需要注释:
    -- "%]",
    --
    -- case2:
    -- FB_UPDATE_PENDING(cl) && !sraRgnEmpty(cl->requestedRegion)) {
    --   说明: 上述表达式匹配到的 () 中的参数为:  cl) && !sraRgnEmpty(cl->requestedRegion)
    --         因此, 里面的 ! -> 可作为过滤项目, 另外再增加一个 . 号(即: cl.requestedRegion)
    --
    --  TODO: 
    --  虽然下面列举了如此多的场景, 但 C++ 函数默认参数一出场, 就将好多破掉了, 举例:
    --  void func(bool i = (j == 5 ? false : true))
    --  void func(bool i = ( j & k ?) false : true))
    --  void func(bool i = (j >= 0 ?) false : true))
    --  void func(book i = ( (j << 2) != 0 ?) false : true))
    --  ....
    --  感觉, C++ 的默认参数几乎可以将下面过滤规则给破掉, 但是有如下乐观想法:
    --    1. C++ 上述默认参数一般在 "声明"中, 不体现在定义中
    --    2. 这样的情况毕竟少数吧, 暂时不管了
    local fake_func_paras = {
        "!",     -- 注: 测试发现 !  和  %! 均能生效
        "%->",    -- 注: 测试发现 -> 和 %-> 均能生效
        "%.",    -- 函数参数中不应该有 . 号
        "%+",     -- 函数参数中不应该有 + 号吧?
        "<=",    -- <= 不应该有
        ">=",    -- >= 不应该有
        "||",
        "&&",
        "==",    -- 函数参数中不应该有 == 号 (注: 单个 = 是有可能的, 如 C++ 参数默认值)
        "!=", "%+=", "%-=", "%*=", "/=", "%%=",
        "&", "|", "%^", "~", "<<",   --  < >, >> 可能有, 例如: std::vector<std::vector<int>>
        "%?", ";", "{", "}",
    }

    local is_fake = false
    for _, str in ipairs(fake_func_paras) do
        local match = para:match(str)
        if match then
            is_fake = true
            break
        end
    end

    return is_fake
end

local function get_start_line(lines, current_line)
    -- 查找函数的起始位置（向上查找第一个 '{'）
    local start_line = current_line
    while start_line > 0 do
        local line_content = lines[start_line]
        -- if line_content:match("%f[^%s]}%s*{") then
        local match1 = line_content:match("^%{%s*")
        -- %([%s%w_]*%) 中的 [%s%w_]* 无法匹配所以场景, 如: 
        --    ShutdownXLOG(int code, Datum arg) {
            -- 因此, 目前暂使用 ".*" 来泛匹配吧
            -- local match2 = line_content:match("[%w_]+%s*%([%s%w_]*%)%s*%{")
            -- local match2 = line_content:match("[%w_]+%s*%(.*%)%s*%{")
            -- 匹配, 并且 match2 仅仅获取小括号() 的匹配内容
            local match2 = line_content:match("([%w_]+)%s*%(.*%)%s*%{")
            local match2_func_para = line_content:match("[%w_]+%s*%((.*)%)%s*%{")
            -- print("para = ", para, "match2 = ", match2)
            if match1 or match2 then
                if (match2) then
                    if is_fake_func_name(match2) or is_fake_func_para(match2_func_para) then
                        goto fake_continue
                    end
                end
                -- print(string.format("start_line(%d), match1(%s), match2(%s)", start_line, match1, match2))
                break
            end

            ::fake_continue::
            start_line = start_line - 1
        end

        -- 检查是否找到了函数的起始位置
        if start_line <= 0 then
            vim.notify("Cursor is not inside a function.", vim.log.levels.WARN)
            return
        end

        return start_line
end

local function get_end_line(lines, current_line)
    -- 查找函数的结束位置（向前查找第一个 '}'）
    local end_line = current_line
    while end_line <= #lines do
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

    -- print(string.format("end_line(%d), #lines(%d)", end_line, #lines))
    -- 检查是否找到了函数的结束位置
    -- if end_line >= #lines then
    -- 函数最后的 } 有可能就是最后一行, 因此去除 >= 中的 "等于"
    -- 注: 当然, 这里的前提是"当前函数以 1 开头, 而非 0"
    if end_line > #lines then
        vim.notify("Failed to find the end of the function.", vim.log.levels.WARN)
        return
    end

    return end_line
end

local function get_current_function_info()
    -- 获取当前缓冲区的所有行
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    -- 当前光标位置                                 
    local cursor = vim.api.nvim_win_get_cursor(0)
    local current_line = cursor[1] -- 行号从 1 开始

    local start_line = get_start_line(lines, current_line)
    if not start_line then
        return
    end

    local end_line = get_end_line(lines, current_line)
    if not end_line then
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

    -- 计算函数的行数
    local function_lines = end_line - start_line + 1

    local percent = 0
    if current_line >= 0 and function_lines > 0 then
        percent = ((current_line - start_line + 1) * 100) / function_lines;
    end

    -- 显示结果
    -- vim.notify(string.format("Function Name: %s\nFunction Lines: %d\nPercentage: %d\n", function_name, function_lines, percent), vim.log.levels.INFO)
    print(string.format("%s %d %d%% (start_line %d)", function_name, function_lines, percent, start_line))
end

local function move_to_cxx_function_start()
    -- 获取当前缓冲区的所有行
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    -- 当前光标位置                                 
    local cursor = vim.api.nvim_win_get_cursor(0)
    local current_line = cursor[1] -- 行号从 1 开始

    local start_line = get_start_line(lines, current_line)
    if not start_line then
        return
    end

    vim.api.nvim_win_set_cursor(0, {start_line, 0})
end

local function move_to_cxx_function_end()
    -- 获取当前缓冲区的所有行
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    -- 当前光标位置                                 
    local cursor = vim.api.nvim_win_get_cursor(0)
    local current_line = cursor[1] -- 行号从 1 开始

    local end_line = get_end_line(lines, current_line)
    if not end_line then
        return
    end

    vim.api.nvim_win_set_cursor(0, {end_line, 0})
end

-- 将函数绑定到快捷键（例如 <Leader>cf）
vim.keymap.set("n", "<Leader>fs", get_current_function_info, { desc = "Get current function name and line count" })
vim.keymap.set("n", "<Leader>fH", move_to_cxx_function_start, { desc = "Move to cxx function start" })
vim.keymap.set("n", "<Leader>fL", move_to_cxx_function_end, { desc = "Move to cxx function end" })


-- neovim 中如果当前是注释行时, 新建下一行, 会自动补全 注释符号, 如何禁止此功能
--
-- 在 Neovim 里，当处于注释行时新建下一行会自动补全注释符号，
-- 这通常是由 formatoptions 选项中的 c、r 和 o 标志控制的。
-- 下面为你介绍几种禁止该功能的方
-- vim.opt.formatoptions:remove({ 'c', 'r', 'o' })
-- vim.cmd("set formatoptions-=cro")
-- vim.opt_local.formatoptions:remove({ 'r', 'o' })

-- 上面设置不生效, 原因未知
-- 下面如此设置 OK, 生效了
-- https://neovim.discourse.group/t/how-do-i-prevent-neovim-commenting-out-next-line-after-a-comment-line/3711/5
-- I did what voyeg3r did but I had to do it like this in my ~/.config/nvim/lua/vim-options.lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ 'r', 'o' })
  end,
})
