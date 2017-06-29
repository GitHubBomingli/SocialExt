//
//  SEDBTableShare.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/27.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEShareModel.h"

@interface SEDBTableShare : NSObject

/**
 插入一条数据
 
 @param share 数据
 @param bodyId 动态ID
 */
- (BOOL)insertData:(SEShareModel *)share withBodyId:(NSString *)bodyId;

/**
 删除指定动态下的数据
 
 @param bodyId 动态ID
 */
- (BOOL)deleteDataWithBodyId:(NSString *)bodyId;

/**
 删除全部数据
 */
- (BOOL)deleteAllData;

/**
 查询指定动态下的数据
 
 @param bodyId 评论ID
 @return 数据
 */
- (SEShareModel*)shareWith:(NSString *)bodyId;

@end
