# SCToolBox OAuth 认证系统

## 快速开始

### 授权流程

```
┌─────────┐      ┌──────────┐      ┌────────────┐      ┌──────────┐
│ Web App │──1──▶│ Browser  │──2──▶│ SCToolBox  │──3──▶│  Server  │
└─────────┘      └──────────┘      └────────────┘      └──────────┘
     ▲                                     │                   │
     │                                     ├──4──▶ 验证域名    │
     │                                     │       安全性      │
     │                                     │                   │
     │                                     ├──5──▶ 生成 JWT   │
     │                                     │       令牌        │
     │                                     │                   │
     └─────────────────6─────────────────┘                   │
                  返回令牌                                     │
```


### URL Scheme 格式
```
sctoolbox://auth/{domain}?callbackUrl={回调地址}
```

### 示例
```
sctoolbox://auth/example.com?callbackUrl=https%3A%2F%2Fexample.com%2Fauth%2Fcallback
```

### 回调格式
```
{callbackUrl}#access_token={jwt_token}&token_type=Bearer
```

## 功能特性

- ✅ 基于 JWT 的安全认证
- ✅ 域名白名单验证  
- ✅ 跨平台支持（Windows、macOS、Linux）
- ✅ 两种授权方式（直接跳转 / 复制链接）
- ✅ 符合 OAuth 2.0 Implicit Flow 标准

## 实现文件

### 核心文件
- `lib/ui/auth/auth_page.dart` - 授权页面 UI
- `lib/ui/auth/auth_ui_model.dart` - 授权页面状态管理
- `lib/common/utils/url_scheme_handler.dart` - URL Scheme 处理器

### 平台配置
- `macos/Runner/Info.plist` - macOS URL Scheme 配置
- `windows/runner/main.cpp` - Windows Deep Link 处理
- `linux/my_application.cc` - Linux Deep Link 处理
- `linux/sctoolbox.desktop` - Linux MIME 类型注册
- `pubspec.yaml` - MSIX 协议激活配置

## 使用方法

### 初始化
URL Scheme handler 在 `IndexUI` 中自动初始化：

```dart
useEffect(() {
  UrlSchemeHandler().initialize(context);
  return () => UrlSchemeHandler().dispose();
}, const []);
```

### Web 应用集成

```javascript
// 发起授权
const authUrl = `sctoolbox://auth/example.com?callbackUrl=${encodeURIComponent(callbackUrl)}`;
window.location.href = authUrl;

// 处理回调
const params = new URLSearchParams(window.location.hash.substring(1));
const token = params.get('access_token');
```

## 平台要求

- **Windows**: 需要使用 MSIX 打包版本
- **macOS**: 需要配置 Info.plist
- **Linux**: 需要注册 .desktop 文件

## 安全性

- ✅ JWT 签名验证
- ✅ 域名白名单检查
- ✅ 令牌过期时间控制
- ✅ 使用 Fragment (#) 传递令牌（更安全）

## 详细文档

查看 [完整文档](./AUTH_SYSTEM.md) 了解更多信息，包括：
- 详细的授权流程
- API 接口说明
- Web 应用集成示例
- 安全最佳实践
- 常见问题解答

## API 端点

认证服务提供以下 gRPC 接口：

- `GenerateToken` - 生成 JWT 令牌
- `ValidateToken` - 验证令牌有效性  
- `GetPublicKey` - 获取公钥用于验证
- `GetJWTDomainList` - 获取可信域名列表

## 测试

```bash
# macOS/Linux
open "sctoolbox://auth/test.example.com?callbackUrl=https%3A%2F%2Ftest.example.com%2Fcallback"

# Windows
start "sctoolbox://auth/test.example.com?callbackUrl=https%3A%2F%2Ftest.example.com%2Fcallback"
```
