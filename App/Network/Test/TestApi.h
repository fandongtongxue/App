//
//  TestApi.h
//  App
//
//  Created by 范东 on 2019/4/25.
//  Copyright © 2019 范东. All rights reserved.
//

#import "FDBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestApi : FDBaseApi

- (instancetype)initWithPageNo:(int)pageNo pageSize:(int)pageSize;

@end

NS_ASSUME_NONNULL_END
