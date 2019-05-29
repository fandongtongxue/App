//
//  FDPayManager.h
//  App
//
//  Created by 范东 on 2019/5/29.
//  Copyright © 2019 范东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FDPayType) {
    FDPayTypeAli,
    FDPayTypeWeChat,
};

@interface FDPayManager : NSObject

+ (FDPayManager *)defaultManager;

@property(nonatomic, assign) FDPayType payType;

@end

NS_ASSUME_NONNULL_END
