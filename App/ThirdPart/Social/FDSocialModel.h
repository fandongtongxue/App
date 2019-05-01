//
//  FDSocialModel.h
//  App
//
//  Created by bogokj on 2019/4/30.
//  Copyright © 2019年 范东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDSocialModel : NSObject

@end

@interface FDSocialAuthModel : FDSocialModel

@property (nonatomic, copy) NSString  *uid;
@property (nonatomic, copy) NSString  *openid;
@property (nonatomic, copy) NSString  *refreshToken;
@property (nonatomic, copy) NSDate    *expiration;
@property (nonatomic, copy) NSString  *accessToken;

@property (nonatomic, copy) NSString  *unionId;


/**
 usid 兼容U-Share 4.x/5.x 版本，与4/5版本数值相同
 即，对应微信平台：openId，QQ平台openId，其他平台不变
 */
@property (nonatomic, copy) NSString  *usid;

@end

@interface FDSocialShareModel : NSObject

/**
 * 标题
 * @note 标题的长度依各个平台的要求而定
 */
@property (nonatomic, copy) NSString *title;

/**
 * 描述
 * @note 描述内容的长度依各个平台的要求而定
 */
@property (nonatomic, copy) NSString *descr;

/**
 * 缩略图 UIImage或者NSData类型或者NSString类型（图片url）
 */
@property (nonatomic, strong) id thumbImage;

/** 网页的url地址
 * @note 不能为空且长度不能超过10K
 */
@property (nonatomic, retain) NSString *webpageUrl;

@end

@interface FDSocialShareResponseModel : FDSocialModel

@property (nonatomic, copy) NSString  *message;

@end

NS_ASSUME_NONNULL_END
