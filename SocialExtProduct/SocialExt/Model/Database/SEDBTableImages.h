//
//  SEDBTableImages.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/27.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEImageModel.h"

@interface SEDBTableImages : NSObject

/**
 插入一条图片数据
 
 @param image 图片数据
 @param bodyId 动态ID
 */
- (BOOL)insertData:(SEImageModel *)image withBodyId:(NSString *)bodyId;

/**
 插入一组图片数据
 
 @param images 图片数据
 @param bodyId 动态ID
 */
- (BOOL)insertDatas:(NSArray *)images withBodyId:(NSString *)bodyId;

/**
 删除指定动态下的全部图片数据
 
 @param bodyId 动态ID
 */
- (BOOL)deleteDataWithBodyId:(NSString *)bodyId;

/**
 删除全部数据
 */
- (BOOL)deleteAllData;

/**
 查询指定动态下的全部图片数据
 
 @param bodyId 评论ID
 @return 全部图片数据
 */
- (NSMutableArray <SEImageModel *> *)imagesWith:(NSString *)bodyId;

@end
