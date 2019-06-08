//
//  FDPayManager.h
//  App
//
//  Created by 范东 on 2019/5/29.
//  Copyright © 2019 范东. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BaseReq;
@class BaseResp;

NS_ASSUME_NONNULL_BEGIN

@protocol FDPayManagerDelegate <NSObject>

/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
- (void)onPayReq:(BaseReq*)req;



/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 @param resp 具体的回应内容，是自动释放的
 */
- (void)onPayResp:(BaseResp*)resp;

@end

typedef NS_ENUM(NSInteger, FDPayType) {
    FDPayTypeAli,
    FDPayTypeWeChat,
};

typedef void(^payCompletionBlock)(NSDictionary *resultDic);

@interface FDPayManager : NSObject

+ (FDPayManager *)defaultManager;

- (BOOL)handleURL:(NSURL *)url payCompletionBlock:(payCompletionBlock)payCompletionBlock delegate:(_Nonnull id<FDPayManagerDelegate>)delegate;

- (void)pay:(FDPayType)type;

@end

NS_ASSUME_NONNULL_END
