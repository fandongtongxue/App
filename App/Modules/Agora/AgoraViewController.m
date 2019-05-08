//
//  AgoraViewController.m
//  App
//
//  Created by bogokj on 2019/5/8.
//  Copyright © 2019年 范东. All rights reserved.
//

#import "AgoraViewController.h"

#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>

@interface AgoraViewController ()<AgoraRtcEngineDelegate>

@property(nonatomic, strong) AgoraRtcEngineKit *agoraKit;

@end

@implementation AgoraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initializeAgoraEngine {
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:@"b9a5b1f834454f838148d5f983db2cb8" delegate:self];
}

- (void)setChannelProfile{
    [self.agoraKit setChannelProfile:AgoraChannelProfileCommunication];
    AgoraVideoEncoderConfiguration *configuration =
    [[AgoraVideoEncoderConfiguration alloc]
     initWithSize:AgoraVideoDimension640x360
     frameRate:AgoraVideoFrameRateFps15 bitrate:400
     orientationMode:AgoraVideoOutputOrientationModeFixedPortrait];
    [self.agoraKit setVideoEncoderConfiguration:configuration];
}

- (void)joinChannel {
    [self.agoraKit joinChannelByToken:nil channelId:@"demoChannel1" info:nil uid:0 joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
        // Join channel "demoChannel1"
    }];
}

- (void)enableVideo {
    [self.agoraKit enableVideo];
    // Default mode is disableVideo
}

- (void)setupLocalVideo {
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = 0;
    
    videoCanvas.view = self.localVideo;
    videoCanvas.renderMode = AgoraVideoRenderModeHidden;
    [self.agoraKit setupLocalVideo:videoCanvas];
    // Bind local video stream to view
}

- (void)setupRemoteVideo {
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = uid;
    
    videoCanvas.view = self.remoteVideo;
    videoCanvas.renderMode = AgoraVideoRenderModeFit;
    [self.agoraKit setupRemoteVideo:videoCanvas];
    // Bind remote video stream to view
}

-(void)leaveChannel {
    [self.agoraKit leaveChannel:nil];
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
