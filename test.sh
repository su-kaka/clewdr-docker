#!/bin/bash

# 测试 ClewdR 下载和解压脚本
set -e  # 遇到错误就退出

echo "=== ClewdR 下载测试脚本 ==="

# 检查并安装必要的工具
echo "检查必要的工具..."

# 检查 wget
if ! command -v wget &> /dev/null; then
    echo "wget 未安装，正在安装..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y wget
    elif command -v yum &> /dev/null; then
        sudo yum install -y wget
    elif command -v brew &> /dev/null; then
        brew install wget
    else
        echo "❌ 无法自动安装 wget，请手动安装"
        exit 1
    fi
fi

# 检查 unzip
if ! command -v unzip &> /dev/null; then
    echo "unzip 未安装，正在安装..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y unzip
    elif command -v yum &> /dev/null; then
        sudo yum install -y unzip
    elif command -v brew &> /dev/null; then
        brew install unzip
    else
        echo "❌ 无法自动安装 unzip，请手动安装"
        exit 1
    fi
fi

# 检查 file 命令
if ! command -v file &> /dev/null; then
    echo "file 命令未安装，正在安装..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y file
    elif command -v yum &> /dev/null; then
        sudo yum install -y file
    elif command -v brew &> /dev/null; then
        brew install file
    else
        echo "❌ 无法自动安装 file 命令，请手动安装"
        exit 1
    fi
fi

echo "✅ 所有必要工具已准备就绪"

# 创建临时目录
TEST_DIR="/tmp/clewdr_test"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo "工作目录: $(pwd)"

# 步骤1：下载
echo ""
echo "步骤1: 下载 clewdr zip 文件..."
DOWNLOAD_URL="https://github.com/Xerxes-2/clewdr/releases/latest/download/clewdr-linux-x86_64.zip"
echo "下载URL: $DOWNLOAD_URL"

if wget -O clewdr.zip "$DOWNLOAD_URL"; then
    echo "✅ 下载成功"
    echo "文件大小: $(ls -lh clewdr.zip)"
else
    echo "❌ 下载失败"
    exit 1
fi

# 步骤2：查看zip内容
echo ""
echo "步骤2: 查看 zip 文件内容..."
if unzip -l clewdr.zip; then
    echo "✅ zip 文件结构显示完成"
else
    echo "❌ 无法查看 zip 内容"
    exit 1
fi

# 步骤3：解压
echo ""
echo "步骤3: 解压 zip 文件..."
if unzip clewdr.zip; then
    echo "✅ 解压成功"
else
    echo "❌ 解压失败"
    exit 1
fi

# 步骤4：查看解压后的文件结构
echo ""
echo "步骤4: 查看解压后的文件结构..."
echo "当前目录内容:"
ls -la

echo ""
echo "所有文件和目录:"
find . -ls

echo ""
echo "查找所有 clewdr 相关文件:"
find . -name "*clewdr*" -type f

echo ""
echo "查找所有可执行文件:"
find . -type f -executable

# 步骤5：检查具体的 clewdr 二进制文件
echo ""
echo "步骤5: 检查 clewdr 二进制文件..."

if [ -f "./clewdr/clewdr" ]; then
    echo "✅ 找到 clewdr 二进制文件在: ./clewdr/clewdr"
    ls -la ./clewdr/clewdr
    file ./clewdr/clewdr
    echo "设置执行权限..."
    chmod +x ./clewdr/clewdr
    echo "✅ 权限设置完成"
    ls -la ./clewdr/clewdr
elif [ -f "./clewdr" ]; then
    echo "✅ 找到 clewdr 二进制文件在: ./clewdr"
    ls -la ./clewdr
    file ./clewdr
    echo "设置执行权限..."
    chmod +x ./clewdr
    echo "✅ 权限设置完成"
    ls -la ./clewdr
else
    echo "❌ 未找到 clewdr 二进制文件"
    echo "让我们看看都有什么文件:"
    find . -type f -name "*" -exec ls -la {} \;
fi

echo ""
echo "=== 测试完成 ==="
echo "测试目录: $TEST_DIR"
echo "如果需要清理，请运行: rm -rf $TEST_DIR"