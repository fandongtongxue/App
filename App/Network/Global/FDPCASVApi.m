//
//  FDPCASVApi.m
//  App
//
//  Created by bogokj on 2019/6/18.
//  Copyright © 2019年 范东. All rights reserved.
//

#import "FDPCASVApi.h"

@implementation FDPCASVApi

-(NSString *)requestUrl{
    return @"data.sqlite";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return nil;
}

- (BOOL)useCDN {
    return YES;
}

- (NSString *)resumableDownloadPath {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"pcasv.sqlite"];
    return filePath;
}

- (NSInteger)cacheTimeInSeconds{
    return 0;
}

@end
