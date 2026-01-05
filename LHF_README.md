Normal 下按下 Ctrl + /, 可以在 nvim 中临时打开 terminal, 感觉很方便.

Normal 按下(大写) K, 可以 Hover 显示当前定义(如: enum 成员的值等)


## lsp cmake

最新版本中, lsp cmake 使用会报错: 

```
lazyvim 中我打开 CMakeLists.txt 后 lsp 报错:
[START][2026-01-05 10:39:55] LSP logging initiated
[ERROR][2026-01-05 10:39:55] ...p/_transport.lua:36 "rpc"   "cmake-language-server" "stderr"    "Traceback (most recent call last):\n"
[ERROR][2026-01-05 10:39:55] ...p/_transport.lua:36 "rpc"   "cmake-language-server" "stderr"    "  File \"/home/haifeng/.local/share/nvim/mason/bin/cmake-language-server\", line 5, in <module>\n
from cmake_language_server.server import main\n  File \"/home/haifeng/.local/share/nvim/mason/packages/cmake-language-server/venv/lib64/python3.13/site-packages/cmake_language_server/server.py\", line
34, in <module>\n    from pygls.server import LanguageServer\nImportError: cannot import name 'LanguageServer' from 'pygls.server' (/home/haifeng/.local/share/nvim/mason/packages/cmake-language-server/
venv/lib64/python3.13/site-packages/pygls/server.py)\n"
   /…/nvim/lsp.log                                                                                                                                  8  utf-8     bigfile  Bot 64734:596  64734

```

具体
```
ImportError: cannot import name 'LanguageServer' from 'pygls.server'
```

原因: 说明 cmake-language-server 依赖的 pygls 包版本和它自身的代码不匹配。新版本的 pygls 把 LanguageServer 移动或改名了，而 cmake-language-server 还在用旧的写法。

解决:
  在 LazyVim 中，cmake-language-server 是早期的 Python 实现，依赖 pygls，维护较少且容易出现兼容问题；而 neocmake 是一个新的 Rust 实现的 CMake LSP，性能更好、维护更积极，也是 LazyVim 默认推荐的选择.
