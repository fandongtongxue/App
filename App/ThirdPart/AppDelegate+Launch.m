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

#import <XHLaunchAd/XHLaunchAd.h>

#import <Matrix/Matrix.h>

#import "FDTabBarController.h"
#import "FDNavigationController.h"
#import "HomeViewController.h"
#import "MineViewController.h"
#import "LoginViewController.h"

#import "ZFDouyinViewController.h"

#import "TNavigationController.h"
#import "ConversationController.h"
#import "SettingController.h"
#import "ContactsController.h"
#import "LoginController.h"
#import "TUITabBarController.h"
#import "TUIKit.h"
#import "THeader.h"
#import "ImSDK.h"
#import "GenerateTestUserSig.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate,XHLaunchAdDelegate,BuglyDelegate,MatrixPluginListenerDelegate>

@end

@implementation AppDelegate (ThirdPart)

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    // QMUIConsole 默认只在 DEBUG 下会显示，作为 Demo，改为不管什么环境都允许显示
    [QMUIConsole sharedInstance].canShow = YES;
    
    // QD自定义的全局样式渲染
    [QDCommonUI renderGlobalAppearances];
    
    // 预加载 QQ 表情，避免第一次使用时卡顿
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [QDUIHelper qmuiEmotions];
    });
    
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
    
    //腾讯Debug
    Matrix *matrix = [Matrix sharedInstance];
    MatrixBuilder *curBuilder = [[MatrixBuilder alloc] init];
    curBuilder.pluginListener = self; // pluginListener 回调 plugin 的相关事件
    
    WCCrashBlockMonitorPlugin *crashBlockPlugin = [[WCCrashBlockMonitorPlugin alloc] init];
    [curBuilder addPlugin:crashBlockPlugin]; // 添加卡顿和崩溃监控
    
    WCMemoryStatPlugin *memoryStatPlugin = [[WCMemoryStatPlugin alloc] init];
    [curBuilder addPlugin:memoryStatPlugin]; // 添加内存监控功能
    
    [matrix addMatrixBuilder:curBuilder];
    
    [crashBlockPlugin start]; // 开启卡顿和崩溃监控
    // [memoryStatPlugin start];
    // 开启内存监控，注意 memoryStatPlugin 开启之后对性能损耗较大，建议按需开启
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserStatus:) name:TUIKitNotification_TIMUserStatusListener object:nil];
    
    [self registNotification];
    
    //_SDKAppID 填写自己控制台申请的sdkAppid
    if (SDKAPPID == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Demo 尚未配置 SDKAPPID，请前往 GenerateTestUserSig.h 配置" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [[TUIKit sharedInstance] setupWithAppId:SDKAPPID];
    }
    
    NSNumber *appId = [[NSUserDefaults standardUserDefaults] objectForKey:Key_UserInfo_Appid];
    NSString *identifier = [[NSUserDefaults standardUserDefaults] objectForKey:Key_UserInfo_User];
    //NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:Key_UserInfo_Pwd];
    NSString *userSig = [[NSUserDefaults standardUserDefaults] objectForKey:Key_UserInfo_Sig];
    if([appId integerValue] == SDKAPPID && identifier.length != 0 && userSig.length != 0){
        __weak typeof(self) ws = self;
        TIMLoginParam *param = [[TIMLoginParam alloc] init];
        param.identifier = identifier;
        param.userSig = userSig;
        [[TIMManager sharedInstance] login:param succ:^{
            if (ws.deviceToken) {
                TIMTokenParam *param = [[TIMTokenParam alloc] init];
                /* 用户自己到苹果注册开发者证书，在开发者帐号中下载并生成证书(p12 文件)，将生成的 p12 文件传到腾讯证书管理控制台，控制台会自动生成一个证书 ID，将证书 ID 传入一下 busiId 参数中。*/
                //企业证书 ID
                param.busiId = sdkBusiId;
                [param setToken:ws.deviceToken];
                [[TIMManager sharedInstance] setToken:param succ:^{
                    NSLog(@"-----> 上传 token 成功 ");
                } fail:^(int code, NSString *msg) {
                    NSLog(@"-----> 上传 token 失败 ");
                }];
            }
            ws.window.rootViewController = [self getMainController];
        } fail:^(int code, NSString *msg) {
            [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:Key_UserInfo_Appid];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:Key_UserInfo_User];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:Key_UserInfo_Pwd];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:Key_UserInfo_Sig];
            ws.window.rootViewController = [self getLoginController];
        }];
    }
    else{
        self.window.rootViewController = [self getLoginController];
    }
    
    return YES;
}

- (void)createTabBarController{
    FDTabBarController *tabBarVC = [[FDTabBarController alloc]init];
    
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[NSFontAttributeName] = Font(12);
    
    ZFDouYinViewController *douyinVC = [[ZFDouYinViewController alloc]init];
    douyinVC.hidesBottomBarWhenPushed = NO;
    douyinVC.tabBarItem = [QDUIHelper tabBarItemWithTitle:Localized(@"Home.Title") image:[UIImageMake(@"tab_home_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"tab_home_selected") tag:0];
    [douyinVC.tabBarItem setTitleTextAttributes:attrDict forState:UIControlStateNormal];
    [douyinVC.tabBarItem setTitleTextAttributes:attrDict forState:UIControlStateSelected];
    AddAccessibilityHint(douyinVC.tabBarItem, Localized(@"Home.Title"));
    
    MineViewController *mineVC = [[MineViewController alloc]init];
    mineVC.hidesBottomBarWhenPushed = YES;
    FDNavigationController *mineNav = [[FDNavigationController alloc]initWithRootViewController:mineVC];
    mineNav.tabBarItem = [QDUIHelper tabBarItemWithTitle:Localized(@"Mine.Title") image:[UIImageMake(@"tab_mine_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"tab_mine_selected") tag:0];
    [mineNav.tabBarItem setTitleTextAttributes:attrDict forState:UIControlStateNormal];
    [mineNav.tabBarItem setTitleTextAttributes:attrDict forState:UIControlStateSelected];
    AddAccessibilityHint(mineNav.tabBarItem, Localized(@"Mine.Title"));
    
    tabBarVC.viewControllers = @[douyinVC,mineNav];
        
    self.window.rootViewController = tabBarVC;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //如果是强制更新,回到前台再次显示
    if ([GlobalManager manager].globalModel.isForceUpdate) {
        [self update];
    }
    [[TIMManager sharedInstance] doForeground:^() {
        NSLog(@"doForegroud Succ");
    } fail:^(int code, NSString * err) {
        NSLog(@"Fail: %d->%@", code, err);
    }];
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
    
    [UMessage openDebugMode:YES];
    [UMessage setWebViewClassString:@"UMWebViewController"];
    [UMessage addLaunchMessage];
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

#pragma mark - Push
//iOS10以下使用这两个方法接收通知，
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [UMessage setAutoAlert:NO];
    if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
        [UMessage didReceiveRemoteNotification:userInfo];
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
}

#pragma mark - UNUserNotificationCenterDelegate
//iOS10新增:处理前台收到通知的代理方法
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

//iOS10新增:处理后台点击通知的代理方法
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

#pragma mark - XHLaunchAdDelegate
- (void)xhLaunchAdShowFinish:(XHLaunchAd *)launchAd{
    
}

- (void)xhLaunchAd:(XHLaunchAd *)launchAd clickAndOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint{
    
}

#pragma mark - BuglyDelegate
- (NSString * BLY_NULLABLE)attachmentForException:(NSException * BLY_NULLABLE)exception{
    return @"";
}

#pragma mark - MatrixPluginListenerDelegate
- (void)onInit:(id<MatrixPluginProtocol>)plugin{
    DDLogDebug(@"%s",__func__);
}

- (void)onStart:(id<MatrixPluginProtocol>)plugin{
    DDLogDebug(@"%s",__func__);
}

- (void)onStop:(id<MatrixPluginProtocol>)plugin{
    DDLogDebug(@"%s",__func__);
}

- (void)onDestroy:(id<MatrixPluginProtocol>)plugin{
    DDLogDebug(@"%s",__func__);
}

- (void)onReportIssue:(MatrixIssue *)issue{
    DDLogDebug(@"%s",__func__);
}

- (UIViewController *)getLoginController{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LoginController *login = [board instantiateViewControllerWithIdentifier:@"LoginController"];
    return login;
}

- (UITabBarController *)getMainController{
    TUITabBarController *tbc = [[TUITabBarController alloc] init];
    NSMutableArray *items = [NSMutableArray array];
    TUITabBarItem *msgItem = [[TUITabBarItem alloc] init];
    msgItem.title = @"消息";
    msgItem.selectedImage = [UIImage imageNamed:@"message_pressed"];
    msgItem.normalImage = [UIImage imageNamed:@"message_normal"];
    msgItem.controller = [[TNavigationController alloc] initWithRootViewController:[[ConversationController alloc] init]];
    [items addObject:msgItem];
    
    TUITabBarItem *contactItem = [[TUITabBarItem alloc] init];
    contactItem.title = @"通讯录";
    contactItem.selectedImage = [UIImage imageNamed:@"contacts_pressed"];
    contactItem.normalImage = [UIImage imageNamed:@"contacts_normal"];
    contactItem.controller = [[TNavigationController alloc] initWithRootViewController:[[ContactsController alloc] init]];
    [items addObject:contactItem];
    
    TUITabBarItem *setItem = [[TUITabBarItem alloc] init];
    setItem.title = @"我";
    setItem.selectedImage = [UIImage imageNamed:@"setting_pressed")];
    setItem.normalImage = [UIImage imageNamed:@"setting_normal"];
    setItem.controller = [[TNavigationController alloc] initWithRootViewController:[[SettingController alloc] init]];
    [items addObject:setItem];
    tbc.tabBarItems = items;
    
    return tbc;
}

- (void)onUserStatus:(NSNotification *)notification
{
    TUIUserStatus status = [notification.object integerValue];
    switch (status) {
        case TUser_Status_ForceOffline:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"下线通知" message:@"您的帐号于另一台手机上登录。" delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"重新登录", nil];
            [alertView show];
        }
            break;
        case TUser_Status_ReConnFailed:
        {
            NSLog(@"连网失败");
        }
            break;
        case TUser_Status_SigExpired:
        {
            NSLog(@"userSig过期");
        }
            break;
        default:
            break;
    }
}


/**
 *强制下线后的响应函数委托
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        LoginController *login = [board instantiateViewControllerWithIdentifier:@"LoginController"];
        self.window.rootViewController = login;
    }else if(buttonIndex == 1){
        /****此处未提供reLogin接口，而是直接使用保存在本地的数据登录，仅适用于Demo体验版本****/
        NSNumber *appId = [[NSUserDefaults standardUserDefaults] objectForKey:Key_UserInfo_Appid];
        NSString *identifier = [[NSUserDefaults standardUserDefaults] objectForKey:Key_UserInfo_User];
        NSString *userSig = [[NSUserDefaults standardUserDefaults] objectForKey:Key_UserInfo_Sig];
        if([appId integerValue] == SDKAPPID && identifier.length != 0 && userSig.length != 0){
            __weak typeof(self) ws = self;
            TIMLoginParam *param = [[TIMLoginParam alloc] init];
            param.identifier = identifier;
            param.userSig = userSig;
            [[TIMManager sharedInstance] login:param succ:^{
                if (ws.deviceToken) {
                    TIMTokenParam *param = [[TIMTokenParam alloc] init];
                    /* 用户自己到苹果注册开发者证书，在开发者帐号中下载并生成证书(p12 文件)，将生成的 p12 文件传到腾讯证书管理控制台，控制台会自动生成一个证书 ID，将证书 ID 传入一下 busiId 参数中。*/
                    //企业证书 ID
                    param.busiId = sdkBusiId;
                    [param setToken:ws.deviceToken];
                    [[TIMManager sharedInstance] setToken:param succ:^{
                        NSLog(@"-----> 上传 token 成功 ");
                    } fail:^(int code, NSString *msg) {
                        NSLog(@"-----> 上传 token 失败 ");
                    }];
                }
                ws.window.rootViewController = [self getMainController];
            } fail:^(int code, NSString *msg) {
                [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:Key_UserInfo_Appid];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:Key_UserInfo_User];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:Key_UserInfo_Pwd];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:Key_UserInfo_Sig];
                ws.window.rootViewController = [self getLoginController];
            }];
        }
        else{
            self.window.rootViewController = [self getLoginController];
        }
    }
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
    
    //获取未读计数
    int unReadCount = 0;
    NSArray *convs = [[TIMManager sharedInstance] getConversationList];
    for (TIMConversation *conv in convs) {
        if([conv getType] == TIM_SYSTEM){
            continue;
        }
        unReadCount += [conv getUnReadMessageNum];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = unReadCount;
    
    //doBackground
    TIMBackgroundParam  *param = [[TIMBackgroundParam alloc] init];
    [param setC2cUnread:unReadCount];
    [[TIMManager sharedInstance] doBackground:param succ:^() {
        NSLog(@"doBackgroud Succ");
    } fail:^(int code, NSString * err) {
        NSLog(@"Fail: %d->%@", code, err);
    }];
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
