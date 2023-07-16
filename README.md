# 涂图特效对接声网说明文件

## Demo使用说明

### 1、Demo运行

在`APIExample` 目录下 ，打开终端输入`pod install` 命令，完成后打开`APIExample.xcworkspace` 文件即可。在`APIExample` 中选择更新Team信息, `command + R` 即可运行本项目

### 2、声网appID 和 证书获取

可参考`KeyCenter.swift`  文件中  Agora APP ID. 和 Certificate 获取流程

目前Demo中使用的如下所示，临时Token对应的频道名为 需要申请

```swift
static let AppId: String = ""

static let Certificate: String? = ""
```

```objective-c
[TTLiveMediator setupWithAppKey:@""];
```

### 3、代码参考

代码在`TuTuBeautyVC`类中

```objective-c
//引入头文件
#import "TTLiveMediator.h"
#import "TTViewManager.h"

// 初始化涂图
    /**
     * 登录控制台 - SDK -> 应用管理  -> 创建应用 -> 创建版本后即可获得对应的appKey
     * 在应用管理界面 -> 资源管理 -> 我的资源库，将对应的资源点击打包按钮，然后点击打包资源 -> 打包下载，即可将对应的资源下载到本地。然后将下载的资源替换到TuSDKPulse.bundle 中即可
     * TTBeauty : 特效处理模块
     * TTResource : 依赖的资源(缩略图、icon、资源文件、国际化文件)
     * TTView : UI展示
     */
[TTLiveMediator setupWithAppKey:@""];

//设置参数
[[TTLiveMediator shareInstance] setPixelFormat:TTVideoPixelFormat_BGRA];
[[TTViewManager shareInstance] setBeautyTarget:[TTBeautyProxy transformObjc:[TTLiveMediator shareInstance]]];
[[TTViewManager shareInstance] setupSuperView:self.view];

//美颜回调方法
- (BOOL)onCaptureVideoFrame:(AgoraOutputVideoFrame * _Nonnull)videoFrame sourceType:(AgoraVideoSourceType)sourceType;
{
    CVPixelBufferRef newPixelBuffer = [[[TTLiveMediator shareInstance] sendVideoPixelBuffer:videoFrame.pixelBuffer] getCVPixelBuffer];
    if (newPixelBuffer)  {
        videoFrame.type = 14;
        videoFrame.pixelBuffer = newPixelBuffer;
    }
    return YES;
}

//资源销毁
- (void)dealloc {
    
    [[TTLiveMediator shareInstance] destory];
    [[TTViewManager shareInstance] destory];
}
```

