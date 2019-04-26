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
        config.cdnUrl = FDBaseCdnUrl;
//        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//        FDUrlArgumentsFilter *filter = [FDUrlArgumentsFilter filterWithArguments:@{@"appVersion":appVersion}];
//        [config addUrlFilter:filter];
    }
    return self;
}

-(NSString *)requestUrl{
    NSLog(@"%s 需要子类实现",__func__);
    return nil;
}

- (YTKRequestMethod)requestMethod {
    NSLog(@"%s 需要子类实现",__func__);
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    NSLog(@"%s 需要子类实现",__func__);
    return nil;
}

- (id)jsonValidator{
    NSLog(@"%s 如果需要验证JSON合法性需要子类实现",__func__);
    return nil;
}

- (BOOL)useCDN {
    NSLog(@"%s 如果需要使用CDN需要子类实现",__func__);
    return NO;
}

- (NSString *)resumableDownloadPath {
    NSLog(@"%s 如果需要使用缓存需要子类实现",__func__);
//    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *cachePath = [libPath stringByAppendingPathComponent:@"Caches"];
//    NSString *filePath = [cachePath stringByAppendingPathComponent:@""];
    return nil;
}

- (NSInteger)cacheTimeInSeconds {
    NSLog(@"%s 如果需要设置缓存时间需要子类实现",__func__);
    return 0;
}

- (void)startWithCompletionBlockWithSuccess:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure{
    [super startWithCompletionBlockWithSuccess:success failure:failure];
    if (self.requestMethod == YTKRequestMethodPOST) {
        NSLog(@"请求Url:%@%@",FDBaseUrl,self.requestUrl);
        NSLog(@"请求参数:%@",self.requestArgument);
    }else if (self.requestMethod == YTKRequestMethodGET){
        NSMutableString *tempString = [NSMutableString stringWithString:@"?"];
        NSDictionary *argument = self.requestArgument;
        for (NSObject *key in argument.allKeys) {
            NSObject *value = [argument objectForKey:key];
            [tempString setString:[tempString stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,value]]];
        }
        if ([tempString hasSuffix:@"&"]) {
            [tempString replaceCharactersInRange:NSMakeRange(tempString.length - 1,1) withString:@""];
        }
        NSLog(@"请求Url:%@%@%@",FDBaseUrl,self.requestUrl,tempString);
    }
}

@end