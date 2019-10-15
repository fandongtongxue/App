//
//  Define.h
//  App
//
//  Created by bogokj on 2019/5/7.
//  Copyright © 2019年 范东. All rights reserved.
//

#ifndef Define_h
#define Define_h

#define Localized(key)  NSLocalizedString(key, nil)

#define Font(_pointSize) [UIFont fontWithName:@"AlibabaPuHuiTiL" size:_pointSize]

#define kisLogin [[[NSUserDefaults standardUserDefaults] objectForKey:isLogin] boolValue]

#endif /* Define_h */
