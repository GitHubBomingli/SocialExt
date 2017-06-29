//
//  SEDBTableBody.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/27.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SEDBTableBody.h"
#import <FMDB/FMDatabaseQueue.h>
#import <FMDB/FMDB.h>

@interface SEDBTableBody ()

@property (nonatomic, strong) SEDBTableUser *tableUser;

@property (nonatomic, strong) SEDBTableImages *tableImages;

@property (nonatomic, strong) SEDBTableShare *tableShare;

@property (nonatomic, strong) SEDBTableAddress *tableAddress;

@property (nonatomic, strong) SEDBTableSource *tableSource;

@property (nonatomic, strong) SEDBTablePraise *tablePraise;

@property (nonatomic, strong) SEDBTableComment *tableComment;

@end

@implementation SEDBTableBody {
    
    NSString *_fileName;
    
    FMDatabaseQueue *_queue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"/SETableBody.db"];
        
        
        _queue = [FMDatabaseQueue databaseQueueWithPath:_fileName];
        
        [_queue inDatabase:^(FMDatabase *db) {
            // 创建表
            NSString *sql = @"create table if not exists SETableBody (bodyId text, type text, content text, video text, date text)";
            [db executeUpdate:sql];
        }];
        NSAssert(_queue != nil, @"db error when create queue using path");
    }
    return self;
}
//添加新字段
- (BOOL)insertProperty:(NSString *)property {
    __block BOOL success = YES;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if (![db columnExists:property inTableWithName:@"SETableBody"]) {//判断是否已经存在
            NSString *sql = [NSString stringWithFormat:@"alert table SETableBody add %@ text", property];
            success = [db executeUpdate:sql];
        }
    }];
    return success;
}

- (void)dealloc {
    [_queue close];
}

- (BOOL)insertData:(SEBodyModel *)body {
    __block BOOL success = YES;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"insert into SETableBody (bodyId, type, content, video, date) values (?, ?, ?, ?, ?)";
        BOOL result = [db executeUpdate:sql, body.bodyId, @(body.type), body.content, body.video, body.date];
        
        result = [self.tableUser insertData:body.user withBodyId:body.bodyId];
        result = [self.tableAddress insertData:body.address withBodyId:body.bodyId];
        result = [self.tableSource insertData:body.source withBodyId:body.bodyId];
        result = [self.tablePraise insertDatas:body.praises withBodyId:body.bodyId];
        result = [self.tableComment insertDatas:body.comments withbodyId:body.bodyId];
        if (body.type == KSEBodyTypeImageText) {
            result = [self.tableImages insertDatas:body.images withBodyId:body.bodyId];
        } else if (body.type == KSEBodyTypeShareText) {
            result = [self.tableShare insertData:body.share withBodyId:body.bodyId];
        }
        
        success = result;
        if (result == NO) {
            *rollback = YES;
        }
    }];
    return success;
}

- (BOOL)insertDatas:(NSArray<SEBodyModel *> *)bodys {
    __block BOOL success = YES;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (SEBodyModel *body in bodys) {
            NSString *sql = @"insert into SETableBody (bodyId, type, content, video, date) values (?, ?, ?, ?, ?)";
            BOOL result = [db executeUpdate:sql, body.bodyId, @(body.type), body.content, body.video, body.date];
            
            result = [self.tableUser insertData:body.user withBodyId:body.bodyId];
            result = [self.tableAddress insertData:body.address withBodyId:body.bodyId];
            result = [self.tableSource insertData:body.source withBodyId:body.bodyId];
            result = [self.tablePraise insertDatas:body.praises withBodyId:body.bodyId];
            result = [self.tableComment insertDatas:body.comments withbodyId:body.bodyId];
            if (body.type == KSEBodyTypeImageText) {
                result = [self.tableImages insertDatas:body.images withBodyId:body.bodyId];
            } else if (body.type == KSEBodyTypeShareText) {
                result = [self.tableShare insertData:body.share withBodyId:body.bodyId];
            }
            
            success = result;
            if (result == NO) {
                *rollback = YES;
                break;
            }
        }
    }];
    return success;
}

- (BOOL)updateData:(SEBodyModel *)body {
    __block BOOL success = YES;
    __block BOOL exists = NO;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *resultSet = [db executeQuery:@"select count(*) as bodyId from SETableBody where bodyId = ?", body.bodyId];
        if ([resultSet next]) {
            if ([resultSet intForColumn:@"bodyId"]) {
                success = [db executeUpdate:@"update SETableBody set type=?, content=?, video=?, date=? where bodyId = ?", @(body.type), body.content, body.video, body.date, body.bodyId];
                success = [self.tableUser updateData:body.user withBodyId:body.bodyId];
                success = [self.tablePraise updateDatas:body.praises withBodyId:body.bodyId];
                success = [self.tableComment updateDatas:body.comments withbodyId:body.bodyId];
                
                exists = YES;
            }
        }
    }];
    if (exists == NO) {
        success = [self insertData:body];
    }
    return success;
}

- (BOOL)updateDatas:(NSArray<SEBodyModel *> *)bodys {
    __block BOOL success = YES;
    int count = 0;
    for (int index = 0; index < bodys.count; index ++) {
        SEBodyModel *body = bodys[index];
        success = [self updateData:body];
        count = index;
        if (success == NO) {
            break ;
        }
    }
    if (success == NO) {
        for (int index = 0; index < count; index ++) {
            SEBodyModel *body = bodys[index];
            [self deleteDataWithBodyId:body.bodyId];
        }
    }
    return success;
}

- (BOOL)deleteDataWithBodyId:(NSString *)bodyId {
    __block BOOL success = YES;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"delete from SETableBody where bodyId = ?";
        BOOL result = [db executeUpdate:sql, bodyId];
        
        result = [self.tableUser deleteDataWithBodyId:bodyId];
        result = [self.tableAddress deleteDataWithBodyId:bodyId];
        result = [self.tableImages deleteDataWithBodyId:bodyId];
        result = [self.tableShare deleteDataWithBodyId:bodyId];
        result = [self.tableSource deleteDataWithBodyId:bodyId];
        result = [self.tablePraise deleteDataWithBodyId:bodyId];
        result = [self.tableComment deleteDataWithBodyId:bodyId];
        
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
        NSString *sql = @"delete from SETableBody";
        BOOL result = [db executeUpdate:sql];
        
        result = [self.tableUser deleteAllData];
        result = [self.tableAddress deleteAllData];
        result = [self.tableImages deleteAllData];
        result = [self.tableShare deleteAllData];
        result = [self.tableSource deleteAllData];
        result = [self.tablePraise deleteAllData];
        result = [self.tableComment deleteAllData];
        
        success = result;
        if (result == NO) {
            *rollback = YES;
        }
    }];
    return success;
}

- (SEBodyModel *)bodyWith:(NSString *)bodyId {
    __block SEBodyModel *model = nil;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"select * from SETableBody where bodyId = ?";
        FMResultSet *resultSet = [db executeQuery:sql, bodyId];
        if ([resultSet next]) {
            model = [[SEBodyModel alloc] init];
            model.bodyId = [resultSet stringForColumn:@"bodyId"];
            model.type = [resultSet intForColumn:@"type"];
            model.content = [resultSet stringForColumn:@"content"];
            model.video = [resultSet stringForColumn:@"video"];
            model.date = [resultSet stringForColumn:@"date"];
            
            model.user = [self.tableUser userWith:model.bodyId];
            model.address = [self.tableAddress addressWith:model.bodyId];
            model.images = [self.tableImages imagesWith:model.bodyId];
            model.share = [self.tableShare shareWith:model.bodyId];
            model.source = [self.tableSource sourceWith:model.bodyId];
            model.praises = [self.tablePraise praisesWith:model.bodyId];
            model.comments = [self.tableComment commentsWith:model.bodyId];
        }
    }];
    return model;
}

- (NSMutableArray<SEBodyModel *> *)allData {
    NSMutableArray <SEBodyModel *> *alls = [NSMutableArray array];
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"select * from SETableBody";
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            SEBodyModel *model = [[SEBodyModel alloc] init];
            model.bodyId = [resultSet stringForColumn:@"bodyId"];
            model.type = [resultSet intForColumn:@"type"];
            model.content = [resultSet stringForColumn:@"content"];
            model.video = [resultSet stringForColumn:@"video"];
            model.date = [resultSet stringForColumn:@"date"];
            
            model.user = [self.tableUser userWith:model.bodyId];
            model.address = [self.tableAddress addressWith:model.bodyId];
            model.images = [self.tableImages imagesWith:model.bodyId];
            model.share = [self.tableShare shareWith:model.bodyId];
            model.source = [self.tableSource sourceWith:model.bodyId];
            model.praises = [self.tablePraise praisesWith:model.bodyId];
            model.comments = [self.tableComment commentsWith:model.bodyId];
            
            [alls addObject:model];
        }
    }];
    //按时间降序排列
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    [alls sortUsingDescriptors:@[sort]];
    
    return alls;
}

#pragma mark - getter
- (SEDBTableUser *)tableUser {
    if (_tableUser == nil) {
        _tableUser = [[SEDBTableUser alloc] init];
    }
    return _tableUser;
}

- (SEDBTableImages *)tableImages {
    if (_tableImages == nil) {
        _tableImages = [[SEDBTableImages alloc] init];
    }
    return _tableImages;
}

- (SEDBTableShare *)tableShare {
    if (_tableShare == nil) {
        _tableShare = [[SEDBTableShare alloc] init];
    }
    return _tableShare;
}

- (SEDBTableAddress *)tableAddress {
    if (_tableAddress == nil) {
        _tableAddress = [[SEDBTableAddress alloc] init];
    }
    return _tableAddress;
}

- (SEDBTableSource *)tableSource {
    if (_tableSource == nil) {
        _tableSource = [[SEDBTableSource alloc] init];
    }
    return _tableSource;
}

- (SEDBTablePraise *)tablePraise {
    if (_tablePraise == nil) {
        _tablePraise = [[SEDBTablePraise alloc] init];
    }
    return _tablePraise;
}

- (SEDBTableComment *)tableComment {
    if (_tableComment == nil) {
        _tableComment = [[SEDBTableComment alloc] init];
    }
    return _tableComment;
}
@end
