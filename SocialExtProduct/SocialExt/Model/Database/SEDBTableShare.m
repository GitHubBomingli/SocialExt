//
//  SEDBTableShare.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/27.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SEDBTableShare.h"

#import <FMDB/FMDatabaseQueue.h>
#import <FMDB/FMDB.h>

@implementation SEDBTableShare {
    
    NSString *_fileName;
    
    FMDatabaseQueue *_queue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"/SETableShare.db"];
        
        
        _queue = [FMDatabaseQueue databaseQueueWithPath:_fileName];
        
        [_queue inDatabase:^(FMDatabase *db) {
            // 创建表
            NSString *sql = @"create table if not exists SETableShare (bodyId text, shareIcon text, shareTitle text, shareUrl text)";
            [db executeUpdate:sql];
        }];
        NSAssert(_queue != nil, @"db error when create queue using path");
    }
    return self;
}

- (void)dealloc {
    [_queue close];
}

- (BOOL)insertData:(SEShareModel *)share withBodyId:(NSString *)bodyId {
    __block BOOL success = YES;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"insert into SETableShare (bodyId, shareIcon, shareTitle, shareUrl) values (?, ?, ?, ?)";
        BOOL result = [db executeUpdate:sql, bodyId, share.shareIcon, share.shareTitle, share.shareUrl];
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
        NSString *sql = @"delete from SETableShare where bodyId = ?";
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
        NSString *sql = @"delete from SETableShare";
        BOOL result = [db executeUpdate:sql];
        success = result;
        if (result == NO) {
            *rollback = YES;
        }
    }];
    return success;
}

- (SEShareModel *)shareWith:(NSString *)bodyId {
    __block SEShareModel *model = nil;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"select * from SETableShare where bodyId = ?";
        FMResultSet *resultSet = [db executeQuery:sql, bodyId];
        if ([resultSet next]) {
            model = [[SEShareModel alloc] init];
            model.shareIcon = [resultSet stringForColumn:@"shareIcon"];
            model.shareTitle = [resultSet stringForColumn:@"shareTitle"];
            model.shareUrl = [resultSet stringForColumn:@"shareUrl"];
        }
    }];
    return model;
}
@end
