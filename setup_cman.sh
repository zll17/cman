#!/bin/bash

#!/bin/bash

# 定义源文件和目标路径
CMAN_SOURCE="./cman.sh"
CMAN_TARGET="/usr/local/bin/cman"
MAN_ZHCN_SOURCE="./man_zhcn"
MAN_ZHCN_TARGET="/usr/local/share/man/manpages_zhcn"

# 检查是否具有root权限
if [ "$EUID" -ne 0 ]; then
  echo "请以root用户或使用sudo运行此脚本。"
  exit 1
fi

# 复制 cman.sh 到 /usr/local/bin 并设置可执行权限
cp "$CMAN_SOURCE" "$CMan_TARGET"
chmod +x "$CMan_TARGET"
echo "已将 $CMAN_SOURCE 复制到 $CMan_TARGET，并设置了可执行权限。"

# 创建目标目录（如果不存在）
if [ ! -d "$MAN_ZHCN_TARGET" ]; then
  mkdir -p "$MAN_ZHCN_TARGET"
  echo "创建了目录: $MAN_ZHCN_TARGET"
fi

# 复制 man_zhcn 目录到 /usr/local/share/man/
cp -r "$MAN_ZHCN_SOURCE"/* "$MAN_ZHCN_TARGET/"
echo "已将 $MAN_ZHCN_SOURCE 内容复制到 $MAN_ZHCN_TARGET"

echo "复制操作已完成。"

# 获取当前用户默认的shell
current_shell=$(basename "$SHELL")

# 定义要添加的别名
alias_command="alias cman=\"/usr/local/bin/cman.sh\""

# 函数：检查并添加别名到指定文件
add_alias_to_file() {
    local file=$1
    # 检查是否已经存在该别名
    if ! grep -qF "$alias_command" "$file"; then
        echo "$alias_command" >> "$file"
        echo "Alias added to $file."
    else
        echo "Alias already exists in $file."
    fi
}

# 根据不同的shell添加别名到对应的配置文件
case $current_shell in
    bash)
        add_alias_to_file "$HOME/.bashrc"
        ;;
    zsh)
        add_alias_to_file "$HOME/.zshrc"
        ;;
    ksh)
        add_alias_to_file "$HOME/.kshrc"
        ;;
    fish)
        # Fish shell uses a different syntax for aliases
        fish_config="$HOME/.config/fish/config.fish"
        alias_fish="abbr --add cman '/usr/local/cman.sh'"
        if ! grep -qF "$alias_fish" "$fish_config"; then
            echo "$alias_fish" >> "$fish_config"
            echo "Alias added to $fish_config."
        else
            echo "Alias already exists in $fish_config."
        fi
        ;;
    *)
        echo "Unsupported shell: $current_shell"
        exit 1
        ;;
esac

#echo "Please restart your shell or source the configuration file to apply changes."
echo "请重启你的 shell 或 source 配置文件 以应用更改。"