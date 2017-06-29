//
//  SEDBTablePraise.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/27.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SEDBTablePraise.h"

#import <FMDB/FMDatabaseQueue.h>
#import <FMDB/FMDB.h>

@implementation SEDBTablePraise {
    
    NSString *_fileName;
    
    FMDatabaseQueue *_queue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"/SETablePraise.db"];
        
        _queue = [FMDatabaseQueue databaseQueueWithPath:_fileName];
        
        [_queue inDatabase:^(FMDatabase *db) {
            // 创建表
            NSString *sql = @"create table if not exists SETablePraise (bodyId text, praiseId text, laudatorId text, laudatorName text)";
            [db executeUpdate:sql];
        }];
        NSAssert(_queue != nil, @"db error when create queue using path");
    }
    return self;
}

- (void)dealloc {
    [_queue close];
}

- (BOOL)insertData:(SEPraiseModel *)praise withBodyId:(NSString *)bodyId {
    __block BOOL success = YES;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"insert into SETablePraise (bodyId, praiseId, laudatorId, laudatorName) values (?, ?, ?, ?)";
        BOOL result = [db executeUpdate:sql, bodyId, praise.praiseId, praise.laudatorId, praise.laudatorName];
        success = result;
        if (result == NO) {
            *rollback = YES;
        }
    }];
    return success;
}

- (BOOL)insertDatas:(NSArray *)praises withBodyId:(NSString *)bodyId {
    __block BOOL success = YES;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (SEPraiseModel *model in praises) {
            NSString *sql = @"insert into SETablePraise (bodyId, praiseId, laudatorId, laudatorName) values (?, ?, ?, ?)";
            BOOL result = [db executeUpdate:sql, bodyId, model.praiseId, model.laudatorId, model.laudatorName];
            success = result;
            if (result == NO) {
                *rollback = YES;
                break ;
            }
        }
    }];
    return success;
}

- (BOOL)updateDatas:(NSArray *)praises withBodyId:(NSString *)bodyId {
    if ([self deleteDataWithBodyId:bodyId]) {
        return [self insertDatas:praises withBodyId:bodyId];
    } else return NO;
}

- (BOOL)deleteDataWithPraiseId:(NSString *)praiseId {
    __block BOOL success = YES;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"delete from SETablePraise where praiseId = ?";
        BOOL result = [db executeUpdate:sql, praiseId];
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
        NSString *sql = @"delete from SETablePraise where bodyId = ?";
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
        NSString *sql = @"delete from SETablePraise";
        BOOL result = [db executeUpdate:sql];
        success = result;
        if (result == NO) {
            *rollback = YES;
        }
    }];
    return success;
}

- (NSMutableArray<SEPraiseModel *> *)praisesWith:(NSString *)bodyId {
    NSMutableArray *praises = [NSMutableArray array];
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"select * from SETablePraise where bodyId = ?";
        FMResultSet *resultSet = [db executeQuery:sql, bodyId];
        while ([resultSet next]) {
            SEPraiseModel *model = [[SEPraiseModel alloc] init];
            model.praiseId = [resultSet stringForColumn:@"praiseId"];
            model.laudatorId = [resultSet stringForColumn:@"laudatorId"];
            model.laudatorName = [resultSet stringForColumn:@"laudatorName"];
            
            [praises addObject:model];
        }
    }];
    return praises;
}

@end
