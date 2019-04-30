//
//  UIViewController+FD.m
//  QiniuCloudStorge
//
//  Created by 范东 on 16/9/29.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "UIViewController+FD.h"

@implementation UIViewController (FD)

- (void)showAlert:(NSString *)alertString{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:alertString message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertVC dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
