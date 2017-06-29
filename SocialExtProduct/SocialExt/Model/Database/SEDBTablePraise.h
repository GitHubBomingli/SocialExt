//
//  SEDBTablePraise.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/27.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEPraiseModel.h"

@interface SEDBTablePraise : NSObject

/**
 插入一条点赞数据
 
 @param praise 点赞数据
 @param bodyId 动态ID
 */
- (BOOL)insertData:(SEPraiseModel *)praise withBodyId:(NSString *)bodyId;

/**
 插入一组点赞数据
 
 @param praises 点赞数据
 @param bodyId 动态ID
 */
- (BOOL)insertDatas:(NSArray *)praises withBodyId:(NSString *)bodyId;

/**
 更新指定动态下的数据
 
 @param praises 点赞数据
 @param bodyId 动态ID
 */
- (BOOL)updateDatas:(NSArray *)praises  withBodyId:(NSString *)bodyId;

/**
 删除一条点赞
 
 @param praiseId 点赞ID
 */
- (BOOL)deleteDataWithPraiseId:(NSString *)praiseId;

/**
 删除指定动态下的全部点赞
 
 @param bodyId 动态ID
 */
- (BOOL)deleteDataWithBodyId:(NSString *)bodyId;

/**
 删除全部数据
 */
- (BOOL)deleteAllData;

/**
 查询指定动态下的全部点赞
 
 @param bodyId 评论ID
 @return 全部点赞列表
 */
- (NSMutableArray <SEPraiseModel *> *)praisesWith:(NSString *)bodyId;

@end
