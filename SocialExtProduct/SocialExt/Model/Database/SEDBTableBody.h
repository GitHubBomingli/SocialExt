//
//  SEDBTableBody.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/27.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEBodyModel.h"
#import "SEDBTableUser.h"
#import "SEDBTableImages.h"
#import "SEDBTableShare.h"
#import "SEDBTableAddress.h"
#import "SEDBTableSource.h"
#import "SEDBTablePraise.h"
#import "SEDBTableComment.h"

@interface SEDBTableBody : NSObject

/**
 插入一条动态：不会主动更新已存在的数据
 
 @param body 数据
 */
- (BOOL)insertData:(SEBodyModel *)body;

/**
 插入一组动态：不会主动更新已存在的数据

 @param bodys 数组元素必须是SEBodyModel的实例
 @return 是否成功
 */
- (BOOL)insertDatas:(NSArray <SEBodyModel *>*)bodys;

/**
 更新数据：如果不存在，则会插入一条新数据；如果已存在，则更新原来的数据。推荐使用

 @param body 数据
 @return 是否成功
 */
- (BOOL)updateData:(SEBodyModel *)body;

/**
 更新一组动态：如果不存在，则会插入新数据；如果已存在，则更新原来的数据。推荐使用
 
 @param bodys 数组元素必须是SEBodyModel的实例
 @return 是否成功
 */
- (BOOL)updateDatas:(NSArray <SEBodyModel *>*)bodys;

/**
 删除指定动态
 
 @param bodyId 动态ID
 */
- (BOOL)deleteDataWithBodyId:(NSString *)bodyId;

/**
 删除全部数据
 */
- (BOOL)deleteAllData;

/**
 根据ID获取一条数据

 @param bodyId ID
 @return 数据
 */
- (SEBodyModel *)bodyWith:(NSString *)bodyId;

/**
 查询全部数据
 
 @return 数据
 */
- (NSMutableArray <SEBodyModel *>*)allData;

@end
