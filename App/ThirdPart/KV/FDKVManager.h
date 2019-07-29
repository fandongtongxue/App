//
//  FDKVManager.h
//  App
//
//  Created by bogokj on 2019/7/26.
//  Copyright © 2019 范东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDKVManager : NSObject

+ (FDKVManager *)defaultManager;

- (void)setObject:(id)object forKey:(NSString *)key;

- (void)setBool:(BOOL)object forKey:(NSString *)key;

- (id)getObjectOfClass:(NSString *)className ForKey:(NSString *)key;

- (BOOL)boolForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
