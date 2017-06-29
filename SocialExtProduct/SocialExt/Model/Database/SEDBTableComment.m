//
//  SEDBTableComment.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/27.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SEDBTableComment.h"
#import <FMDB/FMDatabaseQueue.h>
#import <FMDB/FMDB.h>

#import "SEDBTableCommenter.h"
#import "SEDBTableToCommenter.h"

@interface SEDBTableComment ()

@property (nonatomic, strong) SEDBTableCommenter *tableCommenter;

@property (nonatomic, strong) SEDBTableToCommenter *tableToCommenter;

@end

@implementation SEDBTableComment {
    
    NSString *_fileName;
    
    FMDatabaseQueue *_queue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"/SETableComments.db"];
        
        _queue = [FMDatabaseQueue databaseQueueWithPath:_fileName];
        
        [_queue inDatabase:^(FMDatabase *db) {
            // 创建表
            NSString *sql = @"create table if not exists SETableComments (bodyId text, commentId text, comment text, type text)";
            [db executeUpdate:sql];
        }];
        NSAssert(_queue != nil, @"db error when create queue using path");
    }
    return self;
}

- (void)dealloc {
    [_queue close];
}

- (BOOL)insertData:(SECommentModel *)comment withbodyId:(NSString *)bodyId {
    __block BOOL success = YES;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"insert into SETableComments (bodyId, commentId, comment, type) values (?, ?, ?, ?)";
        BOOL result = [db executeUpdate:sql, bodyId, comment.commentId, comment.comment, @(comment.type)];
        result = [self.tableCommenter insertData:comment.commenter withCommentId:comment.commentId withBodyId:bodyId];
        result = [self.tableToCommenter insertData:comment.toCommenter withCommentId:comment.commentId withBodyId:bodyId];
        success = result;
        if (result == NO) {
            *rollback = YES;
        }
    }];
    return success;
}

- (BOOL)insertDatas:(NSArray *)comments withbodyId:(NSString *)bodyId {
    __block BOOL success = YES;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (SECommentModel *comment in comments) {
            NSString *sql = @"insert into SETableComments (bodyId, commentId, comment, type) values (?, ?, ?, ?)";
            BOOL result = [db executeUpdate:sql, bodyId, comment.commentId, comment.comment, @(comment.type)];
            result = [self.tableCommenter insertData:comment.commenter withCommentId:comment.commentId withBodyId:bodyId];
            result = [self.tableToCommenter insertData:comment.toCommenter withCommentId:comment.commentId withBodyId:bodyId];
            success = result;
            if (result == NO) {
                *rollback = YES;
                break ;
            }
        }
    }];
    return success;
}

- (BOOL)updateDatas:(NSArray *)comments withbodyId:(NSString *)bodyId {
    if ([self deleteDataWithBodyId:bodyId]) {
        return [self insertDatas:comments withbodyId:bodyId];
    } else return NO;
}

- (BOOL)deleteDataWithCommentId:(NSString *)commentId {
    __block BOOL success = YES;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"delete from SETableComments where commentId = ?";
        BOOL result = [db executeUpdate:sql, commentId];
        result = [self.tableCommenter deleteDataWithCommentId:commentId];
        result = [self.tableToCommenter deleteDataWithCommentId:commentId];
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
        NSString *sql = @"delete from SETableComments where bodyId = ?";
        BOOL result = [db executeUpdate:sql, bodyId];
        result = [self.tableCommenter deleteDataWithBodyId:bodyId];
        result = [self.tableToCommenter deleteDataWithBodyId:bodyId];
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
        NSString *sql = @"delete from SETableComments";
        BOOL result = [db executeUpdate:sql];
        result = [self.tableCommenter deleteAllData];
        result = [self.tableToCommenter deleteAllData];
        success = result;
        if (result == NO) {
            *rollback = YES;
        }
    }];
    return success;
}

- (NSMutableArray<SECommentModel *> *)commentsWith:(NSString *)bodyId {
    NSMutableArray *comments = [NSMutableArray array];
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"select * from SETableComments where bodyId = ?";
        FMResultSet *resultSet = [db executeQuery:sql, bodyId];
        while ([resultSet next]) {
            SECommentModel *model = [[SECommentModel alloc] init];
            model.commentId = [resultSet stringForColumn:@"commentId"];
            model.comment = [resultSet stringForColumn:@"comment"];
            model.type = [resultSet intForColumn:@"type"];
            
            model.commenter = [self.tableCommenter commenterWith:model.commentId];
            model.toCommenter = [self.tableToCommenter toCommenterWith:model.commentId];
            
            [comments addObject:model];
        }
    }];
    return comments;
}

#pragma mark - getter
- (SEDBTableCommenter *)tableCommenter {
    if (_tableCommenter == nil) {
        _tableCommenter = [[SEDBTableCommenter alloc] init];
    }
    return _tableCommenter;
}

- (SEDBTableToCommenter *)tableToCommenter {
    if (_tableToCommenter == nil) {
        _tableToCommenter = [[SEDBTableToCommenter alloc] init];
    }
    return _tableToCommenter;
}

@end
