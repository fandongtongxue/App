//
//  FDIMManager.m
//  App
//
//  Created by bogokj on 2019/6/27.
//  Copyright © 2019年 范东. All rights reserved.
//

#import "FDIMManager.h"
#import <ImSDK/ImSDK.h>
#import "TUIKit.h"
#import "GenerateTestUserSig.h"

@interface FDIMManager ()<TIMMessageListener>

@end

@implementation FDIMManager

+ (FDIMManager *)defaultManager{
    static FDIMManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserStatus:) name:TUIKitNotification_TIMUserStatusListener object:nil];
    });
    return manager;
}

- (void)registerApp{
    [[TUIKit sharedInstance] setupWithAppId:SDKAPPID];
    //初始化 SDK 基本配置
//    TIMSdkConfig *sdkConfig = [[TIMSdkConfig alloc] init];
//    sdkConfig.sdkAppId = kIMSDKAppID;
//    sdkConfig.disableLogPrint = NO; // 是否允许 log 打印
//    sdkConfig.logLevel = TIM_LOG_DEBUG; //Log 输出级别（debug 级别会很多）
//    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)lastObject];
//    NSString *filePath = [documentPath stringByAppendingPathComponent:@"imlog.log"];
//    sdkConfig.logPath =  filePath; //Log 文件存放在哪里？
//    [[TIMManager sharedInstance] initSdk:sdkConfig];
}

- (void)loginIdentifier:(NSString *)identifier userSig:(NSString *)userSig appidAt3rd:(NSString *)appidAt3rd token:(NSData *)token success:(FDIMloginSuccessCallBack)success failed:(FDIMloginFailedCallBack)failed{
    TIMLoginParam * login_param = [[TIMLoginParam alloc ]init];
    // identifier 为用户名，UserSig 为用户登录凭证
    // appidAt3rd App 用户使用 OAuth 授权体系分配的 Appid，在私有帐号情况下，填写与 SDKAppID 一样
    login_param.identifier = identifier;
    login_param.userSig = userSig;
    login_param.appidAt3rd = appidAt3rd;
    [[TIMManager sharedInstance] login: login_param succ:^(){
        DDLogDebug(@"IM登陆成功");
        if (success) {
            success();
        }
        
        if (token) {
            TIMTokenParam *param = [[TIMTokenParam alloc] init];
            /* 用户自己到苹果注册开发者证书，在开发者帐号中下载并生成证书(p12 文件)，将生成的 p12 文件传到腾讯证书管理控制台，控制台会自动生成一个证书 ID，将证书 ID 传入一下 busiId 参数中。*/
            //企业证书 ID
            param.busiId = sdkBusiId;
            [param setToken:token];
            [[TIMManager sharedInstance] setToken:param succ:^{
                DDLogDebug(@"-----> 上传 token 成功 ");
            } fail:^(int code, NSString *msg) {
                DDLogDebug(@"-----> 上传 token 失败 ");
            }];
        }
    } fail:^(int code, NSString * err) {
        DDLogDebug(@"%s code:%d error:%@",__func__,code,err);
        if (failed) {
            failed(err,code);
        }
    }];
}

- (void)logoutSuccess:(FDIMlogoutSuccessCallBack)success failed:(FDIMlogoutFailedCallBack)failed{
    [[TIMManager sharedInstance] logout:^() {
        DDLogDebug(@"IM退出成功");
        if (success) {
            success();
        }
    } fail:^(int code, NSString * err) {
        DDLogDebug(@"%s code:%d error:%@",__func__,code,err);
        if (failed) {
            failed(err,code);
        }
    }];
}

- (void)onUserStatus:(NSNotification *)notification
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    TUIUserStatus status = [notification.object integerValue];
    switch (status) {
        case TUser_Status_ForceOffline:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"下线通知" message:@"您的帐号于另一台手机上登录。" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                /****此处未提供reLogin接口，而是直接使用保存在本地的数据登录，仅适用于Demo体验版本****/
                NSNumber *appId = [[FDKVManager defaultManager] getObjectOfClass:NSStringFromClass([NSNumber class]) ForKey:Key_UserInfo_Appid];
                NSString *identifier = [[FDKVManager defaultManager] getObjectOfClass:NSStringFromClass([NSString class]) ForKey:Key_UserInfo_User];
                NSString *userSig = [[FDKVManager defaultManager] getObjectOfClass:NSStringFromClass([NSString class]) ForKey:Key_UserInfo_Sig];
                if([appId integerValue] == SDKAPPID && identifier.length != 0 && userSig.length != 0){
                    TIMLoginParam *param = [[TIMLoginParam alloc] init];
                    param.identifier = identifier;
                    param.userSig = userSig;
                    [[TIMManager sharedInstance] login:param succ:^{
                        if (delegate.deviceToken) {
                            TIMTokenParam *param = [[TIMTokenParam alloc] init];
                            /* 用户自己到苹果注册开发者证书，在开发者帐号中下载并生成证书(p12 文件)，将生成的 p12 文件传到腾讯证书管理控制台，控制台会自动生成一个证书 ID，将证书 ID 传入一下 busiId 参数中。*/
                            //企业证书 ID
                            param.busiId = sdkBusiId;
                            [param setToken:delegate.deviceToken];
                            [[TIMManager sharedInstance] setToken:param succ:^{
                                DDLogDebug(@"-----> 上传 token 成功 ");
                            } fail:^(int code, NSString *msg) {
                                DDLogDebug(@"-----> 上传 token 失败 ");
                            }];
                        }
                    } fail:^(int code, NSString *msg) {
                        [[FDKVManager defaultManager] setObject:@(0) forKey:Key_UserInfo_Appid];
                        [[FDKVManager defaultManager] setObject:@"" forKey:Key_UserInfo_User];
                        [[FDKVManager defaultManager] setObject:@"" forKey:Key_UserInfo_Pwd];
                        [[FDKVManager defaultManager] setObject:@"" forKey:Key_UserInfo_Sig];
                        [delegate.window.rootViewController presentViewController:delegate.loginVC animated:YES completion:nil];
                    }];
                }
                else{
                    [delegate.window.rootViewController presentViewController:delegate.loginVC animated:YES completion:nil];
                }
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [delegate.window.rootViewController presentViewController:delegate.loginVC animated:YES completion:nil];
            }]];
            [delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
            break;
        case TUser_Status_ReConnFailed:
        {
            DDLogDebug(@"连网失败");
        }
            break;
        case TUser_Status_SigExpired:
        {
            DDLogDebug(@"userSig过期");
        }
            break;
        default:
            break;
    }
}

- (void)doForeground{
    [[TIMManager sharedInstance] doForeground:^() {
        DDLogDebug(@"doForegroud Succ");
    } fail:^(int code, NSString * err) {
        DDLogDebug(@"Fail: %d->%@", code, err);
    }];
}

- (void)doBackground{
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
        DDLogDebug(@"doBackgroud Succ");
    } fail:^(int code, NSString * err) {
        DDLogDebug(@"Fail: %d->%@", code, err);
    }];
}

@end
