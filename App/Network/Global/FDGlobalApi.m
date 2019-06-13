//
//  FDGlobalApi.m
//  App
//
//  Created by bogokj on 2019/6/13.
//  Copyright © 2019年 范东. All rights reserved.
//

#import "FDGlobalApi.h"

@implementation FDGlobalApi

-(NSString *)requestUrl{
    return @"?s=App.Site.globalData";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return nil;
}

- (BOOL)useCDN {
    return NO;
}

- (NSString *)resumableDownloadPath {
    return nil;
}

- (NSInteger)cacheTimeInSeconds{
    return 0;
}

@end
