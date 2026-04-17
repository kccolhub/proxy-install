### singbox-center ###
为 singbox-center 添加三个功能：1) 登录密码认证（首次设置密码，明文存储可查询）；2) 端口扫描设置（可自定义扫描端口范围）；3) Setup Guide 页面（侧边栏新增入口，展示 sing-box 客户端部署教程）。

# Singbox Center 功能增强：认证 + 端口扫描设置 + 部署教程页

## Proposed Changes

### 一、后端认证模块

#### [NEW] [auth.json](file:///Users/jokerw/Documents/kccolhub/proxy-install/singbox-center/yacd-meta/server/src/config/auth.json)
认证配置文件，初始为空对象 `{}`，首次设置密码后写入：
```json
{
  "password": "明文密码",
  "createdAt": 1713350000000
}
```

#### [NEW] [auth.ts](file:///Users/jokerw/Documents/kccolhub/proxy-install/singbox-center/yacd-meta/server/src/services/auth.ts)
认证服务模块：
- `isPasswordSet()` / `getPassword()` / `setPassword(password)` / `verifyPassword(password)`
- `generateToken()` / `verifyToken(token)` / `removeToken(token)`
- Token 存储在内存 Set 中，服务重启后需重新登录
- 启动时在控制台打印当前密码

#### [NEW] [authMiddleware.ts](file:///Users/jokerw/Documents/kccolhub/proxy-install/singbox-center/yacd-meta/server/src/middleware/authMiddleware.ts)
Express 认证中间件：
- 检查 `Authorization: Bearer {token}` header
- 白名单（免认证）：`/center-api/auth/status`、`/center-api/auth/setup`、`/center-api/auth/login`、`/health`
- `/ui/*` 静态资源不拦截
- 其他 `/center-api/*` 和 `/api/node/*` 需认证，未认证返回 401

#### [NEW] [auth.ts](file:///Users/jokerw/Documents/kccolhub/proxy-install/singbox-center/yacd-meta/server/src/routes/auth.ts)
认证 API 路由：
- `GET /center-api/auth/status` → `{ needSetup }`
- `POST /center-api/auth/setup` → `{ success, token }`（仅密码未设置时可用）
- `POST /center-api/auth/login` → `{ success, token }`
- `POST /center-api/auth/logout` → 销毁 token

#### [MODIFY] [index.ts](file:///Users/jokerw/Documents/kccolhub/proxy-install/singbox-center/yacd-meta/server/src/index.ts)
- 注册 `/center-api/auth` 路由（免认证）
- 注册 `authMiddleware` 到需保护的路由之前
- 启动时打印密码信息

---

### 二、端口扫描设置

#### [NEW] [settings.json](file:///Users/jokerw/Documents/kccolhub/proxy-install/singbox-center/yacd-meta/server/src/config/settings.json)
扫描设置配置文件：
```json
{
  "scanPorts": [9090],
  "scanTimeout": 3000,
  "scanSubnet": ""
}
```

#### [NEW] [settings.ts](file:///Users/jokerw/Documents/kccolhub/proxy-install/singbox-center/yacd-meta/server/src/routes/settings.ts)
设置 API 路由：
- `GET /center-api/settings` → 获取当前设置
- `PUT /center-api/settings` → 更新设置（端口列表、超时时间、子网）

#### [MODIFY] [zerotier.ts](file:///Users/jokerw/Documents/kccolhub/proxy-install/singbox-center/yacd-meta/server/src/services/zerotier.ts)
- 从 `settings.json` 读取 `scanPorts` 配置
- 扫描时遍历所有配置的端口，而不是写死 9090
- `probeClashApi` 函数支持自定义超时时间

#### [MODIFY] [index.ts](file:///Users/jokerw/Documents/kccolhub/proxy-install/singbox-center/yacd-meta/server/src/index.ts)
- 注册 `/center-api/settings` 路由

---

### 三、前端认证

#### [NEW] [auth.ts](file:///Users/jokerw/Documents/kccolhub/proxy-install/singbox-center/yacd-meta/src/api/auth.ts)
前端认证 API 客户端：
- `fetchAuthStatus()` / `setupPassword(password)` / `login(password)` / `logout()`
- Token 存储在 `localStorage('center-token')`
- `getAuthHeaders()` 工具函数，返回 `{ Authorization: 'Bearer xxx' }`

#### [NEW] [LoginPage.tsx](file:///Users/jokerw/Documents/kccolhub/proxy-install/singbox-center/yacd-meta/src/pages/LoginPage.tsx)
登录/初始设置页面：
- `needSetup=true`：显示"设置密码"表单（密码 + 确认密码）
- `needSetup=false`：显示"输入密码"登录表单
- 登录成功后保存 token，跳转到 `/nodes`

#### [NEW] [LoginPage.module.scss](file:///Users/jokerw/Documents/kccolhub/proxy-install/singbox-center/yacd-meta/src/pages/LoginPage.module.scss)
登录页样式

#### [MODIFY] [router.tsx](file:///Users/jokerw/Documents/kccolhub/proxy-install/singbox-center/yacd-meta/src/app/router.tsx)
- 添加 `LoginPage` lazy import 和 `/login` 路由
- 在 `DashboardRouter` 中增加 `AuthGuard` 组件：检查 localStorage token，无 token 则重定向到 `/login`

#### [MODIFY] [nodes.ts](file:///Users/jokerw/Documents/kccolhub/proxy-install/singbox-center/yacd-meta/src/api/nodes.ts)
- 所有 fetch 请求带上 `Authorization` header
- 401 响应时清除 token 并跳转登录页

---

### 四、Setup Guide 页面

#### [NEW] [SetupGuidePage.tsx](file:///Users/jokerw/Documents/kccolhub/proxy-install/singbox-center/yacd-meta/src/pages/SetupGuidePage.tsx)
sing-box 客户端部署教程页面，内容来自 `node-client/SETUP.md`，包含：
- sing-box 安装步骤
- ZeroTier 安装与加入网络
- Moon 节点加入
- 配置部署与启动
- 防火墙设置
- 代码块支持复制按钮

#### [NEW] [SetupGuidePage.module.scss](file:///Users/jokerw/Documents/kccolhub/proxy-install/singbox-center/yacd-meta/src/pages/SetupGuidePage.module.scss)
教程页样式

#### [MODIFY] [SideBar.tsx](file:///Users/jokerw/Documents/kccolhub/proxy-install/singbox-center/yacd-meta/src/components/SideBar.tsx)
- 在 icons 中添加 `guide` 图标（使用 `FcReading` 或 `FcInfo`）
- 在 pages 数组中添加 `{ to: '/guide', iconId: 'guide', labelText: 'Guide' }`

#### [MODIFY] [router.tsx](file:///Users/jokerw/Documents/kccolhub/proxy-install/singbox-center/yacd-meta/src/app/router.tsx)
- 添加 `SetupGuidePage` lazy import
- 在 routes 中添加 `{ path: '/guide', element: <SetupGuidePage /> }`

---

### 五、端口扫描设置前端

#### [MODIFY] [NodesPage.tsx](file:///Users/jokerw/Documents/kccolhub/proxy-install/singbox-center/yacd-meta/src/pages/NodesPage.tsx)
- 在 Nodes 区域顶部增加"Scan Settings"按钮
- 点击展开设置面板：端口列表输入（逗号分隔）、超时时间、子网
- 保存时调用 `PUT /center-api/settings`

## Verification Plan

### Manual Verification
1. 首次访问跳转登录页，设置密码后自动登录
2. 服务器控制台和 `auth.json` 可查看明文密码
3. 刷新保持登录，清除 localStorage 后跳转登录页
4. 未登录访问 API 返回 401
5. 侧边栏 Guide 入口可进入部署教程页
6. Nodes 页面可配置扫描端口范围
7. 扫描时使用配置的端口列表

updateAtTime: 2026/4/17 17:32:31

planId: fe5ae7cf-6705-46be-bdfd-92c9a7c732c4