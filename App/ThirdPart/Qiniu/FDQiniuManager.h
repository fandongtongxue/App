//
//  FDQiniuManager.h
//  App
//
//  Created by bogokj on 2019/7/6.
//  Copyright © 2019年 范东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDQiniuManager : NSObject

+ (FDQiniuManager *)defaultManager;

- (void)uploadImage:(UIImage *)image Key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
