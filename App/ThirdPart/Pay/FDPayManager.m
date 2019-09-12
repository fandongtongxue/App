//
//  FDPayManager.m
//  App
//
//  Created by 范东 on 2019/5/29.
//  Copyright © 2019 范东. All rights reserved.
//

#import "FDPayManager.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

#import "APOrderInfo.h"
#import "APRSASigner.h"

#import "WXApiRequestHandler.h"

@interface FDPayManager ()<WXApiDelegate>

@end

@implementation FDPayManager

+ (FDPayManager *)defaultManager{
    static FDPayManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)pay:(FDPayType)type{
    switch (type) {
        case FDPayTypeAli:
            [self alipay];
            break;
        case FDPayTypeWeChat:
            [self wxPay];
            break;
        default:
            break;
    }
}

- (void)alipay{
    // 重要说明
    // 这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    // 真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    // 防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = @"2016101100663099";
    
    // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    // 如果商户两个都设置了，优先使用 rsa2PrivateKey
    // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
    // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
    // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
    NSString *rsa2PrivateKey = @"MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCaiyz2vKcUPoCvbr2Oen2aI1DtiYg3AKZIKbTzXoDDnJuMblnH1VeVZEvu6m8y5dkdktsX5tFfFjNdo8GhNyUTdL88Ezyc+V8xqyPl93dEthZfPTWxGo1lpxSsu6HOgnD5LqXV6TyEWBoBBqm2qGABbl5yZGCj2fB3dH3We7UthLo9yCNnA/NFQD/mktiV+kjOSdUSchNgq1e33wTXg2E72RN5sVGcn/fPQ7hT0Ub1ivCyhmWtDmGHL5SsgqtCVwOBFiY1C8cwImVtn6zP16cWnuvRCicwS0UpwKVjJg5VBz2AmgUP+I2cQd6mPrmC7F1D0sB386UGwXjU6tIhjRLJAgMBAAECggEAYCi8/4F+zF/fnkjfdWnOATx8PHDY6rBixn/88XkZ0Zz+RDDdeDPM3U2c2bnRGvBdWcNow8SA/hNIPrmH35H6ZdK8stqdWmbnznXYTlzeP0i1PulNITeOR3Pgr2HIWkBbnxBha2pGl2piM8U7kEXQBtPvvGmsoAcZUpqPOgebQghc4NugIvxI2LID4DDuBnWvTwdK54lp4l38eabKwKD3LjTFT5qe5Gl3MhJ3UkjZNW3CL34myjFCRnHBd3kfmv0uq5gbwCClCqv95zKfj9ctkkHUETuZu9zToqJHit5U72sARgkQxRXSRM1Ho7WnIIJG2qwQKadFLPAKKEF2V2s6yQKBgQDe3LNghATJ2sI5qn6Y2zF88nKrFujWTiUhXbR7QGJgBReUJ3mCtmGFebLiYADA/DJ7fdf3QRuXF9lCUErGuEGSu8GBnSRNP7VnoipZhf9cTfV1KSRXuHaRoTfI7QkHSm7NpYkSiqXzJepzsUnKFa6lO9RaQh4K4HnMxiEpE/THFwKBgQCxheqnzM7ZIMwEcBrwmCUOxtF9PBvH4/sTiYszsye8YC1+I3klOf0iRNS9w+aMo68R8cT60X/TtysuOsDh1tUU6GThtqaeSt8E+1SJk6fePhmcGmViPHA+3kqLsgFbFDBAPNegBz8LphgO+r/bT7N4l+o98hY/KAru0KbKCBkhHwKBgQDXkISVA72Z/dZGbwqbEdHReLW/lZ5LxDSYDIpJeWJuXB6NeI1JCN5Ve/yyiIfSI181IelmyPxF7pSAVyetBYavxpqKo5P8gHYYMrxh8YGqJ+IXnF8B1nQhst5BpD1KZw28LrTiUWfpQ7B+jWrBZK2UN8XUNAXZIX3Ou4pRsHLgqwKBgC6Kq5C+s2Rdot9u/MEjQmPzYCzzO11WuhbPMr2lNL/Af2zYpARMhb8cSKJP3/vzVgzgVAJmNpstJJcENFmBV3AZ1YkPt/M8Meg+dFV1bsdnhJNWoEn3Cn6RDP4+9vgH/PZ6fRWpkK/fJeOXfgFjjewJ+BGxjH+WYfdmoLPLF7uFAoGBAJ795xvFFBRYwrLyXy+Id0lktS8B/jLHp5F5PggSOjsCoF++b7m025T5R6Y0pMBX2NbiNtZKExu/L2pxXiULcKfAt4PS+ey/BOw+TWHrSNK94cEOagYOaaw0zG+9vyGLXOCnzWqAyD4cKqFzIm3Pmr8mOfTE6q1C3PDviFaoNEw+";
    NSString *rsaPrivateKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCcrYtDi7kdth292smBV6cmZMTkC1iANLXAi59/FtAYanLAMW4baJ8zbln14LqGNpMy9V/AUHbKcZ2qh6nebRxdtkWxFCs9lPZEyQT0eG75tOnuJtnKZDKVWtpe6I7jy2B85d1o61CNNHJ0OjIWKxqCXCvbzJH1k7EVN58JzlA2rQIDAQAB";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0))
    {
        //                [SVProgressHUD ]
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    APOrderInfo* order = [APOrderInfo new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [APBizContent new];
    order.biz_content.body = @"我是测试数据";
    order.biz_content.subject = @"1";
    order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    DDLogDebug(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    APRSASigner* signer = [[APRSASigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"alisdkdemo";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            DDLogDebug(@"reslut = %@",resultDic);
        }];
    }
}

#pragma mark   ==============产生随机订单号==============

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

- (void)wxPay{
    NSString *res = [WXApiRequestHandler jumpToBizPay];
    if( ![@"" isEqual:res] ){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"支付失败" message:res preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

- (BOOL)handleURL:(NSURL *)url payCompletionBlock:(payCompletionBlock)payCompletionBlock delegate:(id<FDPayManagerDelegate>)delegate{
    if ([url.host isEqualToString:@"safepay"]){
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            DDLogDebug(@"result = %@",resultDic);
        }];
        return YES;
    }
    else if([url.absoluteString rangeOfString:kWeChatAppKey].location != NSNotFound){
        return  [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

- (void)onResp:(BaseResp *)resp{
    DDLogDebug(@"");
}

@end
