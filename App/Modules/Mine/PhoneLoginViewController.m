//
//  PhoneLoginViewController.m
//  App
//
//  Created by 范东 on 2019/5/8.
//  Copyright © 2019 范东. All rights reserved.
//

#import "PhoneLoginViewController.h"

#import <SMS_SDK/SMSSDK.h>

#import <QuickSecurityCode/QuickSecurityCode.h>
#import <QuickMobileTextField/QuickMobileTextField.h>

@interface PhoneLoginViewController ()<QuickMobileTextFieldDelegate>

@property(nonatomic, strong) QuickMobileTextField *phoneTextField;
@property(nonatomic, strong) QuickSecurityCode *codeTextField;

@end

@implementation PhoneLoginViewController

- (void)didInitialize {
    [super didInitialize];
    // init 时做的事情请写在这里
}

- (void)initSubviews {
    [super initSubviews];
    // 对 subviews 的初始化写在这里
//    [[UIApplication sharedApplication].keyWindow addSubview:self.codeTextField];
//    self.codeTextField.center = [UIApplication sharedApplication].keyWindow.center;
    
    [self.view addSubview:self.phoneTextField];
    self.phoneTextField.center = self.view.center;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 对 self.view 的操作写在这里
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

- (QuickSecurityCode *)codeTextField{
    if (!_codeTextField) {
        _codeTextField = [[QuickSecurityCode alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
//        __weak __typeof(self)weakSelf = self;
        [_codeTextField setComplete:^(NSString *code) {
//            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
        }];
    }
    return _codeTextField;
}

- (QuickMobileTextField *)phoneTextField{
    if (!_phoneTextField) {
        _phoneTextField = [[QuickMobileTextField alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40, 44)];
        _phoneTextField.nextdelegate = self;
        _phoneTextField.placeholderColor = UIColorGray;
        _phoneTextField.placeholder = @"请输入手机号码";
    }
    return _phoneTextField;
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = Localized(@"Login.PhoneLogin.Title");
}

@end
