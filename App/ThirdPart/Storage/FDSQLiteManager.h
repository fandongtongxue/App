//
//  FDStorageManager.h
//  App
//
//  Created by bogokj on 2019/7/9.
//  Copyright © 2019年 范东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDSQLiteManager : NSObject

+ (FDSQLiteManager *)defaultManager;

+ (NSArray *)findAllProvince;

+ (NSArray *)findAllCityWithProvinceCode:(NSString *)code;

+ (NSArray *)findAllAreaWithCityCode:(NSString *)code;

+ (NSArray *)findAllStreetWithAreaCode:(NSString *)code;

+ (NSArray *)findAllVillageWithStreetCode:(NSString *)code;

@end

NS_ASSUME_NONNULL_END
