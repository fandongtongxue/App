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

#import "PhoneLoginViewController.h"

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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"register_guide_video" ofType:@"mp4"];
    playerManager.assetURL = [NSURL fileURLWithPath:path];
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
    
    CGFloat buttonX = (SCREEN_WIDTH - 4 * 44 - 3 * 40) / 2;
    
    NSArray *imageArray = @[@"login_btn_mobile",@"login_btn_wechat",@"login_btn_qq",@"login_btn_weibo"];
    for (NSInteger i = 0 ; i < imageArray.count; i++) {
        QMUIButton *button = [[QMUIButton alloc]initWithFrame:CGRectMake(buttonX + i * (44 + 40), SCREEN_HEIGHT / 2, buttonW, buttonH)];
        [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        button.tag = 10+i;
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
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
            PhoneLoginViewController *phoneLoginVC = [[PhoneLoginViewController alloc]initWithCallBack:^{
                @strongify(self);
                [[FDKVManager defaultManager] setObject:@"1" forKey:isLogin];
                [self loginIM];
            }];
            [self.navigationController pushViewController:phoneLoginVC animated:YES];
        }
        break;
        case 1:
        {
            [[FDSocialManager defaultManager] login:FDSocialManagerLoginTypeWeChat currentViewController:self completion:^(FDSocialModel *model, NSString *errorMsg) {
                @strongify(self);
                DDLogDebug(@"%@",model.mj_keyValues);
                if (!errorMsg.length) {
                    [[FDKVManager defaultManager] setObject:@"1" forKey:isLogin];
                    [self loginIM];
                }
            }];
        }
            break;
        case 2:
        {
            [[FDSocialManager defaultManager] login:FDSocialManagerLoginTypeQQ currentViewController:self completion:^(FDSocialModel *model, NSString *errorMsg) {
                @strongify(self);
                DDLogDebug(@"%@",model.mj_keyValues);
                if (!errorMsg.length) {
                    [[FDKVManager defaultManager] setObject:@"1" forKey:isLogin];
                    [self loginIM];
                }
            }];
        }
            break;
        case 3:
        {
            [[FDSocialManager defaultManager] login:FDSocialManagerLoginTypeWeibo currentViewController:self completion:^(FDSocialModel *model, NSString *errorMsg) {
                @strongify(self);
                DDLogDebug(@"%@",model.mj_keyValues);
                if (!errorMsg.length) {
                    [[FDKVManager defaultManager] setObject:@"1" forKey:isLogin];
                    [self loginIM];
                }
            }];
        }
            break;
        default:
            break;
    }
}

- (void)loginIM{
    NSString *identifier = [NSString stringWithFormat:@"%@%d",@"fanxiaobing",arc4random() % 1000];
    //genTestUserSig 方法仅用于本地测试，请不要将如下代码发布到您的线上正式版本的 App 中，原因如下：
    /*
     *  本文件中的代码虽然能够正确计算出 UserSig，但仅适合快速调通 SDK 的基本功能，不适合线上产品，
     *  这是因为客户端代码中的 SECRETKEY 很容易被反编译逆向破解，尤其是 Web 端的代码被破解的难度几乎为零。
     *  一旦您的密钥泄露，攻击者就可以计算出正确的 UserSig 来盗用您的腾讯云流量。
     *
     *  正确的做法是将 UserSig 的计算代码和加密密钥放在您的业务服务器上，然后由 App 按需向您的服务器获取实时算出的 UserSig。
     *  由于破解服务器的成本要高于破解客户端 App，所以服务器计算的方案能够更好地保护您的加密密钥。
     */
    NSString *userSig = [GenerateTestUserSig genTestUserSig:identifier];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSData *deviceToken = delegate.deviceToken;
    [[FDIMManager defaultManager] loginIdentifier:identifier userSig:userSig appidAt3rd:@"" token:deviceToken success:^{
        [[FDKVManager defaultManager] setObject:@(SDKAPPID) forKey:Key_UserInfo_Appid];
        [[FDKVManager defaultManager] setObject:identifier forKey:Key_UserInfo_User];
        [[FDKVManager defaultManager] setObject:@"" forKey:Key_UserInfo_Pwd];
        [[FDKVManager defaultManager] setObject:userSig forKey:Key_UserInfo_Sig];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    } failed:^(NSString * _Nonnull msg, int code) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"code:%d msdg:%@ ,请检查 sdkappid,identifier,userSig 是否正确配置",code,msg] message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)closeBtnAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation
- (void)setupNavigationItems{
    [super setupNavigationItems];
    
}

@end
