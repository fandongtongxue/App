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
#import <UMPush/UMessage.h>
#import <UserNotifications/UserNotifications.h>

#ifdef DEBUG
//#import <DoraemonKit/DoraemonManager.h>
#endif

#import "FDTabBarController.h"
#import "FDNavigationController.h"
#import "HomeViewController.h"
#import "MineViewController.h"
#import "LoginViewController.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate (ThirdPart)

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    #ifdef DEBUG
//        [[DoraemonManager shareInstance] install];
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
    
    //加载初始化数据
    [[GlobalManager manager] loadData];
    
    // Push's basic setting
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert;
    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter currentNotificationCenter].delegate=self;
    } else {
        //do nothing
    }
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        }else
        {
        }
    }];
    
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
        [self update];
    }
}

- (void)registerApp{
    [[FDSocialManager defaultManager] registerApp];
    //Bugly
    [Bugly startWithAppId:kBuglyAppId];
    
    [UMessage openDebugMode:YES];
    [UMessage setWebViewClassString:@"UMWebViewController"];
    [UMessage addLaunchMessage];
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

#pragma mark - 推送
//iOS10以下使用这两个方法接收通知，
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [UMessage setAutoAlert:NO];
    if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
        [UMessage didReceiveRemoteNotification:userInfo];
        
        //    self.userInfo = userInfo;
        //    //定制自定的的弹出框
        //    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
        //    {
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
        //                                                            message:@"Test On ApplicationStateActive"
        //                                                           delegate:self
        //                                                  cancelButtonTitle:@"确定"
        //                                                  otherButtonTitles:nil];
        //
        //        [alertView show];
        //
        //    }
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//    //关闭友盟自带的弹出框
//    [UMessage setAutoAlert:NO];
//    [UMessage didReceiveRemoteNotification:userInfo];
//
//    //    self.userInfo = userInfo;
//    //    //定制自定的的弹出框
//    //    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
//    //    {
//    //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
//    //                                                            message:@"Test On ApplicationStateActive"
//    //                                                           delegate:self
//    //                                                  cancelButtonTitle:@"确定"
//    //                                                  otherButtonTitles:nil];
//    //
//    //        [alertView show];
//    //
//    //    }
//
//}
#pragma mark - UNUserNotificationCenterDelegate
//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(nullable UNNotification *)notification API_AVAILABLE(ios(10.0)){
    
}

@end
