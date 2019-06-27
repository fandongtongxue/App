//
//  FDIMManager.m
//  App
//
//  Created by bogokj on 2019/6/27.
//  Copyright © 2019年 范东. All rights reserved.
//

#import "FDIMManager.h"
#import <ImSDK/ImSDK.h>

@interface FDIMManager ()<TIMMessageListener>

@end

@implementation FDIMManager

+ (FDIMManager *)defaultManager{
    static FDIMManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)registerApp{
    //初始化 SDK 基本配置
    TIMSdkConfig *sdkConfig = [[TIMSdkConfig alloc] init];
    sdkConfig.sdkAppId = kIMSDKAppID;
    sdkConfig.disableLogPrint = NO; // 是否允许 log 打印
    sdkConfig.logLevel = TIM_LOG_DEBUG; //Log 输出级别（debug 级别会很多）
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"imlog.log"];
    sdkConfig.logPath =  filePath; //Log 文件存放在哪里？
    [[TIMManager sharedInstance] initSdk:sdkConfig];
}

- (void)loginIdentifier:(NSString *)identifier userSig:(NSString *)userSig appidAt3rd:(NSString *)appidAt3rd success:(FDIMloginSuccessCallBack)success failed:(FDIMloginFailedCallBack)failed{
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

@end
