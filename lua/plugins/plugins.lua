-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
-- if true then return {} end

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you an:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
    { 'easymotion/vim-easymotion' },

    -- 在nvim中执行 nvim 或 shell 命令时, 我不喜欢 popup 弹出式的方式, 我觉得它
    -- 目前还存在一些问题, 如:
    -- 1. 执行 nvim 命令  : verbose map gd , 展示的结果, 过几秒中popup窗口就自动
    --    关闭了, 而我希望能永久停留, 直到我执行任意操作(如: 按下 enter)后再消失
    -- 2. vim 中 :!git log 即执行外部命令时, 可以进行交互, 而 cmdline 和 popup
    --    窗口只能接收"outpu结果", 不能像 vim 那样, 可以进行 类似 "more"那样的
    --    交互操作
    -- 3. 注: 使用下面方法将 nvim 还原到以前的方式后, 执行 :!git log 发现 nvim
    --        相比 vim 还是存在一点缺陷, 众所周知, 执行 git log, 其输出结果可能
    --        很多, vim 中, 执行 :!git log 默认是 :!git log|more 或 :!git log|less
    --        而 nvim 中, 会傻傻的将 git log 全部输出出来, 结果导致很卡顿.
    --    解决: 在 nvim 中执行的 shell 命令若结果很多时, 应该应该这些执行:
    --          :!xx|more  或 :!xx|less
    -- 4. 注2: 实测 nvime -u NONE 下, 执行 :git log|more 或 :!git log|less 还是
    --         不起作用, 仍然会尝试将 git log 所有记录output完, 由此导致很卡顿,
    --         找到了解决, 这说明此问题是 nvim 本身的一个 bug.
    --    解决: git log -n 展示前n条(注: 是前 n commit 条数), git log --stat -n
    --          也要如此
    -- https://github.com/LazyVim/LazyVim/discussions/1275
    {
        "folke/noice.nvim",
        opts = {
            cmdline = { enabled = false, },
            messages = { enabled = false, },
        },
    },

    -- how to show file encoding in statusbar
    --  https://github.com/LazyVim/LazyVim/discussions/672
  {
    "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
  --           -- 参考:
  --           -- 1. https://github.com/nanotee/nvim-lua-guide
  --           --
  --           -- local result = vim.api.nvim_exec(
  --           --     [[
  --           -- fun! ShowFuncName()
  --           --     let lnum = line(".")
  --           --     let col = col(".")
  --           --     echohl ModeMsg
  --           --     echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  --           --     echohl None
  --           --     call search("\\%" . lnum . "l" . "\\%" . col . "c")
  --           -- endfun
  --           --
  --           -- call ShowFuncName()
  --           -- ]],
  --           --     true)
  --           --
  --           -- 2. :h lualine
  --           --
  --           -- lualine ex:
  --           -- local function hello()
  --           --     return [[hello world]]
  --           -- end
  --           -- sections = { lualine_a = { hello } }
  --
  --           local function MyShowFuncName()
  --               -- local result = "hehe"				  
  --               local result = vim.api.nvim_exec(
  --                   [[
  --                 function! s:ShowFuncName()
  --                     let s:lnum = line(".")
  --                     let s:col = col(".")
  --                     echohl ModeMsg
  --                     echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  --                     echohl None
  --                     call search("\\%" . s:lnum . "l" . "\\%" . s:col . "c")
  --                 endfunction
  --
  --                 call s:ShowFuncName()
  --
  --                 ]], true)
  --               return result
  --           end
  --
  --     table.insert(opts.sections.lualine_c, { MyShowFuncName })
        table.insert(opts.sections.lualine_x, "encoding")
        table.insert(opts.sections.lualine_x, "fileformat")
        table.insert(opts.sections.lualine_x, "filetype")
        table.insert(opts.sections.lualine_y, "%L")   -- 显示总行数
        table.insert(opts.sections.lualine_y, "selectioncount")
        -- table.insert(opts.sections.lualine_y, "diagnostics")    -- 左侧默认已经有了，这里就不冗余添加了
        table.remove(opts.sections.lualine_z)  -- 去除 时间显示

        -- 某些场景下，我需要显示 full path， 通过此设定
        -- 参考：https://github.com/LazyVim/LazyVim/discussions/3010
        -- 参考2： ~/.local/share/nvim/lazy/lualine.nvim/doc/lualine.txt 736
        -- table.insert(opts.sections.lualine_c, {
        --     "filename",
        --     path = 3,
        -- })
  end,
  },

    -- nvim 按下 / 进行搜索时, 若输入 cx 或 clang 等字符时, 会导致输入中断, 
    -- 自动终止搜索输入, 网上查了一下, 是 flash.nvim 插件导致的
    -- https://github.com/LazyVim/LazyVim/issues/1862
    --
    -- 解决两种方案:
    --  1. 禁止此插件的使用
    --  2. 如下, 按下 / 后, 先 <C-s> 关闭此插件, 然后再输入就OK了
    -- Edit: or you can also press <C-s> after you type / to temporarily disable 
    -- the labels that take you to the word that you want to type.
    --
    -- 注: 上述问题解决后, 又发现问题: normal 模式下按下 s, 发现不是期望的, 而是
    --     flash.nvim 的 easymotion, 于是又额外添加了 enabled = false, 干脆将此
    --     插件禁止算了, 反正现在我还用不惯, 并且我已经配置了自己的 "easymotion"
    --     插件了
    --     说明: 我不喜欢 flash.nvim 这种自作主张将 vim 默认按键给覆盖了的做法,
    --           我喜欢 <leader>xx 的方式
    --
    --     Disabling Plugins 参考如下: https://www.lazyvim.org/configuration/plugins
    {
        "folke/flash.nvim",
        enabled = false,
        opts = {
            modes = {
                search = {
                    enabled = false,
                },
            },
        },
    },


    -- lazyvim 默认是 enter 选中补全, 我习惯 tab 进行自动补全选中, 在网上查了一下,
    -- 作者也发现 enter 不好, 下面是按作者设置更改的, 使用 tab 进行补全.
    -- https://github.com/LazyVim/LazyVim/discussions/39
    -- Use <tab> for completion and snippets (supertab)
    -- first: disable default <tab> and <s-tab> behavior in LuaSnip
    {
        "L3MON4D3/LuaSnip",
        keys = function()
            return {}
        end,
    },
    -- then: setup supertab in cmp
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-emoji",
        },
        ---@param opts cmp.ConfigSchema
        opts = function(_, opts)
            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local luasnip = require("luasnip")
            local cmp = require("cmp")

            -- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            -- This solution works almost perfect but with only one catch. 
            -- The first time you tap , it didnt insert with the first item in 
            -- completion list. It skip and insert the second item.
            -- cmp.PreselectMode.None 的含义请查帮助： :h cmp-config.preselect
            --
            -- lhf 注：实测， opts.preselect = cmp.PreselectMode.None 好像没有
            --        作用，真正发挥作用的是 opts.completion, 并且在网上查找
            --        有下面几种设置： menu, menuone, noselect 具体意思不清楚，
            --        以后再慢慢解决
            -- opts.preselect = cmp.PreselectMode.None
            opts.completion = {
                -- completeopt = "noselect",
                -- completeopt = "menuone,noselect",
                completeopt = "menu,menuone,noselect"
            }
            -- ---------------------------------------------------------------

            opts.mapping = vim.tbl_extend("force", opts.mapping, {
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                        -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                        -- they way you will only jump inside the snippet region
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            })
        end,
    },


    -- lhf 注： 上面是支持 tab 选择的， 如果不需要 tab 选择， 可以将上面禁掉，
    --          而仅仅使用下面的设置
    -- make nvim-cmp not autoselect the 1st option
    -- https://github.com/NvChad/NvChad/issues/1917
    -- {
    --     "hrsh7th/nvim-cmp",
    --     opts = {
    --         completion = {
    --             completeopt = "menuone,noselect",
    --         },
    --     },
    -- },


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
    -- vim.g.autoformat = false


    -- How can I toggle show/hide whitespace and indentation lines
    -- https://github.com/LazyVim/LazyVim/discussions/341
    -- lhf: 安装上述网页说明, "lukas-reineke/indent-blankline.nvim", 的 opts 配置
    --      提示有错误, 因此, 暂时直接将下面两个插件功能给禁止了
    -- +++++++++++++++++++++++++++++++++++++++++++++++++++++++
    {
        "lukas-reineke/indent-blankline.nvim",
        enabled = false,
    },

    {
        "echasnovski/mini.indentscope",
        enabled = false,
    },
    -- ------------------------------------------------------

    {
        "zivyangll/git-blame.vim",
        enabled = true,
    },

    -- {
    --     "gou4shi1/git-lens.vim",
    --     enabled = false,
    -- },

    -- {
    --     -- nvim 不支持 vim9script 的插件, 暂时禁止
    --     "Eliot00/git-lens.vim",
    --     enabled = true,
    -- },

    {
        -- https://github.com/fredrikaverpil/dotfiles/blob/ee04215d632f7c91287031af41497bae98d63dd8/nvim-lazyvim/lua/plugins/telescope.lua#L43-L54
        "nvim-telescope/telescope.nvim",
        -- opts will be merged with the parent spec
        opts = {
            defaults = {
                -- lhf 注: 忽略 *.xx 一类文件要写成 !*.xx 才能生效
                file_ignore_patterns = { ".git/", "tags", "!*.taghl", "build.log", "compile_commands.json", ".cache/" },
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--hidden",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                    "--trim",
                },
                layout_config = {
                    -- lhf 注: 目前不知道 picker result_win 如何 wrap, 只能采用
                    -- 此方法尽可能将 picker win 增大
                    -- 解决: ~/.local/share/nvim/lazy/telescope.nvim/README.md" 254 lines
                    --       normal mode 下:
                    --       <C-f>        | Scroll left in preview window    
                    --       <C-k>        | Scroll right in preview window   
                    --       <M-f>        | Scroll left in results window    
                    --       <M-k>        | Scroll right in results window
                    -- width = function(_, max_columns, _)
                    -- return math.min(max_columns, 1920)
                    -- end,
                    -- height = function(_, _, max_lines)
                    -- return math.min(max_lines, 1080)
                    -- end,
                },
                -- wrap_results = true,
            },
        },
    },

    -- {
    --     "nvim-telescope/telescope-symbols.nvim",
    -- },

    {
      "folke/trouble.nvim",
      opts = {}, -- for default options, refer to the configuration section for custom setup.
      cmd = "Trouble",
      keys = {
        -- {
        --   "<leader>xx",
        --   "<cmd>Trouble diagnostics toggle<cr>",
        --   desc = "Diagnostics (Trouble)",
        -- },
        -- {
        --   "<leader>xX",
        --   "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        --   desc = "Buffer Diagnostics (Trouble)",
        -- },
        {
          "<leader>cs",
          "<cmd>Trouble symbols toggle focus=false win.position=bottom<cr>",
          desc = "Symbols (Trouble)",
        },
        {
          "<leader>cS",
          "<cmd>Trouble lsp toggle focus=false win.position=bottom<cr>",
          desc = "LSP references/definitions/... (Trouble)",
        },
        -- {
        --   "<leader>xL",
        --   "<cmd>Trouble loclist toggle<cr>",
        --   desc = "Location List (Trouble)",
        -- },
        -- {
        --   "<leader>xQ",
        --   "<cmd>Trouble qflist toggle<cr>",
        --   desc = "Quickfix List (Trouble)",
        -- },
      },
    },

    -- lhf: 
    --    ~/.config/nvim/lua/config/options.lua
    --    vim.g.autoformat = false
    --
    --    vim 也有一个 autoformat 不知道这二者有何区别, 反正都设置为 false 了
    --
    --    https://vi.stackexchange.com/questions/42597/how-to-disable-autoformating-on-save-on-lazyvim
  {
    "neovim/nvim-lspconfig",
    opts = {
      autoformat = false,
      -- easymotion 时，clangd diagnostics 会大片显示出来，很烦，暂禁止
      -- 参考： /home/haifeng/.local/share/nvim/lazy/LazyVim/lua/lazyvim/util/extras.lua 217
      diagnostics = {
          virtual_text = false,
          signs = false,
          underline = false,
      },
      -- CXX 下不习惯 inlay_hints， 禁止掉
      inlay_hints = { enabled = false },
    },
    init = function()
        local keys = require("lazyvim.plugins.lsp.keymaps").get()
        -- lsp.keymaps 增加 items 示例
        -- keys[#keys + 1] = { "[[", vim.diagnostic.open_float, mode = "n" }
        -- keys[#keys + 1] = { "]]", vim.diagnostic.open_float, mode = "n" }
        
        -- 删除插件中对下面 按键 绑定, 使之恢复到默认的行为
        local keysToRemove = { "[[", "]]" }
        for i = #keys, 1, -1 do
            local value = keys[i][1]
            for _, str in ipairs(keysToRemove) do
                if value == str then
                    table.remove(keys, i)
                    break
                end
            end
        end
    end,
  },

    -- cxx 文件中, 下面的 else 后单独一行的大括号使用 == 无法自动对齐, 发现此为
    -- nvim-treesitter 插件导致, 因此将其 indent 禁止, 使用 nvim 原生( nvim -u None)
    -- 的对齐配置
    --      if (1)
    --      {
    --
    --      }
    --      else
    --  {
    --
    --      }
    --
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            -- 全部禁止
            indent = { enable = false },
            -- 禁止指定类型(如: cxx 系列)
            -- indent = { disable = { "c", "cpp", "cxx", "C", "objc", "duda", "proto", "h", "hpp", "hxx" } },
        },
    },

    -- lazyvim find file 目前默认使用 snacks, 暂将 fzf 禁止掉
    -- 注意： 以后可能会用到，因此不要在 Lazyvim 界面中将其 插件 给 cleanup 掉
    -- 注意2: fzf 等 picker 的启用, 还需要额外设置, 比如我在 options.lua 
    --        中需要显示设置, 才能生效
    --        vim.g.lazyvim_picker = "fzf" 
    {
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = { "nvim-tree/nvim-web-devicons" },
        -- FZF: How to change the layout to horizontal?
        -- https://github.com/LazyVim/LazyVim/discussions/3815
        opts = function(_, opts)
            opts.winopts = {
                preview = {
                    vertical = "up:65%",
                    layout = "vertical",
                    hidden = "nohidden"
                },
            }
        end,
        -- 上面 opts 重复配置了, 下面的 config 就冗余了, 暂禁止
        -- config = function()
        --     -- calling `setup` is optional for customization
        --     -- require("fzf-lua").setup({})
        --     require("fzf-lua").complete_file({
        --         -- cmd = "rg --files",
        --         winopts = { preview = { hidden = "nohidden" } }
        --     })
        -- end
    },
    
    -- lazyVim 之前使用 nvim-cmp 来自动补全，更新后使用 blink.cmp， 后者默认使用
    -- enter 进行补全，使用不习惯，修改为 tab 上下选择和确认补全
    -- https://github.com/LazyVim/LazyVim/discussions/5152
    --
    -- blink.cmp as nvim-cmp’s alternative #4679
    -- https://github.com/LazyVim/LazyVim/discussions/4679
    {
        "Saghen/blink.cmp",
        opts = {
            keymap = {
                -- preset = "enter",
                preset = "super-tab",
                ["<Tab>"] = { "select_next", "fallback" },
                ["<S-Tab>"] = { "select_prev", "fallback" },
                ['<C-y>'] = { 'select_and_accept' },


                -- ~/.local/share/nvim/lazy/blink.cmp/lua/blink/cmp/keymap/presets.lua" 72
                -- TODO::有空可以研究一下下面的原理
                -- ['<Tab>'] = {
                --     function(cmp)
                --         if cmp.snippet_active() then
                --             return cmp.accept()
                --         else
                --             return cmp.select_and_accept()
                --         end
                --     end,
                --     'snippet_forward',
                --     'fallback',
                -- },
                -- ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
            },
            -- maybe optional 
            -- blink.cmp 升级后，再次 nv 打开文件时报错：
            --   blink.cmp utils.lua:28: completion.list.   selection: expected table, got string
            -- 原因是这里对应的配置也要同步修改如下：
            -- https://github.com/Saghen/blink.cmp/issues/948
            -- completion = { list = { selection = "auto_insert" } },
            completion = { 
                -- list = { selection = { preselect = true, auto_insert = true } },
                list = { selection = { preselect = false, auto_insert = true } },

                -- https://cmp.saghen.dev/configuration/general.html
                -- Disable auto brackets
                -- NOTE: some LSPs may add auto brackets themselves anyway
                accept = { auto_brackets = { enabled = false }, },
            },

        },
    },

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            -- 查看帮助 :h snacks-picker
            picker = {
                -- live = false,
                -- layout = { fullscreen = true },
                -- grep = { live = false },
                -- lsp = { symbols = { live = false, }, },
                layout = {
                    box = "horizontal", 
                    cycle = true,
                    preset = function()
                        -- return vim.o.columns >= 120 and "default" or "vertical"
                        return "horizontal"
                    end,
                },
            },

            -- It's a good idea to run :checkhealth snacks to see if everything is set up correctly.
            bigfile = { enabled = true },
            dashboard = { enabled = true },
            explorer = { enabled = true },
            indent = { enabled = false },
            input = { enabled = true },
            picker = { enabled = true },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            scope = { enabled = true },
            -- 打开 man(k, kzz) 功能后, 再加上 lazyvim 的 smooth scroll 开启后,
            -- 连续 k 或 j 滚动, lazyvim 就会很卡, 因此暂时将 smooth scroll 功能
            -- 关闭
            -- https://github.com/LazyVim/LazyVim/discussions/5073
            scroll = { enabled = false },
            statuscolumn = { enabled = true },
            words = { enabled = true },
            terminal = { auto_insert = false },
        },
    },

    {
        "echasnovski/mini.pairs",
        -- 参考： h mini.pars 中
        -- MiniPairs.config = {
        --     -- In which modes mappings from this `config` should be created
        --     modes = { insert = true, command = false, terminal = false },
        --  目的：命令模式下（如：输入命令时，“/” 搜索时，不需要“画蛇添足”的括号自动匹配
        opts = {
            -- In which modes mappings from this `config` should be created
            modes = { insert = true, command = false, terminal = false },
        }
    },

    {
        "folke/ts-comments.nvim",
        event = "VeryLazy",
        opts = {
            lang = {
                c = "/* %s */",
                cpp = "/* %s */"
            },
        },
    },

    -- {
    --     "Yggdroot/LeaderF",
    --     config = function()
    --         -- 取消默认快捷键映射
    --         local function unmap_leaderf_shortcuts()
    --             -- 方法1  实测不生效, 原因未知
    --             -- vim.g.Lf_ShortcutF = ''
    --             -- vim.g.Lf_ShortcutB = ''
    --
    --             -- 方法2
    --             vim.keymap.del("n", "<leader>f")
    --             vim.keymap.del("n", "<leader>b")
    --         end
    --         unmap_leaderf_shortcuts()
    --     end,
    -- },

    {
        "vim-scripts/TagHighlight",
    },

    -- {
    --     "LazyVim/LazyVim",
    --     opts = {
    --
    --     },
    --     keys = {
    --     { "]]", function() Snacks.words.jump(vim.v.count1) end,  desc = "Next Reference xx" },
    --     { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference"  },
    --     -- { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference xx", mode = { "n", "t" } },
    --     -- { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    --     },
    -- },
    
    {
        "folke/which-key.nvim",
        opts = {
            -- Which-key layout changed after latest update #5159
            -- https://github.com/LazyVim/LazyVim/discussions/5159
            preset = "classic",
        },
        win = {
            height = { min = 4, max = 25 },
            border = "none",
        },
    },

}
