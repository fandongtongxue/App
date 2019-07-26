//
//  FDKVManager.m
//  App
//
//  Created by bogokj on 2019/7/26.
//  Copyright © 2019 范东. All rights reserved.
//

#import "FDKVManager.h"
#import <MMKV/MMKV.h>

@implementation FDKVManager

+ (FDKVManager *)defaultManager{
    static FDKVManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}



@end
