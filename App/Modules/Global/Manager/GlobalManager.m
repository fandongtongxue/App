//
//  GlobalManager.m
//  AnyApp
//
//  Created by bogokj on 2019/3/24.
//  Copyright © 2019年 fandong.me. All rights reserved.
//

#import "GlobalManager.h"
#import "FDGlobalApi.h"
#import "FDPCASVApi.h"
#import "FDSQliteManager.h"

@implementation GlobalManager

+ (GlobalManager *)manager{
    static GlobalManager *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)loadData{
    //初始化配置数据
    [[[FDGlobalApi alloc]init] startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        DDLogDebug(@"");
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        DDLogDebug(@"");
    }];
    //初始化资源文件
//    http://app.fandong.me/pcasv.sqlite
    [[[FDPCASVApi alloc] init] startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        DDLogDebug(@"");
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        DDLogDebug(@"");
    }];
}

@end
