//
//  SEDBTableUser.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/27.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SEDBTableUser.h"
#import <FMDB/FMDatabaseQueue.h>
#import <FMDB/FMDB.h>

@implementation SEDBTableUser {
    
    NSString *_fileName;
    
    FMDatabaseQueue *_queue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"/SETableUser.db"];
        
        
        _queue = [FMDatabaseQueue databaseQueueWithPath:_fileName];
        
        [_queue inDatabase:^(FMDatabase *db) {
            // 创建表
            NSString *sql = @"create table if not exists SETableUser (bodyId text, userId text, userName text, userIcon text)";
            [db executeUpdate:sql];
        }];
        NSAssert(_queue != nil, @"db error when create queue using path");
    }
    return self;
}

- (void)dealloc {
    [_queue close];
}

- (BOOL)insertData:(SEUserModel *)user withBodyId:(NSString *)bodyId {
    __block BOOL success = YES;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"insert into SETableUser (bodyId, userId, userName, userIcon) values (?, ?, ?, ?)";
        BOOL result = [db executeUpdate:sql, bodyId,user.userId, user.userName, user.userIcon];
        success = result;
        if (result == NO) {
            *rollback = YES;
        }
    }];
    return success;
}

- (BOOL)updateData:(SEUserModel *)user withBodyId:(NSString *)bodyId {
    if ([self deleteDataWithBodyId:bodyId]) {
        return [self insertData:user withBodyId:bodyId];
    } else return NO;
}

- (BOOL)deleteDataWithBodyId:(NSString *)bodyId {
    __block BOOL success = YES;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"delete from SETableUser where bodyId = ?";
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
        NSString *sql = @"delete from SETableUser";
        BOOL result = [db executeUpdate:sql];
        success = result;
        if (result == NO) {
            *rollback = YES;
        }
    }];
    return success;
}

- (SEUserModel *)userWith:(NSString *)bodyId {
    SEUserModel *model = [[SEUserModel alloc] init];
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"select * from SETableUser where bodyId = ?";
        FMResultSet *resultSet = [db executeQuery:sql, bodyId];
        if ([resultSet next]) {
            model.userId = [resultSet stringForColumn:@"userId"];
            model.userName = [resultSet stringForColumn:@"userName"];
            model.userIcon = [resultSet stringForColumn:@"userIcon"];
        }
    }];
    return model;
}

@end
