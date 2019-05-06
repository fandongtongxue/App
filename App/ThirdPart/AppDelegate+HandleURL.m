//
//  AppDelegate+HandleURL.m
//  App
//
//  Created by bogokj on 2019/4/29.
//  Copyright © 2019年 范东. All rights reserved.
//

#import "AppDelegate+HandleURL.h"

#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface AppDelegate()<WXApiDelegate>

@end

@implementation AppDelegate (HandleURL)

//#define __IPHONE_10_0    100000
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响。
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
        if ([url.host isEqualToString:@"safepay"])
        {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
            return YES;
        }
        else if([url.absoluteString rangeOfString:@"wxea9a2004da38e365"].location != NSNotFound)
        {
            // 微信支付
            return  [WXApi handleOpenURL:url delegate:self];
        }
    }
    return result;
}
#endif

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
        if ([url.host isEqualToString:@"safepay"])
        {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
            return YES;
        }
        else if([url.absoluteString rangeOfString:@"wxea9a2004da38e365"].location != NSNotFound)
        {
            // 微信支付
            return  [WXApi handleOpenURL:url delegate:self];
        }
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
        if ([url.host isEqualToString:@"safepay"])
        {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
            return YES;
        }
        else if([url.absoluteString rangeOfString:@"wxea9a2004da38e365"].location != NSNotFound)
        {
            // 微信支付
            return  [WXApi handleOpenURL:url delegate:self];
        }
    }
    return result;
}

#pragma mark - WXApiDelegate
- (void)onReq:(BaseReq *)req{
    
}

- (void)onResp:(BaseResp *)resp{
    
}

@end
