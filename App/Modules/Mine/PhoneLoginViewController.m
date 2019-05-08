//
//  PhoneLoginViewController.m
//  App
//
//  Created by 范东 on 2019/5/8.
//  Copyright © 2019 范东. All rights reserved.
//

#import "PhoneLoginViewController.h"

#import <SMS_SDK/SMSSDK.h>

@interface PhoneLoginViewController ()

@end

@implementation PhoneLoginViewController

- (void)didInitialize {
    [super didInitialize];
    // init 时做的事情请写在这里
}

- (void)initSubviews {
    [super initSubviews];
    // 对 subviews 的初始化写在这里
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

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = Localized(@"Login.PhoneLogin.Title");
}

@end
