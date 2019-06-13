//
//  GlobalManager.m
//  AnyApp
//
//  Created by bogokj on 2019/3/24.
//  Copyright © 2019年 fandong.me. All rights reserved.
//

#import "GlobalManager.h"
#import "FDGlobalApi.h"

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
    [[[FDGlobalApi alloc]init] startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"");
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"");
    }];
}

@end
