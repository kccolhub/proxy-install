# V2RayA 使用文档

## 目录

1. [快速开始](#快速开始)
2. [Web 面板介绍](#web-面板介绍)
3. [订阅配置](#订阅配置)
4. [代理设置](#代理设置)
5. [分流规则](#分流规则)
6. [常见问题](#常见问题)
7. [故障排除](#故障排除)

---

## 快速开始

### 1. 安装 V2RayA

运行一键安装脚本：

```bash
sudo bash install.sh
```

### 2. 启动服务

```bash
sudo systemctl start v2raya
```

### 3. 访问 Web 面板

打开浏览器，访问：

```
http://localhost:2017
```

### 4. 首次登录

- **用户名**：`admin`
- **密码**：`admin`
- ⚠️ **重要**：首次登录后立即修改密码

---

## Web 面板介绍

### 主要功能区域

```
┌─────────────────────────────────────────┐
│  V2RayA                          设置 登出 │
├─────────────────────────────────────────┤
│  ① 订阅管理  ② 节点列表  ③ 设置  ④ 日志 │
├─────────────────────────────────────────┤
│                                          │
│  核心功能区                              │
│  - 选择出站协议                          │
│  - 启用/禁用代理                         │
│  - 选择分流规则                          │
│                                          │
└─────────────────────────────────────────┘
```

### 界面说明

#### ① 订阅管理

- 添加订阅链接
- 选择订阅更新策略
- 手动或自动更新节点

#### ② 节点列表

- 显示所有可用节点
- 节点延迟测试
- 节点筛选和排序

#### ③ 设置

- 代理协议配置
- 监听端口设置
- 分流规则选择
- 日志级别调整

#### ④ 日志

- 实时日志查看
- 错误信息诊断

---

## 订阅配置

### 添加订阅

1. **点击"订阅"选项卡**

2. **添加新订阅**
   - 点击"+"按钮或"添加订阅"
   - 粘贴订阅链接
   - 选择订阅类型（通常为 Surge）
   - 点击"添加"

3. **订阅格式支持**
   - Surge
   - Clash
   - V2Ray JSON
   - 其他标准格式

### 更新订阅

**手动更新**：

- 点击订阅旁的刷新按钮
- 等待更新完成

**自动更新**：

- 进入"设置"
- 配置"订阅自动更新间隔"（推荐：每6小时更新一次）
- 启用自动更新

### 订阅示例

```
https://example.com/subscribe?token=xxxxx
```

---

## 代理设置

### 1. 选择出站协议

V2RayA 支持多种出站协议：

- **VMess**：
  - 加密：AES-128-GCM / AES-256-GCM / ChaCha20-IETF-Poly1305
  - 传输协议：TCP / WebSocket / HTTP/2

- **VLESS**：
  - 现代化协议，轻量级
  - 支持 TLS 加密
  - 支持 fallback

- **Trojan**：
  - 高性能代理协议
  - GFW 伪装效果好
  - TLS 加密传输

- **Shadowsocks**：
  - 轻量级代理
  - 支持多种加密方式

### 2. 启用代理

```
① 在面板顶部找到"启用"按钮
② 点击启用代理
③ 系统将自动配置内核参数
```

### 3. 选择出站节点

**方式一：直连选择**

```
① 点击"节点"列表
② 选择需要的节点
③ 自动应用设置
```

**方式二：分流配置**

```
① 点击"分流规则"
② 为不同的网站/应用分配不同节点
③ 保存配置
```

### 4. 代理端口配置

**HTTP 代理**：

- 默认端口：`20171`
- 配置 PAC（自动代理配置）
- URL：`http://localhost:2017/api/pac/gfwlist.pac`

**SOCKS5 代理**：

- 默认端口：`20170`
- 用于应用程序直接连接

**HTTP with Rule 代理**：

- 端口：`20172`
- 与分流规则配合使用（推荐）

---

## 分流规则

### 什么是分流规则？

分流规则管理不同网站的走代理规则：

- 国内网站走直连
- 被墙网站走代理
- 特定应用走代理

### 常用分流规则

| 规则名称 | 说明 | 推荐度 |
|---------|------|-------|
| `gfwlist` | GFW 黑名单 | ⭐⭐⭐ |
| `chnroute` | 国内路由表 | ⭐⭐⭐⭐⭐ |
| `greatfire` | GreatFire 规则 | ⭐⭐ |
| `自定义` | 自定义规则 | ⭐⭐⭐⭐ |

### 应用分流规则

1. **进入设置**

   ```
   点击顶部"设置"按钮
   ```

2. **选择分流规则**

   ```
   找到"分流规则"选项
   选择预设规则或上传自定义规则
   ```

3. **规则优先级**

   ```
   直连黑名单 > 代理黑名单 > 去广告规则 > 中国 IP > 其他
   ```

### 自定义规则示例

编辑规则文件 (`/etc/v2ray/geosite.dat`)：

```json
{
  "version": 1,
  "domain": [
    {
      "type": "domain",
      "value": "google.com",
      "extras": [
        {
          "key": "cn",
          "value": true
        }
      ]
    }
  ]
}
```

---

## 系统代理设置

### Linux 系统

#### 方式一：环境变量（临时）

```bash
export http_proxy=http://localhost:20171
export https_proxy=http://localhost:20171
export socks5_proxy=socks5://localhost:20170
```

#### 方式二：全局代理（永久）

**GNOME Desktop 环境**：

```
1. 打开"系统设置" → "网络"
2. 选择"网络代理"
3. 选择"手动代理配置"
4. HTTP 代理：localhost:20171
5. SOCKS 代理：localhost:20170
```

**KDE Desktop 环境**：

```
1. 打开"系统设置" → "网络设置"
2. 配置代理服务器
3. HTTP 代理：127.0.0.1:20171
4. SOCKS 代理：127.0.0.1:20170
```

#### 方式三：PAC 自动配置

```
进入 V2RayA 面板 → 获取 PAC URL：
http://localhost:2017/api/pac/gfwlist.pac

在系统设置中填入该 URL
```

### 应用程序代理设置

#### 浏览器（Chrome/Firefox）

1. Chrome：Settings → Advanced → Network → Proxy settings
2. Firefox：Settings → Network Settings → Manual proxy configuration
   - HTTP Proxy: `127.0.0.1:20171`
   - SOCKS Host: `127.0.0.1:20170` (选择 SOCKS v5)

#### Git 代理

```bash
# 配置 HTTP 代理
git config --global http.proxy http://127.0.0.1:20171
git config --global https.proxy http://127.0.0.1:20171

# 配置 SOCKS5 代理
git config --global http.proxy 'socks5://127.0.0.1:20170'
git config --global https.proxy 'socks5://127.0.0.1:20170'

# 取消代理
git config --global --unset http.proxy
git config --global --unset https.proxy
```

#### NPM/Yarn

```bash
# NPM
npm config set http_proxy http://127.0.0.1:20171
npm config set https_proxy http://127.0.0.1:20171

# Yarn
yarn config set httpProxy http://127.0.0.1:20171
yarn config set httpsProxy http://127.0.0.1:20171

# 取消设置
npm config delete http_proxy
npm config delete https_proxy
```

#### Docker

编辑 `/etc/docker/daemon.json`：

```json
{
  "proxies": {
    "http-proxy": "http://127.0.0.1:20171",
    "https-proxy": "http://127.0.0.1:20171"
  }
}
```

然后重启 Docker：

```bash
sudo systemctl restart docker
```

#### SSH/wget/curl

```bash
# wget
wget -e http_proxy=127.0.0.1:20171 https://example.com

# curl
curl -x 127.0.0.1:20171 https://example.com
curl -x socks5://127.0.0.1:20170 https://example.com

# SSH（通过 ProxyCommand）
# 在 ~/.ssh/config 中添加：
Host example.com
    ProxyCommand nc -x 127.0.0.1:20170 %h %p
```

---

## 常见问题

### Q1: 无法连接到 V2RayA 面板？

**解决方案**：

```bash
# 检查服务是否运行
sudo systemctl status v2raya

# 检查端口是否开放
sudo netstat -tlnp | grep 2017

# 重启服务
sudo systemctl restart v2raya

# 查看日志
journalctl -u v2raya -n 50 -f
```

### Q2: 代理速度很慢？

**排查步骤**：

1. **测试节点延迟**

   ```
   在节点列表中点击"延迟测试"
   选择延迟较低的节点
   ```

2. **检查带宽占用**

   ```
   查看系统资源使用
   ps aux | grep v2ray
   ```

3. **优化分流规则**

   ```
   使用更精细的分流规则
   避免在代理中流转过多的直连流量
   ```

4. **更换传输协议**

   ```
   在出站协议中尝试不同的传输方式
   如：WebSocket/HTTP2/gRPC
   ```

### Q3: 某些网站无法访问？

**解决方案**：

1. **刷新 DNS 缓存**

   ```bash
   sudo systemctl restart systemd-resolved
   ```

2. **检查分流规则**

   ```
   进入设置，确认分流规则是否包含该网站
   ```

3. **手动添加到代理黑名单**

   ```
   在自定义规则中添加该域名
   ```

4. **更换节点重试**

### Q4: 出现 "Permission denied" 错误？

**解决方案**：

```bash
# 确保以 root 运行脚本
sudo bash install.sh

# 检查文件权限
sudo chown -R v2ray:v2ray /opt/v2ray
sudo chown -R v2ray:v2ray /etc/v2ray

# 重启服务
sudo systemctl restart v2raya
```

### Q5: 如何在公网服务器上配置？

**仅限本地访问**（默认）：

```
监听地址：127.0.0.1:2017
```

**允许远程访问**（不推荐）：

```
在 V2RayA 设置中修改监听地址为：0.0.0.0:2017
注意：这会暴露管理面板，请务必改安全密码
```

---

## 故障排除

### 1. 日志查看

**实时日志**：

```bash
sudo journalctl -u v2raya -f
```

**查看历史日志**：

```bash
# 最后 100 条日志
sudo journalctl -u v2raya -n 100

# 查看今天的日志
sudo journalctl -u v2raya --since today
```

### 2. V2Ray 内核日志

**查看 V2Ray 核心日志**：

```bash
tail -f /opt/v2ray/v2ray.log
```

### 3. 重置配置

**备份当前配置**：

```bash
sudo cp -r /etc/v2ray /etc/v2ray.backup
```

**恢复出厂设置**：

```bash
# 停止服务
sudo systemctl stop v2raya

# 移除配置
sudo rm -rf /etc/v2ray/*

# 重启服务
sudo systemctl start v2raya
```

### 4. 卸载 V2RayA

```bash
# 停止服务
sudo systemctl stop v2raya

# 卸载软件
sudo dpkg -r v2raya

# 清理配置文件
sudo rm -rf /etc/v2ray
sudo rm -rf /opt/v2ray
```

---

## 性能优化建议

### 1. 选择合适的传输协议

| 协议 | 速度 | 隐蔽性 | 稳定性 | 推荐场景 |
|------|------|--------|--------|---------|
| TCP | 快 | 低 | 高 | VPS 线路好 |
| WebSocket | 中 | 中 | 中 | 混合网络 |
| HTTP/2 | 快 | 中 | 高 | Nginx 反代 |
| gRPC | 快 | 高 | 高 | 高级用户 |

### 2. 优化分流规则

```
- 使用 chnroute（国内 IP 直连）
- 减少规则匹配时间
- 定期更新规则库
```

### 3. 调整缓冲大小

在 `v2ray config` 中修改：

```json
{
  "bufferSize": 4096
}
```

### 4. 连接池配置

```bash
# 优化 TCP 连接
sudo sysctl -w net.core.somaxconn=1024
sudo sysctl -w net.ipv4.tcp_max_syn_backlog=2048
```

---

## 安全建议

### 1. 修改默认密码

   ```
   登录后立即修改管理员密码
   ```

### 2. 限制访问 IP

   ```
   配置防火墙规则
   sudo ufw allow from 127.0.0.1 to any port 2017
   ```

### 3. 定期更新

   ```bash
   sudo apt-get update
   sudo apt-get upgrade
   ```

### 4. 备份配置

   ```bash
   sudo tar czf /home/user/v2raya_backup.tar.gz /etc/v2ray
   ```

---

## 获取帮助

- **官方网站**：<https://v2raya.org/>
- **GitHub Issues**：<https://github.com/v2rayA/v2rayA/issues>
- **Telegram 群组**：<https://t.me/v2rayA>

---

**最后更新**：2026 年 3 月 27 日  
**版本**：1.0
