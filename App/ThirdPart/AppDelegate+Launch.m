//
//  AppDelegate+UMeng.m
//  App
//
//  Created by bogokj on 2019/4/28.
//  Copyright © 2019年 范东. All rights reserved.
//

#import "AppDelegate+Launch.h"

#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>
#import <UMAnalytics/MobClick.h>

#import <Bugly/Bugly.h>

#ifdef DEBUG
#import <DoraemonKit/DoraemonManager.h>
#endif

#import "FDTabBarController.h"
#import "FDNavigationController.h"
#import "HomeViewController.h"
#import "MineViewController.h"
#import "LoginViewController.h"

@implementation AppDelegate (ThirdPart)

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    #ifdef DEBUG
        [[DoraemonManager shareInstance] install];
    #endif
    
    // QMUIConsole 默认只在 DEBUG 下会显示，作为 Demo，改为不管什么环境都允许显示
    [QMUIConsole sharedInstance].canShow = YES;
    
    // QD自定义的全局样式渲染
    [QDCommonUI renderGlobalAppearances];
    
    // 预加载 QQ 表情，避免第一次使用时卡顿
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [QDUIHelper qmuiEmotions];
    });
    
    // 界面
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self createTabBarController];
    
    // 启动动画
    [self startLaunchingAnimation];
    
    //加载初始化数据
    [[GlobalManager manager] loadData];
    
    //注册第三方
    [self registerApp];
    
    //RootViewController
    [self createTabBarController];
    
    [self.window makeKeyAndVisible];
    
    //必须登录
    if ([GlobalManager manager].globalModel.isMustLogin) {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        FDNavigationController *loginNav = [[FDNavigationController alloc]initWithRootViewController:loginVC];
        [self.window.rootViewController presentViewController:loginNav animated:YES completion:nil];
    }
    
    //处理更新
    [self operateUpdate];
    
    //日志系统
    if (@available(iOS 10, *)) {
        [DDLog addLogger:[DDOSLogger sharedInstance]];
    } else {
        //do nothing
    }
    // DDTTYLogger，你的日志语句将被发送到Xcode控制台
//    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // DDASLLogger，你的日志语句将被发送到苹果文件系统、你的日志状态会被发送到 Console.app
//    [DDLog addLogger:[DDASLLogger sharedInstance]];
    
    // DDFileLogger，你的日志语句将写入到一个文件中，默认路径在沙盒的Library/Caches/Logs/目录下，文件名为bundleid+空格+日期.log。
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 刷新频率为24小时
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7; // 保存一周的日志，即7天
    [DDLog addLogger:fileLogger];
    
    // 产生Log
//    DDLogVerbose(@"Verbose");   // 详细日志
//    DDLogDebug(@"Debug");       // 调试日志
//    DDLogInfo(@"Info");         // 信息日志
//    DDLogWarn(@"Warn");         // 警告日志
//    DDLogError(@"Error");       // 错误日志
    
//    //字体
//    for (NSString *fontfamilyname in [UIFont familyNames])
//    {
//        DDLogDebug(@"family:'%@'",fontfamilyname);
//        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
//        {
//            DDLogDebug(@"\tfont:'%@'",fontName);
//        }
//        DDLogDebug(@"-------------");
//    }
    
    return YES;
}

- (void)createTabBarController{
    FDTabBarController *tabBarVC = [[FDTabBarController alloc]init];
    
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[NSFontAttributeName] = Font(12);
    
    HomeViewController *homeVC = [[HomeViewController alloc]init];
    homeVC.hidesBottomBarWhenPushed = NO;
    FDNavigationController *homeNav = [[FDNavigationController alloc]initWithRootViewController:homeVC];
    homeNav.tabBarItem = [QDUIHelper tabBarItemWithTitle:Localized(@"Home.Title") image:[UIImageMake(@"tab_home_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"tab_home_selected") tag:0];
    [homeNav.tabBarItem setTitleTextAttributes:attrDict forState:UIControlStateNormal];
    [homeNav.tabBarItem setTitleTextAttributes:attrDict forState:UIControlStateSelected];
    AddAccessibilityHint(homeNav.tabBarItem, Localized(@"Home.Title"));
    
    MineViewController *mineVC = [[MineViewController alloc]init];
    mineVC.hidesBottomBarWhenPushed = NO;
    FDNavigationController *mineNav = [[FDNavigationController alloc]initWithRootViewController:mineVC];
    mineNav.tabBarItem = [QDUIHelper tabBarItemWithTitle:Localized(@"Mine.Title") image:[UIImageMake(@"tab_mine_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"tab_mine_selected") tag:0];
    [mineNav.tabBarItem setTitleTextAttributes:attrDict forState:UIControlStateNormal];
    [mineNav.tabBarItem setTitleTextAttributes:attrDict forState:UIControlStateSelected];
    AddAccessibilityHint(mineNav.tabBarItem, Localized(@"Mine.Title"));
    tabBarVC.viewControllers = @[homeNav,mineNav];
        
    self.window.rootViewController = tabBarVC;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //如果是强制更新,回到前台再次显示
    if ([GlobalManager manager].globalModel.isForceUpdate) {
        [self operateUpdate];
    }
}

- (void)registerApp{
    //友盟
    //开发者需要显式的调用此函数，日志系统才能工作
//    [UMConfigure setLogEnabled:YES];
    [UMConfigure initWithAppkey:@"56e6b3e667e58e1b7700012b" channel:@"App Store"];
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxea9a2004da38e365" appSecret:@"43a5474e2a060a5c926358b33d999848" redirectURL:nil];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     100424468.no permission of union id
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105514912"/*设置QQ平台的appID*/  appSecret:nil redirectURL:nil];
    
    /*
     设置新浪的appKey和appSecret
     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"2959688014"  appSecret:@"b6a3c705205ae877e5fa31d95fa15674" redirectURL:@"http://api.fandong.me"];
    
    //Bugly
    [Bugly startWithAppId:@"9f73163e66"];
}

- (void)startLaunchingAnimation {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIView *launchScreenView = [[NSBundle mainBundle] loadNibNamed:@"LaunchScreen" owner:self options:nil].firstObject;
    launchScreenView.frame = window.bounds;
    [window addSubview:launchScreenView];
    
    UIImageView *backgroundImageView = launchScreenView.subviews[0];
    backgroundImageView.clipsToBounds = YES;
    
    UIImageView *logoImageView = launchScreenView.subviews[1];
    UILabel *copyrightLabel = launchScreenView.subviews.lastObject;
    
    UIView *maskView = [[UIView alloc] initWithFrame:launchScreenView.bounds];
    maskView.backgroundColor = UIColorWhite;
    [launchScreenView insertSubview:maskView belowSubview:backgroundImageView];
    
    [launchScreenView layoutIfNeeded];
    
    
    [launchScreenView.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.identifier isEqualToString:@"bottomAlign"]) {
            obj.active = NO;
            [NSLayoutConstraint constraintWithItem:backgroundImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:launchScreenView attribute:NSLayoutAttributeTop multiplier:1 constant:NavigationContentTop].active = YES;
            *stop = YES;
        }
    }];
    
    [UIView animateWithDuration:.15 delay:0.9 options:QMUIViewAnimationOptionsCurveOut animations:^{
        [launchScreenView layoutIfNeeded];
        logoImageView.alpha = 0.0;
        copyrightLabel.alpha = 0;
    } completion:nil];
    [UIView animateWithDuration:1.2 delay:0.9 options:UIViewAnimationOptionCurveEaseOut animations:^{
        maskView.alpha = 0;
        backgroundImageView.alpha = 0;
    } completion:^(BOOL finished) {
        [launchScreenView removeFromSuperview];
    }];
}

- (void)operateUpdate{
    //是否需要更新
    NSString *buildVersion = [[[NSBundle mainBundle] infoDictionary] valueForKey:(NSString *)kCFBundleVersionKey];
    NSString *updateVersion = [GlobalManager manager].globalModel.updateVersion;
    if (buildVersion.integerValue < updateVersion.integerValue) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:Localized(@"Update.Alert.Title") message:Localized(@"Update.Alert.Message") preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:Localized(@"Common.OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[GlobalManager manager].globalModel.updateUrl]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[GlobalManager manager].globalModel.updateUrl]];
            }
        }]];
        if (![GlobalManager manager].globalModel.isForceUpdate) {
            [alertVC addAction:[UIAlertAction actionWithTitle:Localized(@"Common.Cancel") style:UIAlertActionStyleCancel handler:nil]];
        }
        [self.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
    }
}

@end
