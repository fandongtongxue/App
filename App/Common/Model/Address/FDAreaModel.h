//
//  FDAreaModel.h
//  App
//
//  Created by bogokj on 2019/6/13.
//  Copyright © 2019年 范东. All rights reserved.
//

#import "JKDBModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FDAreaModel : JKDBModel

@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *provinceCode;
@property(nonatomic, copy) NSString *cityCode;

@end

NS_ASSUME_NONNULL_END
