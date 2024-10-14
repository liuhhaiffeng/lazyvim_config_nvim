-- https://teukka.tech/vimtip-gitlens.html
-- in utils.lua
local M = {}
local api = vim.api
function M.blameVirtText()
  local ft = vim.fn.expand('%:h:t') -- get the current file extension
  if ft == '' then -- if we are in a scratch buffer or unknown filetype
    return
  end
  if ft == 'bin' then -- if we are in nvim's terminal window
    return
  end
  api.nvim_buf_clear_namespace(0, 2, 0, -1) -- clear out virtual text from namespace 2 (the namespace we will set later)
  local currFile = vim.fn.expand('%')
  local line = api.nvim_win_get_cursor(0)

  --
  -- 空白行不显示 git blame 信息
  --
  -- 获取整行, 第 3 个参数 0 表示从列首开始, 第 5 个参数 -1 表示到行尾
  local line_text = api.nvim_buf_get_text(0, line[1]-1, 0, line[1]-1, -1, {})
  -- print(line_text[1], string.len(line_text[1]))   -- 打印调试
  -- gsub(xx) 将 line_text trim 后, 如果长度为 0, 说明是空白行
  if string.len(string.gsub(line_text[1], "%s+", "")) == 0 then
      return
  end


  local blame = vim.fn.system(string.format('git blame -c -L %d,%d %s', line[1], line[1], currFile))
  -- lhf add
  -- local blame = vim.fn.system(string.format('git blame -cw -L %d,%d %s', line[1], line[1], currFile))
  local hash = vim.split(blame, '%s')[1]
  -- local cmd = string.format("git show %s ", hash).."--format='%an | %ar | %s'"
  -- lhf modify
    -- 说明: git 大项目中, 我本机测试 git show 不增加 -s 时会输出 所有代码改动信息, 此会导致 此命令执行耗时,
    -- 最终导致移动光标时, git blame 很卡, 几乎没法使用, 经过研究, 发现增加 -s 后仅输出提交信息, 不卡了
    -- -s 作用参考:
    --   https://geek-docs.com/git/git-questions/260_git_what_does_git_show_do_all_by_itself.html
  -- git show 02c0906949c4 --format='%an | %ar | %s'
  -- git show 02c0906949c4 -s --format='%an | %ar | %s'
  local cmd = string.format("git show %s ", hash).."-s --format='%an | %ar | %s'"
  local text = ''
  if hash == '00000000' then
    -- lhf 未提交的不显示, 以便于"代码复制(时不包含 blame vitual text)"
    -- text = 'Not Committed Yet'
    text = ''
  else
    text = vim.fn.system(cmd)
    text = vim.split(text, '\n')[1]

    -- text = blame
    -- text = vim.split(text, ')')[1] .. ')'
    if text:find("fatal") then -- if the call to git show fails
      -- lhf 未提交的不显示, 以便于"代码复制(时不包含 blame vitual text)"
      -- text = 'Not Committed Yet'
      text = ''
    end
  end

  -- lhf 注: git blame 显示在当前行很方便, 但在复制代码时也会将 blame 信息一并复制, 
  --         故暂时将枪放到状态栏下面显示
  if true then
        if string.len(text) > 0 then
            text  = '    ' .. text
        end
        api.nvim_buf_set_virtual_text(0, 2, line[1] - 1, {{ text,'GitLens' }}, {}) -- set virtual text for namespace 2 with the content from git and assign it to the higlight group 'GitLens'
  else
      print(text)
  end
end
function M.clearBlameVirtText() -- important for clearing out the text when our cursor moves
  api.nvim_buf_clear_namespace(0, 2, 0, -1)
end
return M
