### singbox-center ###
# 功能增强任务清单

## 后端认证
- [x] 创建 `server/src/config/auth.json` 认证配置初始文件
- [x] 创建 `server/src/services/auth.ts` 认证服务
- [x] 创建 `server/src/middleware/authMiddleware.ts` 认证中间件
- [x] 创建 `server/src/routes/auth.ts` 认证 API 路由
- [x] 修改 `server/src/index.ts` 注册认证路由和中间件

## 端口扫描设置后端
- [x] 创建 `server/src/config/settings.json` 扫描设置配置
- [x] 创建 `server/src/routes/settings.ts` 设置 API 路由
- [x] 修改 `server/src/services/zerotier.ts` 支持自定义端口扫描
- [x] 修改 `server/src/index.ts` 注册设置路由

## 前端认证
- [x] 创建 `src/api/auth.ts` 前端认证 API 客户端
- [x] 创建 `src/pages/LoginPage.tsx` 登录页面
- [x] 创建 `src/pages/LoginPage.module.scss` 登录页样式
- [x] 修改 `src/app/router.tsx` 添加登录路由和认证守卫
- [x] 修改 `src/api/nodes.ts` 请求带 Authorization header

## Setup Guide 页面
- [x] 创建 `src/pages/SetupGuidePage.tsx` 部署教程页面
- [x] 创建 `src/pages/SetupGuidePage.module.scss` 教程页样式
- [x] 修改 `src/components/SideBar.tsx` 添加 Guide 导航入口
- [x] 修改 `src/app/router.tsx` 添加 `/guide` 路由

## 端口扫描设置前端
- [x] 修改 `src/pages/NodesPage.tsx` 添加扫描设置面板

## 验证
- [x] 构建前端 `pnpm build`
- [ ] 手动测试认证、扫描设置、Guide 页面等功能

updateAtTime: 2026/4/17 17:32:31

planId: fe5ae7cf-6705-46be-bdfd-92c9a7c732c4
