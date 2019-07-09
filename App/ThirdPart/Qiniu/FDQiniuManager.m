//
//  FDQiniuManager.m
//  App
//
//  Created by bogokj on 2019/7/6.
//  Copyright © 2019年 范东. All rights reserved.
//

#import "FDQiniuManager.h"
#import <Qiniu/QiniuSDK.h>

@implementation FDQiniuManager

+ (FDQiniuManager *)defaultManager{
    static FDQiniuManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)uploadImage:(UIImage *)image key:(NSString *)key progress:(progressHandler)progress completion:(completionHandler)completion{
    NSString *token = @"从服务端SDK获取";
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    QNUploadOption *upOption =[[QNUploadOption alloc]initWithProgressHandler:^(NSString *key, float percent) {
        if (progress) {
            progress(percent);
        }
    }];
    NSData *data = UIImageJPEGRepresentation(image, 1);
    [upManager putData:data key:key token:token
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  DDLogDebug(@"QNResponseInfo:%@\nresp:%@",info,resp);
                  if (completion) {
                      completion(resp);
                  }
              } option:upOption];
}

@end
