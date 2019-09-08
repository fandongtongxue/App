//
//  AppDelegate+HandleURL.m
//  App
//
//  Created by bogokj on 2019/4/29.
//  Copyright © 2019年 范东. All rights reserved.
//

#import "AppDelegate+HandleURL.h"

@interface AppDelegate()

@end

@implementation AppDelegate (HandleURL)

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    BOOL result = [[FDSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        return [[FDPayManager defaultManager] handleURL:url payCompletionBlock:^(NSDictionary * _Nonnull resultDic) {
            DDLogDebug(@"resultDic:%@",resultDic);
        } delegate:nil];
    }
    return result;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    BOOL result = [[FDSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        return [[FDPayManager defaultManager] handleURL:url payCompletionBlock:^(NSDictionary * _Nonnull resultDic) {
            DDLogDebug(@"resultDic:%@",resultDic);
        } delegate:nil];
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    BOOL result = [[FDSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        return [[FDPayManager defaultManager] handleURL:url payCompletionBlock:^(NSDictionary * _Nonnull resultDic) {
            DDLogDebug(@"resultDic:%@",resultDic);
        } delegate:nil];
    }
    return result;
}

@end
