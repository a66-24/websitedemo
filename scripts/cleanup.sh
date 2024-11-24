#!/bin/bash

# 清理脚本 v1.3.1
# 适用于 Mac M1 环境
# 作者: a66.chkt@outlook.com
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

# 在 main_cleanup 函数中添加端口检查
check_and_kill_port() {
    local port=$1
    if lsof -i :$port > /dev/null; then
        echo -e "${YELLOW}端口 $port 被占用，尝试释放...${NC}"
        lsof -ti :$port | xargs kill -9
        echo "端口已释放"
    fi
}

# 主清理函数
main_cleanup() {
    echo -e "${GREEN}开始清理项目...${NC}"
    
    # 检查常用开发端口
    check_and_kill_port 3000
    check_and_kill_port 3001
    
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
        ".next"        # Next.js 开发缓存
        ".turbo"       # Turbopack 缓存
        "build"        # 通用构建目录
        "dist"         # 通用分发目录
        ".cache"       # 通用缓存目录
        "out"          # Next.js 静态导出目录
        ".vercel"      # Vercel 部署缓存
        ".env.*.local" # 本地环境变量（可选，取决于你的需求）
    )
    
    for dir in "${cache_dirs[@]}"; do
        if [ -d "$dir" ]; then
            rm -rf "$dir"
            echo "已清理: $dir"
        fi
    done
    
    # 3. 清理构建产物
    echo "清理构建产物..."
    build_artifacts=(
        "*.tsbuildinfo"     # TypeScript 构建信息
        "next-env.d.ts"     # Next.js TypeScript 声明文件
        ".next-*"           # Next.js 相关文件
        "tsconfig.tsbuildinfo"  # TypeScript 构建缓存
        "build-storybook.log"   # Storybook 日志（如果使用）
    )
    
    for artifact in "${build_artifacts[@]}"; do
        find . -name "$artifact" -type f -delete
    done
    
    # 4. 清理日志文件
    echo "清理日志文件..."
    find . -type f -name "*.log" -delete
    find . -type f -name "npm-debug.log*" -delete
    find . -type f -name "yarn-debug.log*" -delete
    find . -type f -name "yarn-error.log*" -delete
    find . -type f -name ".pnpm-debug.log*" -delete
    
    # 5. 清理IDE文件但保留cursor配置
    echo "清理IDE文件..."
    if [ -d ".vscode" ]; then
        find .vscode -type f ! -name "settings.json" -delete
    fi
    
    # 6. 清理系统文件
    echo "清理系统文件..."
    find . -type f -name ".DS_Store" -delete
    
    # 7. 检查并修复package.json
    echo "检查package.json..."
    if [ -f "package.json" ]; then
        if ! jq empty package.json 2>/dev/null; then
            echo -e "${RED}警告: package.json 格式有误${NC}"
        fi
    fi
}

# 配置npm镜像源
configure_npm_registry() {
    echo -e "${GREEN}配置 npm 镜像源...${NC}"
    
    # 设置淘宝镜像源
    npm config set registry https://registry.npmmirror.com
    
    # 验证镜像源设置
    echo "当前 npm 镜像源："
    npm config get registry
    
    echo -e "${GREEN}npm 镜像源配置完成${NC}"
}

# 添加依赖去重函数
dedupe_dependencies() {
    echo -e "${GREEN}检查并去重依赖...${NC}"
    
    if [ -f "pnpm-lock.yaml" ]; then
        echo "使用 pnpm 去重依赖..."
        pnpm dedupe
    elif [ -f "yarn.lock" ]; then
        echo "使用 yarn 去重依赖..."
        yarn dedupe
    else
        echo "使用 npm 去重依赖..."
        npm dedupe
    fi
}

# 修改 reinstall_dependencies 函数
reinstall_dependencies() {
    echo -e "${GREEN}重新安装依赖...${NC}"
    
    # 配置镜像源
    configure_npm_registry
    
    # 清理 lock 文件
    if [ -f "package-lock.json" ]; then
        rm package-lock.json
        echo "已删除 package-lock.json"
    fi
    
    # 检查并更新 package.json 中的依赖版本
    if [ -f "package.json" ]; then
        # 更新过时的依赖
        echo "更新依赖版本..."
        dependencies_to_update=(
            "rimraf@^5.0.0"
            "glob@^10.0.0"
            "@eslint/config-array@latest"
            "@eslint/object-schema@latest"
            "eslint@latest"
        )
        
        for dep in "${dependencies_to_update[@]}"; do
            echo "更新 $dep"
            npm install "$dep" --save-dev --silent
        done
    fi
    
    # 安装依赖
    echo "使用 npm 安装依赖..."
    npm install --no-fund --no-audit --silent
    
    # 执行依赖去重
    dedupe_dependencies
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
echo -e "${YELLOW}同时会更新并修复过时的依赖${NC}"
read -p "是否继续? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    create_git_backup
    main_cleanup
    reinstall_dependencies
    create_cleanup_commit
    echo -e "${GREEN}清理完成!${NC}"
    echo -e "${GREEN}依赖已更新到最新版本${NC}"
    echo -e "${YELLOW}提示: 如果需要恢复任何文件，请使用 git log 查看备份记录${NC}"
    echo -e "${YELLOW}提示: 如果需要重新启动开发服务器，请运行 'npm run dev'${NC}"
else
    echo -e "${YELLOW}操作已取消${NC}"
    exit 0
fi 