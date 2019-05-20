//
//  FDAnalyzeManager.m
//  App
//
//  Created by bogokj on 2019/5/20.
//  Copyright © 2019年 范东. All rights reserved.
//

#import "FDAnalyzeManager.h"
#import <UMAnalytics/MobClick.h>

@implementation FDAnalyzeManager

+ (FDAnalyzeManager *)defaultManager{
    static FDAnalyzeManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

+ (void)pageBegin:(NSString *)pageName{
    [MobClick beginLogPageView:pageName];
}

+ (void)pageEnd:(NSString *)pageName{
    [MobClick endLogPageView:pageName];
}

@end
