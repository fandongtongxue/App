//
//  FDQiniuManager.h
//  App
//
//  Created by bogokj on 2019/7/6.
//  Copyright © 2019年 范东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^progressHandler)(float percent);

typedef void(^completionHandler)(NSDictionary *result);

@interface FDQiniuManager : NSObject

+ (FDQiniuManager *)defaultManager;

- (void)uploadImage:(UIImage *)image key:(NSString *)key progress:(progressHandler)progress completion:(completionHandler)completion;

@end

NS_ASSUME_NONNULL_END
