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
#import <QuickMobileTextField/QuickMaterialMobileTextField.h>

@interface PhoneLoginViewController ()

@property(nonatomic, strong) QuickMaterialMobileTextField *phoneTextField;
@property(nonatomic, strong) QuickSecurityCode *codeTextField;

@end

@implementation PhoneLoginViewController

- (instancetype)initWithCallBack:(finishPhoneLoginCallBack)finishPhoneLoginCallBack{
    if (self = [super init]) {
        self.finishPhoneLoginCallBack = finishPhoneLoginCallBack;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 对 self.view 的操作写在这里
    [self.view addSubview:self.phoneTextField];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (textField.text.length == 11 + 2) {
        self.phoneTextField.hidden = YES;
        [self.view addSubview:self.codeTextField];
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:textField.text zone:@"86" template:nil result:^(NSError *error) {
            if (error) {
                DDLogDebug(@"验证码获取失败:%@",error);
            }else{
                DDLogDebug(@"验证码获取成功");
            }
        }];
    }
}

- (QuickSecurityCode *)codeTextField{
    if (!_codeTextField) {
        _codeTextField = [[QuickSecurityCode alloc]initWithFrame:_phoneTextField.frame];
        __weak __typeof(self)weakSelf = self;
        [_codeTextField setComplete:^(NSString *code) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [SMSSDK commitVerificationCode:code phoneNumber:strongSelf.phoneTextField.text zone:@"86" result:^(NSError *error) {
                if (error) {
                    DDLogDebug(@"验证码验证失败:%@",error);
                }else{
                    DDLogDebug(@"验证码验证成功");
                    if (strongSelf->_finishPhoneLoginCallBack) {
                        strongSelf->_finishPhoneLoginCallBack();
                    }
                }
            }];
        }];
    }
    return _codeTextField;
}

- (QuickMaterialMobileTextField *)phoneTextField{
    if (!_phoneTextField) {
        _phoneTextField = [[QuickMaterialMobileTextField alloc]initWithFrame:CGRectMake(20, StatusBarHeight + NavigationBarHeight + 20, SCREEN_WIDTH - 40, 44)];
        _phoneTextField.nextdelegate = self;
        _phoneTextField.placeholderColor = UIColorGray;
        _phoneTextField.placeholder = @"请输入手机号码";
        [_phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _phoneTextField;
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = Localized(@"Login.PhoneLogin.Title");
}

@end
