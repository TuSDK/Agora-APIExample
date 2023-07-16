//
//  TuTuBeautyVC.m
//  APIExample
//
//  Created by 刘鹏程 on 2023/7/5.
//  Copyright © 2023 Agora Corp. All rights reserved.
//

#import "TuTuBeautyVC.h"
#import <AgoraRtcKit/AgoraRtcEngineKitEx.h>
#import "APIExample-Swift.h"

#import "TTLiveMediator.h"
#import "TTViewManager.h"



@interface TuTuBeautyVC ()<AgoraRtcEngineDelegate, AgoraVideoFrameDelegate>

@property (nonatomic, strong) AgoraRtcEngineKit *rtcEngineKit;

@property (nonatomic, strong) UIView *containerView;

@end

@implementation TuTuBeautyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化涂图
    /**
     * 登录控制台 - SDK -> 应用管理  -> 创建应用 -> 创建版本后即可获得对应的appKey
     * 在应用管理界面 -> 资源管理 -> 我的资源库，将对应的资源点击打包按钮，然后点击打包资源 -> 打包下载，即可将对应的资源下载到本地。然后将下载的资源替换到TuSDKPulse.bundle 中即可
     * TTBeauty : 特效处理模块
     * TTResource : 依赖的资源(缩略图、icon、资源文件、国际化文件)
     * TTView : UI展示
     */
    [TTLiveMediator setupWithAppKey:@""];
    
    [self setupViews];
    [self initSDK];
    
    // Do any additional setup after loading the view.
}

- (void)setupViews
{
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:self.containerView];
}

- (void) initSDK
{
    self.rtcEngineKit = [AgoraRtcEngineKit sharedEngineWithAppId:KeyCenter.AppId delegate:self];
    
    // setup videoFrameDelegate
    [self.rtcEngineKit setVideoFrameDelegate:self];
    
    [self.rtcEngineKit enableVideo];
    [self.rtcEngineKit enableAudio];
    
    
    // set up local video to render your local camera preview
    AgoraRtcVideoCanvas *videoCanvas = [AgoraRtcVideoCanvas new];
    videoCanvas.uid = 0;
    // the view to be binded
    videoCanvas.view = self.containerView;
    videoCanvas.renderMode = AgoraVideoRenderModeHidden;
    videoCanvas.mirrorMode = AgoraVideoMirrorModeDisabled;
    [self.rtcEngineKit setupLocalVideo:videoCanvas];
    [self.rtcEngineKit startPreview];

    // set custom capturer as video source
    AgoraRtcChannelMediaOptions *option = [[AgoraRtcChannelMediaOptions alloc] init];
    option.clientRoleType = AgoraClientRoleBroadcaster;
    option.publishMicrophoneTrack = YES;
    option.publishCameraTrack = YES;
    [[NetworkManager shared] generateTokenWithChannelName:self.title uid:0 success:^(NSString * _Nullable token) {
        [self.rtcEngineKit joinChannelByToken:token
                                    channelId:self.title
                                          uid:0
                                 mediaOptions:option
                                  joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
            NSLog(@"join channel success uid: %lu", uid);
        }];
    }];
    
    [[TTLiveMediator shareInstance] setPixelFormat:TTVideoPixelFormat_BGRA];
    [[TTViewManager shareInstance] setBeautyTarget:[TTBeautyProxy transformObjc:[TTLiveMediator shareInstance]]];
    [[TTViewManager shareInstance] setupSuperView:self.view];
    
}

- (BOOL)onCaptureVideoFrame:(AgoraOutputVideoFrame * _Nonnull)videoFrame sourceType:(AgoraVideoSourceType)sourceType;
{
    CVPixelBufferRef newPixelBuffer = [[[TTLiveMediator shareInstance] sendVideoPixelBuffer:videoFrame.pixelBuffer] getCVPixelBuffer];
    if (newPixelBuffer)  {
        videoFrame.type = 14;
        videoFrame.pixelBuffer = newPixelBuffer;
    }
    return YES;
}

- (AgoraVideoFormat)getVideoFormatPreference{
    return AgoraVideoFormatCVPixelBGRA;
}
- (AgoraVideoFrameProcessMode)getVideoFrameProcessMode{
    return AgoraVideoFrameProcessModeReadWrite;
}

#pragma mark - RtcEngineDelegate
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
//    AgoraRtcVideoCanvas *videoCanvas = [AgoraRtcVideoCanvas new];
//    videoCanvas.uid = uid;
//    // the view to be binded
//    videoCanvas.view = self.remoteVideo;
//    videoCanvas.renderMode = AgoraVideoRenderModeHidden;
//    videoCanvas.mirrorMode = AgoraVideoMirrorModeDisabled;
//    [self.rtcEngineKit setupRemoteVideo:videoCanvas];
    
//    AgoraRtcVideoCanvas *videoCanvas = [AgoraRtcVideoCanvas new];
//    videoCanvas.uid = uid;
//    // the view to be binded
//    videoCanvas.view = self.view;
//    videoCanvas.renderMode = AgoraVideoRenderModeHidden;
//    videoCanvas.mirrorMode = AgoraVideoMirrorModeDisabled;
//    [self.rtcEngineKit setupRemoteVideo:videoCanvas];
    
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason {
    AgoraRtcVideoCanvas *videoCanvas = [AgoraRtcVideoCanvas new];
    videoCanvas.uid = uid;
    // the view to be binded
    videoCanvas.view = nil;
    [self.rtcEngineKit setupRemoteVideo:videoCanvas];
}

- (void)dealloc {
    
    [[TTLiveMediator shareInstance] destory];
    [[TTViewManager shareInstance] destory];
    
    [self.rtcEngineKit leaveChannel:nil];
    [self.rtcEngineKit stopPreview];
    [AgoraRtcEngineKit destroy];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
