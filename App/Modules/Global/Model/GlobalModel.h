//
//  GlobalModel.h
//  AnyApp
//
//  Created by bogokj on 2019/3/24.
//  Copyright © 2019年 fandong.me. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GlobalModel : NSObject

/**
 是否必须要登陆
 */
@property (nonatomic, assign) NSInteger isMustLogin;
/**
 是否需要强制更新
 */
@property (nonatomic, assign) NSInteger isForceUpdate;
/**
 服务端新版本号
 */
@property (nonatomic, copy) NSString *updateVersion;
/**
 服务端新版本下载地址
 */
@property (nonatomic, copy) NSString *updateUrl;
/**
 是否登陆
 */
@property (nonatomic, assign) BOOL isLogin;

@end

NS_ASSUME_NONNULL_END
