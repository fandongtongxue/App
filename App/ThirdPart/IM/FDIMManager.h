//
//  FDIMManager.h
//  App
//
//  Created by bogokj on 2019/6/27.
//  Copyright © 2019年 范东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FDIMloginSuccessCallBack)();
typedef void(^FDIMloginFailedCallBack)(NSString *msg, int code);

typedef void(^FDIMlogoutSuccessCallBack)();
typedef void(^FDIMlogoutFailedCallBack)(NSString *msg, int code);

@interface FDIMManager : NSObject

+ (FDIMManager *)defaultManager;

- (void)registerApp;

- (void)loginIdentifier:(NSString *)identifier userSig:(NSString *)userSig appidAt3rd:(NSString *)appidAt3rd success:(FDIMloginSuccessCallBack)success failed:(FDIMloginFailedCallBack)failed;

- (void)logoutSuccess:(FDIMlogoutSuccessCallBack)success failed:(FDIMlogoutFailedCallBack)failed;

@end

NS_ASSUME_NONNULL_END
