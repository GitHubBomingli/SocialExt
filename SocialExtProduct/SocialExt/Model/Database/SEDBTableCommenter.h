//
//  SEDBTableCommenter.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/27.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEUserModel.h"

@interface SEDBTableCommenter : NSObject

/**
 插入一条评论者的数据
 
 @param commenter 评论者
 @param commentId 评论ID
 @param bodyId 动态ID
 */
- (BOOL)insertData:(SEUserModel *)commenter withCommentId:(NSString *)commentId withBodyId:(NSString *)bodyId;

/**
 删除评论者的数据
 
 @param commentId 评论ID
 */
- (BOOL)deleteDataWithCommentId:(NSString *)commentId;

/**
 删除指定动态下的全部数据
 
 @param bodyId 动态ID
 */
- (BOOL)deleteDataWithBodyId:(NSString *)bodyId;

/**
 删除全部数据
 */
- (BOOL)deleteAllData;

/**
 查询指定评论的评论者数据
 
 @param commentId 评论ID
 @return 评论者数据
 */
- (SEUserModel *)commenterWith:(NSString *)commentId;

@end
