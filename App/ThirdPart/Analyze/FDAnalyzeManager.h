//
//  FDAnalyzeManager.h
//  App
//
//  Created by bogokj on 2019/5/20.
//  Copyright © 2019年 范东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kFDEventIDPhoneLogin @"Login.PhoneLogin"

@interface FDAnalyzeManager : NSObject

+ (FDAnalyzeManager *)defaultManager;

+ (void)pageBegin:(NSString *)pageName;

+ (void)pageEnd:(NSString *)pageName;

+(void)event:(NSString *)event;

@end

NS_ASSUME_NONNULL_END
