//
//  SEDBTableImages.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/27.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SEDBTableImages.h"
#import <FMDB/FMDatabaseQueue.h>
#import <FMDB/FMDB.h>

@implementation SEDBTableImages {
    
    NSString *_fileName;
    
    FMDatabaseQueue *_queue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"/SETableImages.db"];
        
        
        _queue = [FMDatabaseQueue databaseQueueWithPath:_fileName];
        
        [_queue inDatabase:^(FMDatabase *db) {
            // 创建表
            NSString *sql = @"create table if not exists SETableImages (bodyId text, imageUrl text, highQualityImageURL text, imageHeight text, imageWidth text)";
            [db executeUpdate:sql];
        }];
        NSAssert(_queue != nil, @"db error when create queue using path");
    }
    return self;
}

- (void)dealloc {
    [_queue close];
}

- (BOOL)insertData:(SEImageModel *)image withBodyId:(NSString *)bodyId {
    __block BOOL success = YES;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"insert into SETableImages (bodyId, imageUrl, highQualityImageURL, imageHeight, imageWidth) values (?, ?, ?, ?, ?)";
        BOOL result = [db executeUpdate:sql, bodyId, image.imageUrl, image.highQualityImageURL, image.imageHeight, image.imageWidth];
        success = result;
        if (result == NO) {
            *rollback = YES;
        }
    }];
    return success;
}

- (BOOL)insertDatas:(NSArray *)images withBodyId:(NSString *)bodyId {
    __block BOOL success = YES;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (SEImageModel *image in images) {
            NSString *sql = @"insert into SETableImages (bodyId, imageUrl, highQualityImageURL, imageHeight, imageWidth) values (?, ?, ?, ?, ?)";
            BOOL result = [db executeUpdate:sql, bodyId, image.imageUrl, image.highQualityImageURL, @(image.imageHeight), @(image.imageWidth)];
            success = result;
            if (result == NO) {
                *rollback = YES;
                break ;
            }
        }
    }];
    return success;
}

- (BOOL)deleteDataWithBodyId:(NSString *)bodyId {
    __block BOOL success = YES;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"delete from SETableImages where bodyId = ?";
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
        NSString *sql = @"delete from SETableImages";
        BOOL result = [db executeUpdate:sql];
        success = result;
        if (result == NO) {
            *rollback = YES;
        }
    }];
    return success;
}

- (NSMutableArray<SEImageModel *> *)imagesWith:(NSString *)bodyId {
    NSMutableArray *images = [NSMutableArray array];
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"select * from SETableImages where bodyId = ?";
        FMResultSet *resultSet = [db executeQuery:sql, bodyId];
        while ([resultSet next]) {
            SEImageModel *model = [[SEImageModel alloc] init];
            model.imageUrl = [resultSet stringForColumn:@"imageUrl"];
            model.highQualityImageURL = [resultSet stringForColumn:@"highQualityImageURL"];
            model.imageHeight = [resultSet doubleForColumn:@"imageHeight"];
            model.imageWidth = [resultSet doubleForColumn:@"imageWidth"];
            
            [images addObject:model];
        }
    }];
    return images;
}

@end
