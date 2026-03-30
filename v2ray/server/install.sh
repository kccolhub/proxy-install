#!/bin/bash

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 脚本信息
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  V2Ray && V2RayA 一键安装脚本${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
BIN_DIR="${SCRIPT_DIR}/bin"

# 检查是否为 root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}[错误] 此脚本必须以 root 身份运行${NC}"
   echo "请使用: sudo bash install.sh"
   exit 1
fi

echo -e "${YELLOW}[1/5] 检查系统环境...${NC}"

# 检查系统类型
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
   echo -e "${RED}[错误] 此脚本仅支持 Linux 系统${NC}"
   exit 1
fi

# 检查发行版
if ! command -v dpkg &> /dev/null; then
   echo -e "${RED}[错误] 不支持的系统（需要基于 Debian/Ubuntu）${NC}"
   exit 1
fi

echo -e "${GREEN}✓ 系统检查通过${NC}"

# 检查必要的工具
echo -e "${YELLOW}[2/5] 检查依赖工具...${NC}"

if ! command -v unzip &> /dev/null; then
   echo -e "${YELLOW}  正在安装 unzip...${NC}"
   apt-get update -qq
   apt-get install -y unzip > /dev/null 2>&1
fi

if ! command -v wget &> /dev/null; then
   echo -e "${YELLOW}  正在安装 wget...${NC}"
   apt-get update -qq
   apt-get install -y wget > /dev/null 2>&1
fi

echo -e "${GREEN}✓ 依赖工具检查完成${NC}"

# 安装 V2RayA
echo -e "${YELLOW}[3/5] 安装 V2RayA...${NC}"

if [ ! -f "$BIN_DIR/installer_debian_x64_2.2.7.5.deb" ]; then
   echo -e "${RED}[错误] 未找到 V2RayA 安装包: $BIN_DIR/installer_debian_x64_2.2.7.5.deb${NC}"
   exit 1
fi

dpkg -i "$BIN_DIR/installer_debian_x64_2.2.7.5.deb" > /dev/null 2>&1 || {
   echo -e "${YELLOW}  安装依赖中...${NC}"
   apt-get install -f -y > /dev/null 2>&1
   dpkg -i "$BIN_DIR/installer_debian_x64_2.2.7.5.deb" > /dev/null 2>&1
}

echo -e "${GREEN}✓ V2RayA 安装完成${NC}"

# 安装 V2Ray Core
echo -e "${YELLOW}[4/5] 安装 V2Ray Core...${NC}"

V2RAY_INSTALL_DIR="/opt/v2ray"

if [ ! -f "$BIN_DIR/v2ray-linux-64.zip" ]; then
   echo -e "${RED}[错误] 未找到 V2Ray Core 压缩包: $BIN_DIR/v2ray-linux-64.zip${NC}"
   exit 1
fi

# 创建安装目录
mkdir -p "$V2RAY_INSTALL_DIR"

# 解压 V2Ray Core
echo -e "${YELLOW}  正在解压 v2ray-linux-64.zip...${NC}"
unzip -q "$BIN_DIR/v2ray-linux-64.zip" -d "$V2RAY_INSTALL_DIR"

# 显示解压的文件
echo -e "${YELLOW}  已解压的文件:${NC}"
ls -la "$V2RAY_INSTALL_DIR" | grep -E "^-" | awk '{print "    " $NF}'

# 为所有文件设置可执行权限
echo -e "${YELLOW}  设置文件权限...${NC}"
find "$V2RAY_INSTALL_DIR" -maxdepth 1 -type f -exec chmod +x {} \;

# 创建 V2Ray 用户（如果不存在）
if ! id -u "v2ray" > /dev/null 2>&1; then
   useradd -r -s /bin/nologin -U -d /etc/v2ray v2ray > /dev/null 2>&1
fi

# 设置文件所有者
chown -R v2ray:v2ray "$V2RAY_INSTALL_DIR"
mkdir -p /etc/v2ray
chown -R v2ray:v2ray /etc/v2ray

# 直接复制可执行文件到系统 PATH
echo -e "${YELLOW}  安装到 /usr/local/bin...${NC}"
find "$V2RAY_INSTALL_DIR" -maxdepth 1 -type f ! -name "*.json" ! -name "*.md" ! -name "*.txt" -exec bash -c '
   file="$1"
   name=$(basename "$file")
   cp "$file" /usr/local/bin/"$name"
   chmod +x /usr/local/bin/"$name"
   echo "    已安装: $name"
' _ {} \;

echo -e "${GREEN}✓ V2Ray Core 安装完成${NC}"

# 启动服务
echo -e "${YELLOW}[5/5] 启动服务...${NC}"

# 重新加载 systemd
systemctl daemon-reload > /dev/null 2>&1

# 启动 V2RayA 服务
if systemctl start v2raya > /dev/null 2>&1; then
   systemctl enable v2raya > /dev/null 2>&1
   echo -e "${GREEN}✓ V2RayA 服务已启动${NC}"
else
   echo -e "${YELLOW}⚠ 无法自动启动 V2RayA，请手动执行: systemctl start v2raya${NC}"
fi

# 显示安装完成信息
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  安装完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}重要信息:${NC}"
echo "  V2RayA 安装目录: /opt/v2raya"
echo "  V2Ray Core 安装目录: $V2RAY_INSTALL_DIR"
echo "  配置目录: /etc/v2ray"
echo ""
echo -e "${YELLOW}服务管理:${NC}"
echo "  启动服务: sudo systemctl start v2raya"
echo "  停止服务: sudo systemctl stop v2raya"
echo "  重启服务: sudo systemctl restart v2raya"
echo "  查看状态: sudo systemctl status v2raya"
echo ""
echo -e "${YELLOW}访问 V2RayA 面板:${NC}"
echo "  地址: http://localhost:2017"
echo "  默认用户: admin"
echo "  默认密码: admin (首次登录后请修改)"
echo ""
echo -e "${GREEN}♦ 安装脚本执行完毕${NC}"
echo ""
