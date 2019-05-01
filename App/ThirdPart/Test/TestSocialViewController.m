//
//  TestLoginViewController.m
//  App
//
//  Created by bogokj on 2019/4/30.
//  Copyright © 2019年 范东. All rights reserved.
//

#import "TestSocialViewController.h"
#import "FDSocialManager.h"
#import "FDSocialModel.h"

@interface TestSocialViewController ()

@end

@implementation TestSocialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)weiboLoginBtnAction:(id)sender {
    [[FDSocialManager defaultManager] login:FDSocialManagerLoginTypeWeibo currentViewController:self completion:^(FDSocialModel *model, NSString *errorMsg) {
        NSLog(@"");
    }];
}
- (IBAction)qqLoginBtnAction:(id)sender {
    [[FDSocialManager defaultManager] login:FDSocialManagerLoginTypeQQ currentViewController:self completion:^(FDSocialModel *model, NSString *errorMsg) {
        NSLog(@"");
    }];
}
- (IBAction)wechatLoginBtnAction:(id)sender {
    [[FDSocialManager defaultManager] login:FDSocialManagerLoginTypeWeChat currentViewController:self completion:^(FDSocialModel *model, NSString *errorMsg) {
        NSLog(@"");
    }];
}
- (IBAction)weiboShareBtnAction:(id)sender {
    
    [[FDSocialManager defaultManager] share:FDSocialManagerLoginTypeWeibo object:[self shareModel] currentViewController:self completion:^(FDSocialModel *model, NSString *errorMsg) {
        NSLog(@"");
    }];
}
- (IBAction)qqShareBtnAction:(id)sender {
    [[FDSocialManager defaultManager] share:FDSocialManagerLoginTypeQQ object:[self shareModel] currentViewController:self completion:^(FDSocialModel *model, NSString *errorMsg) {
        NSLog(@"");
    }];
}
- (IBAction)wechatShareBtnAction:(id)sender {
    [[FDSocialManager defaultManager] share:FDSocialManagerLoginTypeWeChat object:[self shareModel] currentViewController:self completion:^(FDSocialModel *model, NSString *errorMsg) {
        NSLog(@"");
    }];
}

- (FDSocialShareModel *)shareModel{
    FDSocialShareModel *model = [[FDSocialShareModel alloc]init];
    model.title = @"测试标题";
    model.descr = @"测试描述";
    model.thumbImage = @"http://qiniu.cloud.fandong.me/Image_iP2013_10_06_13_25_01%20%28104%29.jpg";
    model.webpageUrl = @"http://blog.fandong.me";
    return model;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
