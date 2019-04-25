//
//  FDBaseApi.m
//  App
//
//  Created by 范东 on 2019/4/24.
//  Copyright © 2019 范东. All rights reserved.
//

#import "FDBaseApi.h"
#import "FDUrlArgumentsFilter.h"
#import "FDNetworking.h"

@implementation FDBaseApi

- (id)init{
    if (self = [super init]) {
        YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
        config.baseUrl = FDBaseUrl;
//        config.cdnUrl = FDBaseCdnUrl;
//        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//        FDUrlArgumentsFilter *filter = [FDUrlArgumentsFilter filterWithArguments:@{@"appVersion":appVersion}];
//        [config addUrlFilter:filter];
    }
    return self;
}

-(NSString *)requestUrl{
    NSLog(@"%s 需要子类实现",__func__);
    return @"";
}

- (YTKRequestMethod)requestMethod {
    NSLog(@"%s 需要子类实现",__func__);
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    NSLog(@"%s 需要子类实现",__func__);
    return @{};
}

- (id)jsonValidator{
    NSLog(@"%s 需要子类实现",__func__);
    return @{};
}

- (BOOL)useCDN {
    NSLog(@"%s 需要子类实现",__func__);
    return YES;
}

- (NSString *)resumableDownloadPath {
    NSLog(@"%s 需要子类实现",__func__);
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachePath = [libPath stringByAppendingPathComponent:@"Caches"];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@""];
    return filePath;
}

- (NSInteger)cacheTimeInSeconds {
    NSLog(@"%s 需要子类实现",__func__);
    return 60 * 3;
}

@end
