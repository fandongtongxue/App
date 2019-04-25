//
//  FDUrlArgumentsFilter.m
//  App
//
//  Created by 范东 on 2019/4/24.
//  Copyright © 2019 范东. All rights reserved.
//

#import "FDUrlArgumentsFilter.h"

@implementation FDUrlArgumentsFilter{
    NSDictionary *_arguments;
}

+ (FDUrlArgumentsFilter *)filterWithArguments:(NSDictionary *)arguments {
    return [[self alloc] initWithArguments:arguments];
}

- (id)initWithArguments:(NSDictionary *)arguments {
    self = [super init];
    if (self) {
        _arguments = arguments;
    }
    return self;
}

- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request {
    return @"";
//    return [FDUrlArgumentsFilter urlStringWithOriginUrlString:originUrl appendParameters:_arguments];
}


@end
