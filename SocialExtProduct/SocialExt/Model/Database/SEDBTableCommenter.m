//
//  SEDBTableCommenter.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/27.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SEDBTableCommenter.h"
#import <FMDB/FMDatabaseQueue.h>
#import <FMDB/FMDB.h>

@implementation SEDBTableCommenter {
    
    NSString *_fileName;
    
    FMDatabaseQueue *_queue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"/SETableCommenter.db"];
        
        
        _queue = [FMDatabaseQueue databaseQueueWithPath:_fileName];
        
        [_queue inDatabase:^(FMDatabase *db) {
            // 创建表
            NSString *sql = @"create table if not exists SETableCommenter (bodyId text, commentId text, userId text, userName text, userIcon text)";
            [db executeUpdate:sql];
        }];
        NSAssert(_queue != nil, @"db error when create queue using path");
    }
    return self;
}

- (void)dealloc {
    [_queue close];
}

- (BOOL)insertData:(SEUserModel *)commenter withCommentId:(NSString *)commentId withBodyId:(NSString *)bodyId {
    __block BOOL success = YES;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"insert into SETableCommenter (bodyId, commentId, userId, userName, userIcon) values (?, ?, ?, ?, ?)";
        BOOL result = [db executeUpdate:sql, bodyId, commentId, commenter.userId, commenter.userName, commenter.userIcon];
        success = result;
        if (result == NO) {
            *rollback = YES;
        }
    }];
    return success;
}

- (BOOL)deleteDataWithCommentId:(NSString *)commentId {
    __block BOOL success = YES;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"delete from SETableCommenter where commentId = ?";
        BOOL result = [db executeUpdate:sql, commentId];
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
        NSString *sql = @"delete from SETableCommenter where bodyId = ?";
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
        NSString *sql = @"delete from SETableCommenter";
        BOOL result = [db executeUpdate:sql];
        success = result;
        if (result == NO) {
            *rollback = YES;
        }
    }];
    return success;
}

- (SEUserModel *)commenterWith:(NSString *)commentId {
    __block SEUserModel *model = nil;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"select * from SETableCommenter where commentId = ?";
        FMResultSet *resultSet = [db executeQuery:sql, commentId];
        if ([resultSet next]) {
            model = [[SEUserModel alloc] init];
            model.userId = [resultSet stringForColumn:@"userId"];
            model.userName = [resultSet stringForColumn:@"userName"];
            model.userIcon = [resultSet stringForColumn:@"userIcon"];
        }
    }];
    return model;
}

@end
