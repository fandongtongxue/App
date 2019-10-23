//
//  FDLoginApi.m
//  App
//
//  Created by bogokj on 2019/10/23.
//  Copyright © 2019 范东. All rights reserved.
//

#import "FDLoginApi.h"

@implementation FDLoginApi

-(NSString *)requestUrl{
    return @"";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"mobile":_mobile,@"s":@"App.Examples_User.register"};
}

- (BOOL)useCDN {
    return NO;
}

@end
