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
#import <UMAnalytics/MobClick.h>

@implementation FDSocialManager

+ (FDSocialManager *)defaultManager{
    static FDSocialManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)registerApp{
    //友盟
    // [UMConfigure setLogEnabled:YES];
    [UMConfigure initWithAppkey:kUMengAppKey channel:@"App Store"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kWeChatAppKey appSecret:kWeChatAppSecret redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kQQAppKey/*设置QQ平台的appID*/  appSecret:nil redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:kWeiboAppKey  appSecret:kWeiboAppSecret redirectURL:kWeiboRedirectURL];
}

- (void)login:(FDSocialManagerLoginType)type currentViewController:(UIViewController *)viewController completion:(FDSocialManagerCompletionHandler)completion{
    [[UMSocialManager defaultManager] authWithPlatform:(UMSocialPlatformType)type currentViewController:viewController completion:^(id result, NSError *error) {
        NSString *message = nil;
        if (error) {
            message = [NSString stringWithFormat:@"获取用户信息失败:%@",error];
            if (completion) {
                completion(nil,message);
            }
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

- (void)share:(FDSocialManagerLoginType)type object:(FDSocialShareModel *)model currentViewController:(UIViewController *)viewController completion:(FDSocialManagerCompletionHandler)completion{
    //调用分享接口
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL =  model.thumbImage;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:model.title descr:model.descr thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = model.webpageUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:(UMSocialPlatformType)type messageObject:messageObject currentViewController:viewController completion:^(id data, NSError *error) {
        NSString *message = nil;
        if (error) {
            message = [NSString stringWithFormat:@"获取用户信息失败:%@",error];
            if (completion) {
                completion(nil,message);
            }
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                FDSocialShareResponseModel *model = [[FDSocialShareResponseModel alloc]init];
                model.message = resp.message;
                if (completion) {
                    completion(model,@"");
                }
            }else{
                message = @"获取用户信息失败:非UMSocialShareResponse类";
                if (completion) {
                    completion(nil,message);
                }
            }
        }
    }];
}

@end
