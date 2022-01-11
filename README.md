-->


# 稳健医疗 Flutter App基础框架

## 引入库

```dart
import 'package:flutter_winner_app/flutter_winner_app.dart'
```

## 启动 App

```dart
void main() async {
	AppConfig config = AppConfig()
  await WinnerApp(config).appMain(appInit:() async {
    /// 初始化一些其他操作
  })
}
```

