//
//  FDSocialManager.m
//  App
//
//  Created by bogokj on 2019/4/30.
//  Copyright © 2019年 范东. All rights reserved.
//

#import "FDSocialManager.h"
#import "FDSocialModel.h"

#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>

@implementation FDSocialManager

+ (FDSocialManager *)defaultManager{
    static FDSocialManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)login:(FDSocialManagerLoginType)type currentViewController:(UIViewController *)viewController completion:(FDSocialManagerCompletionHandler)completion{
    [[UMSocialManager defaultManager] authWithPlatform:type currentViewController:viewController completion:^(id result, NSError *error) {
        NSString *message = nil;
        if (error) {
            message = [NSString stringWithFormat:@"获取用户信息失败:%@",error];
        } else {
            if ([result isKindOfClass:[UMSocialAuthResponse class]]) {
                UMSocialAuthResponse * resp = result;
                FDSocialAuthModel *model = [[FDSocialAuthModel alloc]init];
                model.uid = resp.uid;
                model.unionId = resp.unionId;
                model.usid = resp.usid;
                model.openid = resp.openid;
                model.accessToken = resp.accessToken;
                model.refreshToken = resp.refreshToken;
                model.expiration = resp.expiration;
                if (completion) {
                    completion(model,@"");
                }
            }else{
                message = @"获取用户信息失败:非UMSocialAuthResponse类";
                if (completion) {
                    completion(nil,message);
                }
            }
        }
    }];
}

@end
