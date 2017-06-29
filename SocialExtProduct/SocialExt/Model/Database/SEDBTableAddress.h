//
//  SEDBTableAddress.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/27.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEAddressModel.h"

@interface SEDBTableAddress : NSObject

/**
 插入一条地址数据
 
 @param address 数据
 @param bodyId 动态ID
 */
- (BOOL)insertData:(SEAddressModel *)address withBodyId:(NSString *)bodyId;

/**
 删除指定动态下的来源数据
 
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
- (SEAddressModel*)addressWith:(NSString *)bodyId;

@end
