#!/bin/bash

# 清理脚本 v1.2.0
# 适用于 Mac M1 环境
# 作者: Claude
# 最后更新: 2024-03

# 设置语言环境为UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 错误处理
set -e
trap 'echo -e "${RED}错误: 脚本执行失败${NC}" >&2' ERR

# 检查是否在项目根目录
if [ ! -f "package.json" ]; then
    echo -e "${RED}错误: 请在项目根目录下运行此脚本${NC}"
    exit 1
fi

# 检查git是否初始化
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}初始化Git仓库...${NC}"
    git init
    git config core.quotepath false # 解决中文文件名显示问题
fi

# 创建Git备份
create_git_backup() {
    echo -e "${GREEN}创建Git备份...${NC}"
    
    # 获取当前时间戳
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    
    # 暂存所有更改
    git add -A
    
    # 创建备份提交
    git commit -m "自动备份 - 清理前 - $TIMESTAMP" || {
        echo -e "${YELLOW}没有需要备份的更改${NC}"
        return 0
    }
    
    echo -e "${GREEN}Git备份完成${NC}"
}

# 主清理函数
main_cleanup() {
    echo -e "${GREEN}开始清理项目...${NC}"
    
    # 1. 删除不需要的文件
    echo "删除无用文件..."
    files_to_remove=(
        "public/next.svg"
        "public/vercel.svg"
        "app/favicon.ico"
        "public/images"
        ".DS_Store"
    )
    
    for file in "${files_to_remove[@]}"; do
        if [ -e "$file" ]; then
            rm -rf "$file"
            echo "已删除: $file"
        fi
    done
    
    # 2. 清理缓存和构建文件
    echo "清理缓存和构建文件..."
    cache_dirs=(
        "node_modules"
        ".next"
        ".turbo"
        "build"
        "dist"
        ".cache"
    )
    
    for dir in "${cache_dirs[@]}"; do
        if [ -d "$dir" ]; then
            rm -rf "$dir"
            echo "已清理: $dir"
        fi
    done
    
    # 3. 清理日志文件
    echo "清理日志文件..."
    find . -type f -name "*.log" -delete
    find . -type f -name "npm-debug.log*" -delete
    find . -type f -name "yarn-debug.log*" -delete
    find . -type f -name "yarn-error.log*" -delete
    find . -type f -name ".pnpm-debug.log*" -delete
    
    # 4. 清理IDE文件但保留cursor配置
    echo "清理IDE文件..."
    if [ -d ".vscode" ]; then
        find .vscode -type f ! -name "settings.json" -delete
    fi
    
    # 5. 清理系统文件
    echo "清理系统文件..."
    find . -type f -name ".DS_Store" -delete
    
    # 6. 检查并修复package.json
    echo "检查package.json..."
    if [ -f "package.json" ]; then
        if ! jq empty package.json 2>/dev/null; then
            echo -e "${RED}警告: package.json 格式有误${NC}"
        fi
    fi
}

# 重新安装依赖函数
reinstall_dependencies() {
    echo -e "${GREEN}重新安装依赖...${NC}"
    # 检查包管理器
    if [ -f "pnpm-lock.yaml" ]; then
        pnpm install
    elif [ -f "yarn.lock" ]; then
        yarn install
    else
        npm install
    fi
}

# 创建清理后的Git提交
create_cleanup_commit() {
    echo -e "${GREEN}记录清理更改...${NC}"
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    git add -A
    git commit -m "项目清理完成 - $TIMESTAMP" || {
        echo -e "${YELLOW}没有需要提交的更改${NC}"
        return 0
    }
}

# 执行清理
echo -e "${YELLOW}准备开始清理...${NC}"
echo -e "${YELLOW}此操作将清理项目中的临时文件和缓存${NC}"
echo -e "${YELLOW}所有更改将通过Git进行备份${NC}"
read -p "是否继续? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    create_git_backup
    main_cleanup
    reinstall_dependencies
    create_cleanup_commit
    echo -e "${GREEN}清理完成!${NC}"
    echo -e "${YELLOW}提示: 如果需要恢复任何文件，请使用 git log 查看备份记录${NC}"
    echo -e "${YELLOW}提示: 如果需要重新启动开发服务器，请运行 'npm run dev'${NC}"
else
    echo -e "${YELLOW}操作已取消${NC}"
    exit 0
fi 