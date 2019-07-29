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

- (void)setObject:(id)object forKey:(NSString *)key{
    [[MMKV defaultMMKV] setObject:object forKey:key];
}

- (void)setBool:(BOOL)object forKey:(NSString *)key{
    [[MMKV defaultMMKV] setBool:object forKey:key];
}

- (id)getObjectOfClass:(NSString *)className ForKey:(NSString *)key{
    return [[MMKV defaultMMKV] getObjectOfClass:NSClassFromString(className) forKey:key];
}

- (BOOL)boolForKey:(NSString *)key{
    return [[MMKV defaultMMKV] getBoolForKey:key];
}

@end
