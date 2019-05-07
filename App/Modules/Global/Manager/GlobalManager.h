//
//  GlobalManager.h
//  AnyApp
//
//  Created by bogokj on 2019/3/24.
//  Copyright © 2019年 fandong.me. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GlobalManager : NSObject

@property (nonatomic, strong) GlobalModel *globalModel;

+ (GlobalManager *)manager;

- (void)loadData;

@end

NS_ASSUME_NONNULL_END
