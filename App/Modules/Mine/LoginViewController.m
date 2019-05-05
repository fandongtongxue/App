//
//  LoginViewController.m
//  App
//
//  Created by 范东 on 2019/5/2.
//  Copyright © 2019 范东. All rights reserved.
//

#import "LoginViewController.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayerControlView.h>

@interface LoginViewController ()<ZFPlayerMediaPlayback>

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    playerManager.scalingMode = ZFPlayerScalingModeAspectFill;
    /// 播放器相关
    self.player = [[ZFPlayerController alloc] initWithPlayerManager:playerManager containerView:self.view];
    playerManager.assetURL = [NSURL URLWithString:@"http://temp.fandong.me/register_guide_video.mp4"];
    [self.player enterPortraitFullScreen:YES animated:YES];
    
//    QMUIButton *closeBtn = [QMUIButton alloc]initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    
}

- (void)setupNavigationItems{
    [super setupNavigationItems];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
}

@end
