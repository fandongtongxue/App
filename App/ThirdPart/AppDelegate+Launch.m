//
//  AppDelegate+UMeng.m
//  App
//
//  Created by bogokj on 2019/4/28.
//  Copyright © 2019年 范东. All rights reserved.
//

#import "AppDelegate+Launch.h"

#import <Bugly/Bugly.h>

#import <UMCommon/UMCommon.h>

#import <XHLaunchAd/XHLaunchAd.h>

#import "FDTabBarController.h"
#import "FDNavigationController.h"
#import "HomeViewController.h"
#import "MineViewController.h"
#import "LoginViewController.h"

#import "ZFDouyinViewController.h"

@interface AppDelegate ()<XHLaunchAdDelegate,BuglyDelegate>

@end

@implementation AppDelegate (ThirdPart)

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    [self initLaunchAd];
    // 界面
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //加载初始化数据
    [[GlobalManager manager] loadData];
    
    //注册第三方
    [self registerApp];
    
    //必须登录
//    if ([GlobalManager manager].globalModel.isMustLogin) {
//        LoginViewController *loginVC = [[LoginViewController alloc]init];
//        FDNavigationController *loginNav = [[FDNavigationController alloc]initWithRootViewController:loginVC];
//        [self.window.rootViewController presentViewController:loginNav animated:YES completion:nil];
//    }
    
    //处理更新
    [self update];
    
    //日志系统
    if (@available(iOS 10, *)) {
        [DDLog addLogger:[DDOSLogger sharedInstance]];
    } else {
        //do nothing
    }
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 刷新频率为24小时
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7; // 保存一周的日志，即7天
    [DDLog addLogger:fileLogger];
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    [self registNotification];
    
    [self createTabBarController];
    
    [self loginIM];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)initLaunchAd{
    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchImage];
    
    //1.因为数据请求是异步的,请在数据请求前,调用下面方法配置数据等待时间.
    //2.设为3即表示:启动页将停留3s等待服务器返回广告数据,3s内等到广告数据,将正常显示广告,否则将不显示
    //3.数据获取成功,配置广告数据后,自动结束等待,显示广告
    //注意:请求广告数据前,必须设置此属性,否则会先进入window的的根控制器
    [XHLaunchAd setWaitDataDuration:3];
    //配置广告数据
    XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration defaultConfiguration];
    //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
    imageAdconfiguration.imageNameOrURLString = @"";
    //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
    imageAdconfiguration.openModel = @"http://blog.fandong.me";
    imageAdconfiguration.duration = 5;
    //显示开屏广告
    [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
}

- (void)loginIM{
    NSString *appId = [[FDKVManager defaultManager] getObjectOfClass:NSStringFromClass([NSString class]) ForKey:Key_UserInfo_Appid];
    NSString *identifier = [[FDKVManager defaultManager] getObjectOfClass:NSStringFromClass([NSString class]) ForKey:Key_UserInfo_User];
    NSString *userSig = [[FDKVManager defaultManager] getObjectOfClass:NSStringFromClass([NSString class]) ForKey:Key_UserInfo_Sig];
    if([appId integerValue] == SDKAPPID && identifier.length != 0 && userSig.length != 0){
        [[FDIMManager defaultManager] loginIdentifier:identifier userSig:userSig appidAt3rd:@"" token:self.deviceToken success:^{
            //do nothing
        } failed:^(NSString * _Nonnull msg, int code) {
            [[FDKVManager defaultManager] setObject:@(0) forKey:Key_UserInfo_Appid];
            [[FDKVManager defaultManager] setObject:@"" forKey:Key_UserInfo_User];
            [[FDKVManager defaultManager] setObject:@"" forKey:Key_UserInfo_Pwd];
            [[FDKVManager defaultManager] setObject:@"" forKey:Key_UserInfo_Sig];
            [self.window.rootViewController presentViewController:self.loginVC animated:YES completion:nil];
        }];
    }else{
        [self.window.rootViewController presentViewController:self.loginVC animated:YES completion:nil];
    }
}

- (void)createTabBarController{
    FDTabBarController *tabBarVC = [[FDTabBarController alloc]init];
    
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[NSFontAttributeName] = Font(12);
    
    ZFDouYinViewController *douyinVC = [[ZFDouYinViewController alloc]init];
    douyinVC.hidesBottomBarWhenPushed = NO;
    FDNavigationController *homeNav = [[FDNavigationController alloc]initWithRootViewController:douyinVC];
    homeNav.tabBarItem = [QDUIHelper tabBarItemWithTitle:Localized(@"Home.Title") image:[UIImageMake(@"tab_home_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"tab_home_selected") tag:0];
    [homeNav.tabBarItem setTitleTextAttributes:attrDict forState:UIControlStateNormal];
    [homeNav.tabBarItem setTitleTextAttributes:attrDict forState:UIControlStateSelected];
    AddAccessibilityHint(homeNav.tabBarItem, Localized(@"Home.Title"));
    
    MineViewController *mineVC = [[MineViewController alloc]init];
    mineVC.hidesBottomBarWhenPushed = YES;
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
        [self update];
    }
    [[FDIMManager defaultManager] doForeground];
}

- (void)registerApp{
    [[FDSocialManager defaultManager] registerApp];
    //Bugly
    // Get the default config
    BuglyConfig * config = [[BuglyConfig alloc] init];
    
    // Open the debug mode to print the sdk log message.
    // Default value is NO, please DISABLE it in your RELEASE version.
#if DEBUG
    config.debugMode = YES;
#endif
    
    // Open the customized log record and report, BuglyLogLevelWarn will report Warn, Error log message.
    // Default value is BuglyLogLevelSilent that means DISABLE it.
    // You could change the value according to you need.
    //    config.reportLogLevel = BuglyLogLevelWarn;
    
    // Open the STUCK scene data in MAIN thread record and report.
    // Default value is NO
    //config.blockMonitorEnable = YES;
    
    // Set the STUCK THRESHOLD time, when STUCK time > THRESHOLD it will record an event and report data when the app launched next time.
    // Default value is 3.5 second.
    //config.blockMonitorTimeout = 1.5;
    
    // Set the app channel to deployment
    config.channel = @"Bugly";
    
    config.delegate = self;
    
    config.consolelogEnable = NO;
    config.viewControllerTrackingEnable = NO;
//    config.version = [[TIMManager sharedInstance] GetVersion];
    
    // NOTE:Required
    // Start the Bugly sdk with APP_ID and your config
    [Bugly startWithAppId:kBuglyAppId
#if DEBUG
        developmentDevice:YES
#endif
                   config:config];
    
    // Set the customizd tag thats config in your APP registerd on the  bugly.qq.com
    // [Bugly setTag:1799];
    
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", [UIDevice currentDevice].name]];
    
    [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"Process"];
    
}

void uncaughtExceptionHandler(NSException*exception){
    DDLogDebug(@"CRASH: %@", exception);
    DDLogDebug(@"Stack Trace: %@",[exception callStackSymbols]);
    // Internal error reporting
}

- (void)update{
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

#pragma mark - XHLaunchAdDelegate
- (void)xhLaunchAdShowFinish:(XHLaunchAd *)launchAd{
    
}

- (void)xhLaunchAd:(XHLaunchAd *)launchAd clickAndOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint{
    
}

#pragma mark - BuglyDelegate
- (NSString * BLY_NULLABLE)attachmentForException:(NSException * BLY_NULLABLE)exception{
    return @"";
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    __block UIBackgroundTaskIdentifier bgTaskID;
    bgTaskID = [application beginBackgroundTaskWithExpirationHandler:^ {
        //不管有没有完成，结束 background_task 任务
        [application endBackgroundTask: bgTaskID];
        bgTaskID = UIBackgroundTaskInvalid;
    }];
    [[FDIMManager defaultManager] doBackground];
}

-(void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    self.deviceToken = deviceToken;
}

- (void)registNotification
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
}

@end
