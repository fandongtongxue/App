//
//  FDUrlArgumentsFilter.h
//  App
//
//  Created by 范东 on 2019/4/24.
//  Copyright © 2019 范东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YTKNetwork/YTKNetwork.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDUrlArgumentsFilter : NSObject <YTKUrlFilterProtocol>

+ (FDUrlArgumentsFilter *)filterWithArguments:(NSDictionary *)arguments;

- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request;


@end

NS_ASSUME_NONNULL_END
