//
//  FDStorageManager.m
//  App
//
//  Created by bogokj on 2019/7/9.
//  Copyright © 2019年 范东. All rights reserved.
//

#import "FDSQLiteManager.h"
#import <sqlite3.h>
#import "FDAddressModel.h"

static sqlite3 * dbPoint = Nil;

@implementation FDSQLiteManager

+ (FDSQLiteManager *)defaultManager{
    static FDSQLiteManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

+ (sqlite3 *)open{
    if (dbPoint) {
        return dbPoint;
    }else{
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)lastObject];
        NSString *filePath = [documentPath stringByAppendingPathComponent:@"pcasv.sqlite"];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            sqlite3_open([filePath UTF8String], &dbPoint);
        }else{
            NSString * sourcePath = [[NSBundle mainBundle]pathForResource:@"pcasv" ofType:@"sqlite"];//获得Bundle包里的路径
            BOOL judge = [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:filePath error:NULL];//copy 从sourcePath到destinationPath
            if (judge) {
                DDLogDebug(@"复制 pcasv.sqlite 成功");
            }else{
                DDLogDebug(@"复制 pcasv.sqlite 失败");
            }
        }
        return dbPoint;
    }
}

+ (void)close{
    sqlite3_close(dbPoint);
}

+ (NSArray *)findAllProvince{
    sqlite3 * db = [FDSQLiteManager open];
    sqlite3_stmt * stmt;
    
    int result = sqlite3_prepare_v2(db, "SELECT * FROM province", -1, &stmt, NULL);
    if (SQLITE_OK == result) {
        NSMutableArray * provinces = [NSMutableArray array];
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char * code = sqlite3_column_text(stmt, 0);
            const unsigned char * name = sqlite3_column_text(stmt, 1);
            NSString * currentCode = [NSString stringWithUTF8String:(const char *)code];
            NSString * currentName = [NSString stringWithUTF8String:(const char *)name];
            FDAddressModel *model = [[FDAddressModel alloc]init];
            model.code = currentCode;
            model.name = currentName;
            [provinces addObject:model];
        }
        sqlite3_finalize(stmt);
        return provinces;
    }else{
        sqlite3_finalize(stmt);
    }
    [FDSQLiteManager close];
    return [NSArray array];
}

@end
