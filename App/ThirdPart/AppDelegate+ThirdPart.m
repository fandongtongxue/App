//
//  AppDelegate+UMeng.m
//  App
//
//  Created by bogokj on 2019/4/28.
//  Copyright © 2019年 范东. All rights reserved.
//

#import "AppDelegate+ThirdPart.h"

#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>
#import <UMAnalytics/MobClick.h>

#import <Bugly/Bugly.h>

@implementation AppDelegate (ThirdPart)

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [self registerApp];
    return YES;
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

@end
