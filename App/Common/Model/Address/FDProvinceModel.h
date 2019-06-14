//
//  FDProvinceModel.h
//  App
//
//  Created by bogokj on 2019/6/13.
//  Copyright © 2019年 范东. All rights reserved.
//

#import "JKDBModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FDProvinceModel : JKDBModel

@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
