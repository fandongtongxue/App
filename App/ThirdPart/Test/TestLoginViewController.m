//
//  TestLoginViewController.m
//  App
//
//  Created by bogokj on 2019/4/30.
//  Copyright © 2019年 范东. All rights reserved.
//

#import "TestLoginViewController.h"
#import "FDSocialManager.h"

@interface TestLoginViewController ()

@end

@implementation TestLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)weiboLoginBtnAction:(id)sender {
    [[FDSocialManager defaultManager] login:FDSocialManagerLoginTypeWeibo currentViewController:self completion:^(FDSocialAuthModel *model, NSString *errorMsg) {
        NSLog(@"");
    }];
}
- (IBAction)qqLoginBtnAction:(id)sender {
    [[FDSocialManager defaultManager] login:FDSocialManagerLoginTypeQQ currentViewController:self completion:^(FDSocialAuthModel *model, NSString *errorMsg) {
        NSLog(@"");
    }];
}
- (IBAction)wechatLoginBtnAction:(id)sender {
    [[FDSocialManager defaultManager] login:FDSocialManagerLoginTypeWeChat currentViewController:self completion:^(FDSocialAuthModel *model, NSString *errorMsg) {
        NSLog(@"");
    }];
}
- (IBAction)weiboShareBtnAction:(id)sender {
    
}
- (IBAction)qqShareBtnAction:(id)sender {
    
}
- (IBAction)wechatShareBtnAction:(id)sender {
    
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
