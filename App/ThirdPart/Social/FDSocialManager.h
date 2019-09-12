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

typedef void (^FDSocialManagerCompletionHandler)(FDSocialModel * _Nullable model, NSString * _Nullable errorMsg);

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

-(BOOL)handleOpenURL:(NSURL *)url;

-(BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

-(BOOL)handleOpenURL:(NSURL *)url options:(NSDictionary*)options;

@end

NS_ASSUME_NONNULL_END
