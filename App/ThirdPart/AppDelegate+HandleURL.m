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

@interface AppDelegate()

@end

@implementation AppDelegate (HandleURL)

#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        if ([url.host isEqualToString:@"safepay"]){
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
            return YES;
        }
        else if([url.absoluteString rangeOfString:kWeChatAppKey].location != NSNotFound){
            return  [WXApi handleOpenURL:url delegate:self];
        }
    }
    return result;
}

#else
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        if ([url.host isEqualToString:@"safepay"]){
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
            return YES;
        }
        else if([url.absoluteString rangeOfString:kWeChatAppKey].location != NSNotFound){
            return  [WXApi handleOpenURL:url delegate:self];
        }
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        if ([url.host isEqualToString:@"safepay"]){
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
            return YES;
        }
        else if([url.absoluteString rangeOfString:kWeChatAppKey].location != NSNotFound){
            return  [WXApi handleOpenURL:url delegate:self];
        }
    }
    return result;
}
#endif

#pragma mark - WXApiDelegate
- (void)onReq:(BaseReq *)req{
    
}

- (void)onResp:(BaseResp *)resp{
    
}

@end
