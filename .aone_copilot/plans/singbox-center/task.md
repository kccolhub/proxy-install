### singbox-center ###

# sing-box 中心化代理管理架构 - 任务清单

## 项目初始化
- [x] 在 `singbox-center/` 下添加 git submodule：`git submodule add -b kccolhub/master https://github.com/kccolhub/Yacd-meta.git yacd-meta`
- [x] 在 kccolhub/Yacd-meta 仓库中新建 `kccolhub/master` 分支
- [x] 在子仓根目录创建 `README.md`（更新为 singbox-center 项目说明）

## 前端二次开发（子仓 src/ 目录，kccolhub/master 分支）
- [x] 修改 `src/types.ts` 增加 `NodeInfo`、`SubscriptionSource`、`DeployResult` 类型
- [x] 创建 `src/api/nodes.ts` 节点管理 API 客户端
- [x] 创建 `src/store/nodes.ts` 节点状态管理
- [x] 创建 `src/components/nodes/NodeCard.tsx` 节点卡片组件
- [x] 创建 `src/components/nodes/NodeCard.module.scss` 节点卡片样式
- [x] 创建 `src/components/nodes/NodeList.tsx` 节点列表组件
- [x] 创建 `src/components/nodes/NodeList.module.scss` 节点列表样式
- [x] 创建 `src/pages/NodesPage.tsx` 节点管理页面
- [x] 修改 `src/components/SideBar.tsx` 增加 Nodes 导航入口
- [x] 修改 `src/app/router.tsx` 增加 `/nodes` 路由
- [x] 修改 `src/store/types.ts` 增加 `StateNodes` 类型到 `State`

## 后端 Express 服务（子仓 server/ 目录）
- [x] 创建 `server/package.json` 依赖配置
- [x] 创建 `server/tsconfig.json` TypeScript 配置
- [x] 创建 `server/src/types.ts` 类型定义
- [x] 创建 `server/src/proxy.ts` 动态反向代理
- [x] 创建 `server/src/index.ts` Express 服务入口
- [x] 创建 `server/src/routes/nodes.ts` 节点管理 API 路由
- [x] 创建 `server/src/routes/subscription.ts` 订阅管理 API 路由
- [x] 创建 `server/src/routes/deploy.ts` 配置分发 API 路由
- [x] 创建 `server/src/services/nodeStore.ts` 节点存储服务
- [x] 创建 `server/src/services/zerotier.ts` ZeroTier 节点发现服务
- [x] 创建 `server/src/services/subscription.ts` 订阅拉取/转换服务
- [x] 创建 `server/src/services/deploy.ts` SSH 配置推送服务
- [x] 创建 `server/src/config/nodes.json` 节点配置初始文件
- [x] 创建 `server/src/config/subscriptions.json` 订阅源配置初始文件
- [x] 创建 `server/src/config/template.json` sing-box 配置模板

## 客户端节点（子仓 node-client/ 目录）
- [x] 创建 `node-client/config.json` sing-box 默认配置
- [x] 创建 `node-client/SETUP.md` 节点部署文档

## ZeroTier 配置（子仓 zerotier/ 目录）
- [x] 创建 `zerotier/SETUP.md` ZeroTier Moon 搭建文档

## 使用文档（子仓 docs/ 目录）
- [x] 创建 `docs/QUICK-START.md` 快速开始指南
- [x] 创建 `docs/CENTER-SETUP.md` 中心端部署文档
- [x] 创建 `docs/NODE-SETUP.md` 节点部署文档
- [x] 创建 `docs/TROUBLESHOOTING.md` 故障排除文档


updateAtTime: 2026/4/17 16:50:10

planId: fe5ae7cf-6705-46be-bdfd-92c9a7c732c4