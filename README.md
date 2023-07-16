# 涂图特效对接声网说明文件

## Demo使用说明

### 1、Demo运行

在`APIExample` 目录下 ，打开终端输入`pod install` 命令，完成后打开`APIExample.xcworkspace` 文件即可。在`APIExample` 中选择更新Team信息, `command + R` 即可运行本项目

### 2、声网appID 和 证书获取

可参考`KeyCenter.swift`  文件中  Agora APP ID. 和 Certificate 获取流程

目前Demo中使用的如下所示，临时Token对应的频道名为 1234567890

```swift
static let AppId: String = "91b4f7a60a874d369b7b9832f8c0f99c"

static let Certificate: String? = "007eJxTYGDf8l2maxd34uvNDpv2mnL8NO/mtvfevTlaTmXrgojNS+oUGCwNk0zSzBPNDBItzE1SjM0sk8yTLC2MjdIskg3SLC2T1S4sSWkIZGR4oBvIysgAgSA+F4OhkbGJqZm5haUBAwMAvtge8Q=="
```

```objective-c
[TTLiveMediator setupWithAppKey:@"4d2a07e8eff8cbef-04-ewdjn1"];
```

