//
//  SEDBTableComment.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/27.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SECommentModel.h"

@interface SEDBTableComment : NSObject

/**
 插入一条评论
 
 @param comment 评论
 @param bodyId 动态ID
 */
- (BOOL)insertData:(SECommentModel *)comment withbodyId:(NSString *)bodyId;

/**
 插入一组评论
 
 @param comments 评论
 @param bodyId 动态ID
 */
- (BOOL)insertDatas:(NSArray *)comments withbodyId:(NSString *)bodyId;

/**
 更新指定动态下的数据
 
 @param comments 评论
 @param bodyId 动态ID
 */
- (BOOL)updateDatas:(NSArray *)comments withbodyId:(NSString *)bodyId;

/**
 删除一条评论
 
 @param commentId 评论ID
 */
- (BOOL)deleteDataWithCommentId:(NSString *)commentId;

/**
 删除指定动态下的全部评论
 
 @param bodyId 动态ID
 */
- (BOOL)deleteDataWithBodyId:(NSString *)bodyId;

/**
 删除全部数据
 */
- (BOOL)deleteAllData;

/**
 查询指定动态下的全部评论
 
 @param bodyId 评论ID
 @return 评论列表
 */
- (NSMutableArray <SECommentModel *> *)commentsWith:(NSString *)bodyId;

@end
