# 稳健医疗 Flutter App基础框架

## 引入库

```dart
import 'package:flutter_winner_app/flutter_winner_app.dart'
```

## 启动 App

```dart
void main() async {
  /// AppConfig 为 WinnerAppConfig 的子类，用于配置一些需要的配置
	AppConfig config = AppConfig()
  await WinnerApp(config).appMain(appInit:() async {
    /// 初始化一些其他操作
  })
}
```

### 自定义 WinnerAppConfig 子类

```dart
class AppConfig extends WinnerAppConfig {
  SentryHost get sentryHost {
    /// sentryHost已经不是必要实现 isEnableSentry 设置为false即可
  }
  
  WinnerEnvironmentUrl get environmentUrl {
    /// 设置 Debug Profile Release 的环境请求地址 目前已经支持自定义配置
  }
  
  Widget appHome(BuildContext context) {
    /// 设置 App 第一次初始化的组件
  }
}
```

