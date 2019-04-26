//
//  FDBaseApi.m
//  App
//
//  Created by 范东 on 2019/4/24.
//  Copyright © 2019 范东. All rights reserved.
//

#import "FDBaseApi.h"
#import "YTKUrlArgumentsFilter.h"
#import "FDNetworking.h"

@implementation FDBaseApi

- (id)init{
    if (self = [super init]) {
        YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
        config.baseUrl = FDBaseUrl;
        config.cdnUrl = FDBaseCdnUrl;
        config.debugLogEnabled = YES;
        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        YTKUrlArgumentsFilter *urlFilter = [YTKUrlArgumentsFilter filterWithArguments:@{@"version": appVersion}];
        [config addUrlFilter:urlFilter];
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
        for (NSString *key in argument.allKeys) {
            NSObject *value = [argument objectForKey:key];
            [tempString setString:[tempString stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,value]]];
        }
        if ([tempString hasSuffix:@"&"]) {
            [tempString replaceCharactersInRange:NSMakeRange(tempString.length - 1, 1) withString:@""];
        }
        NSLog(@"请求Url:%@%@%@",FDBaseUrl,self.requestUrl,tempString);
    }
}

@end
