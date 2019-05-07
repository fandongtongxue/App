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

#import "FDSocialManager.h"
#import "FDSocialModel.h"

@interface LoginViewController ()<ZFPlayerMediaPlayback>

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@end

@implementation LoginViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    playerManager.scalingMode = ZFPlayerScalingModeAspectFill;
    /// 播放器相关
    self.player = [[ZFPlayerController alloc] initWithPlayerManager:playerManager containerView:self.view];
    playerManager.assetURL = [NSURL URLWithString:@"http://temp.fandong.me/register_guide_video.mp4"];
    @weakify(playerManager);
    [self.player setPlayerDidToEnd:^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
        @strongify(playerManager);
        [playerManager replay];
    }];
//    [self.player enterPortraitFullScreen:YES animated:YES];
    
    if (![GlobalManager manager].globalModel.isMustLogin){
        QMUIButton *closeBtn = [[QMUIButton alloc]initWithFrame:CGRectMake(20, StatusBarHeight + 10, 30, 30)];
        [closeBtn setImage:[UIImage imageNamed:@"common_btn_close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:closeBtn];
    }
    
    CGFloat buttonW = 44;
    CGFloat buttonH = 44;
    
    CGFloat buttonX = (SCREEN_WIDTH - 3 * 44 - 2 * 40) / 2;
    
    NSArray *imageArray = @[@"login_btn_wechat",@"login_btn_qq",@"login_btn_weibo"];
    for (NSInteger i = 0 ; i < 3; i++) {
        QMUIButton *button = [[QMUIButton alloc]initWithFrame:CGRectMake(buttonX + i * (44 + 40), SCREEN_HEIGHT / 2, buttonW, buttonH)];
        [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        button.tag = 10+i;
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
}


#pragma mark - Action
- (void)onClick:(UIButton *)sender{
    @weakify(self);
    switch (sender.tag - 10) {
        case 0:
        {
            [[FDSocialManager defaultManager] login:FDSocialManagerLoginTypeWeChat currentViewController:self completion:^(FDSocialModel *model, NSString *errorMsg) {
                @strongify(self);
                DDLogDebug(@"%@",model.mj_keyValues);
                if (!errorMsg.length) {
                    [GlobalManager manager].globalModel.isLogin = YES;
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }
            break;
        case 1:
        {
            [[FDSocialManager defaultManager] login:FDSocialManagerLoginTypeQQ currentViewController:self completion:^(FDSocialModel *model, NSString *errorMsg) {
                @strongify(self);
                DDLogDebug(@"%@",model.mj_keyValues);
                if (!errorMsg.length) {
                    [GlobalManager manager].globalModel.isLogin = YES;
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }
            break;
        case 2:
        {
            [[FDSocialManager defaultManager] login:FDSocialManagerLoginTypeWeibo currentViewController:self completion:^(FDSocialModel *model, NSString *errorMsg) {
                @strongify(self);
                DDLogDebug(@"%@",model.mj_keyValues);
                if (!errorMsg.length) {
                    [GlobalManager manager].globalModel.isLogin = YES;
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }
            break;
        default:
            break;
    }
}

- (void)closeBtnAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation
- (void)setupNavigationItems{
    [super setupNavigationItems];
    
}

@end
