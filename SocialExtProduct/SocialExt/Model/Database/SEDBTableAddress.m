//
//  SEDBTableAddress.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/27.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SEDBTableAddress.h"

#import <FMDB/FMDatabaseQueue.h>
#import <FMDB/FMDB.h>

@implementation SEDBTableAddress {
    
    NSString *_fileName;
    
    FMDatabaseQueue *_queue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"/SETableAddress.db"];
        
        
        _queue = [FMDatabaseQueue databaseQueueWithPath:_fileName];
        
        [_queue inDatabase:^(FMDatabase *db) {
            // 创建表
            NSString *sql = @"create table if not exists SETableAddress (bodyId text, addressName text, addressUrl text)";
            [db executeUpdate:sql];
        }];
        NSAssert(_queue != nil, @"db error when create queue using path");
    }
    return self;
}

- (void)dealloc {
    [_queue close];
}

- (BOOL)insertData:(SEAddressModel *)address withBodyId:(NSString *)bodyId {
    __block BOOL success = YES;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"insert into SETableAddress (bodyId, addressName, addressUrl) values (?, ?, ?)";
        BOOL result = [db executeUpdate:sql, bodyId, address.addressName, address.addressUrl];
        success = result;
        if (result == NO) {
            *rollback = YES;
        }
    }];
    return success;
}

- (BOOL)deleteDataWithBodyId:(NSString *)bodyId {
    __block BOOL success = YES;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"delete from SETableAddress where bodyId = ?";
        BOOL result = [db executeUpdate:sql, bodyId];
        success = result;
        if (result == NO) {
            *rollback = YES;
        }
    }];
    return success;
}

- (BOOL)deleteAllData {
    __block BOOL success = YES;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"delete from SETableAddress";
        BOOL result = [db executeUpdate:sql];
        success = result;
        if (result == NO) {
            *rollback = YES;
        }
    }];
    return success;
}

- (SEAddressModel *)addressWith:(NSString *)bodyId {
    __block SEAddressModel *model = nil;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"select * from SETableAddress where bodyId = ?";
        FMResultSet *resultSet = [db executeQuery:sql, bodyId];
        if ([resultSet next]) {
            model = [[SEAddressModel alloc] init];
            model.addressName = [resultSet stringForColumn:@"addressName"];
            model.addressUrl = [resultSet stringForColumn:@"addressUrl"];
        }
    }];
    return model;
}
@end
