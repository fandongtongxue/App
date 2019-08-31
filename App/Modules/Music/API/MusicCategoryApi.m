//
//  MusicCategoryApi.m
//  App
//
//  Created by bogokj on 2019/8/31.
//  Copyright © 2019 范东. All rights reserved.
//

#import "MusicCategoryApi.h"

@implementation MusicCategoryApi

-(NSString *)requestUrl{
    return @"netease/songList/category";
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
