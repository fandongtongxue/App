//
//  GlobalManager.m
//  AnyApp
//
//  Created by bogokj on 2019/3/24.
//  Copyright © 2019年 fandong.me. All rights reserved.
//

#import "GlobalManager.h"

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
    NSDictionary *dict  = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"globalModel" ofType:@"plist"]];
    [GlobalManager manager].globalModel = [GlobalModel mj_objectWithKeyValues:dict[@"data"]];
}

@end
