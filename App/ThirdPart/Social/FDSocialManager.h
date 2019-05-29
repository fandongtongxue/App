//
//  FDSocialManager.h
//  App
//
//  Created by bogokj on 2019/4/30.
//  Copyright © 2019年 范东. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FDSocialModel;
@class FDSocialShareModel;

typedef void (^FDSocialManagerCompletionHandler)(FDSocialModel *model, NSString *errorMsg);

typedef NS_ENUM(NSInteger, FDSocialManagerLoginType) {
    FDSocialManagerLoginTypeWeibo      = 0,
    FDSocialManagerLoginTypeWeChat   = 1,
    FDSocialManagerLoginTypeQQ          = 4
};

NS_ASSUME_NONNULL_BEGIN

@interface FDSocialManager : NSObject

+ (FDSocialManager *)defaultManager;

- (void)registerApp;

- (void)login:(FDSocialManagerLoginType)type currentViewController:(UIViewController *)viewController completion:(FDSocialManagerCompletionHandler)completion;

- (void)share:(FDSocialManagerLoginType)type object:(FDSocialShareModel *)model currentViewController:(UIViewController *)viewController completion:(FDSocialManagerCompletionHandler)completion;

@end

NS_ASSUME_NONNULL_END
