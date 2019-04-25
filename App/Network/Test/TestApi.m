//
//  TestApi.m
//  App
//
//  Created by 范东 on 2019/4/25.
//  Copyright © 2019 范东. All rights reserved.
//

#import "TestApi.h"

@implementation TestApi{
    int _pageNo;
    int _pageSize;
}

- (instancetype)initWithPageNo:(int)pageNo pageSize:(int)pageSize{
    if (self = [super init]) {
        _pageNo = pageNo;
        _pageSize = pageSize;
    }
    return self;
}

-(NSString *)requestUrl{
    return @"/custom/listmore.json";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"pageNo":@(_pageNo),@"pageSize":@(_pageSize)};
}

- (BOOL)useCDN {
    return NO;
}

@end
