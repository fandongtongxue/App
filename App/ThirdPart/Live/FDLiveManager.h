//
//  FDLiveManager.h
//  App
//
//  Created by bogokj on 2019/7/5.
//  Copyright © 2019年 范东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDLiveManager : NSObject

+ (FDLiveManager *)defaultManager;

- (void)startLive;

@end

NS_ASSUME_NONNULL_END
