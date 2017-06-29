//
//  SEDBTableToCommenter.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/27.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEUserModel.h"

@interface SEDBTableToCommenter : NSObject

/**
 插入一条被追问者的数据

 @param toCommenter 被追问者
 @param commentId 评论ID
 @param bodyId 动态ID
 */
- (BOOL)insertData:(SEUserModel *)toCommenter withCommentId:(NSString *)commentId withBodyId:(NSString *)bodyId;

/**
 删除被追问者的数据

 @param commentId 评论ID
 */
- (BOOL)deleteDataWithCommentId:(NSString *)commentId;

/**
 删除被追问者的数据
 
 @param bodyId 动态ID
 */
- (BOOL)deleteDataWithBodyId:(NSString *)bodyId;

/**
 删除全部数据
 */
- (BOOL)deleteAllData;

/**
 查询指定评论的被追问者数据

 @param commentId 评论ID
 @return 被追问者数据
 */
- (SEUserModel *)toCommenterWith:(NSString *)commentId;

@end
