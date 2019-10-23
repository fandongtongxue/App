//
//  PhoneLoginViewController.h
//  App
//
//  Created by 范东 on 2019/5/8.
//  Copyright © 2019 范东. All rights reserved.
//

#import "FDViewController.h"

typedef void(^finishPhoneLoginCallBack)(NSString *mobile);

@interface PhoneLoginViewController : FDViewController

@property(nonatomic, copy) finishPhoneLoginCallBack finishPhoneLoginCallBack;

- (instancetype)initWithCallBack:(finishPhoneLoginCallBack)finishPhoneLoginCallBack;

@end
