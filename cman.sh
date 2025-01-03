#!/bin/bash

# 设置中文手册页的位置
MAN_ZH_PATH="/usr/local/share/man/man_zhcn"
echo "$MAN_ZH_PATH"

# 检查是否提供了参数
if [ $# -eq 0 ]; then
    echo "Usage: $0 command"
    exit 1
fi

# 获取命令名称
CMD=$1

# 查找中文手册页
ZH_MAN_PAGE=$(find "$MAN_ZH_PATH" -name "$CMD.*" | head -n 1)

if [ -n "$ZH_MAN_PAGE" ]; then
    # 如果找到了中文手册页，就使用它
    MANPATH="$MAN_ZH_PATH" man -M "$MAN_ZH_PATH" "$CMD"
else
    # 如果没有找到中文手册页，可以选择回退到英文手册或给出提示
    #echo "No Chinese manual entry for $CMD"
    # 或者调用默认的man命令
    man "$CMD"
fi