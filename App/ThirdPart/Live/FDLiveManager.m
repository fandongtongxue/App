//
//  FDLiveManager.m
//  App
//
//  Created by bogokj on 2019/7/5.
//  Copyright © 2019年 范东. All rights reserved.
//

#import "FDLiveManager.h"
#import <TXLiteAVSDK_Smart/TXLiteAVSDK.h>

@implementation FDLiveManager

+ (FDLiveManager *)defaultManager{
    static FDLiveManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)startLive{
    TXLivePlayConfig *config = [[TXLivePlayConfig alloc]init];
    TXLivePush *push = [[TXLivePush alloc]initWithConfig:config];
    
}

@end
