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

#ifdef DEBUG

#define DLOG(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#else

#define DLOG(...)

#endif

#endif /* Define_h */
