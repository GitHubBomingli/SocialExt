//
//  SESectionHeightManager.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/12.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SEHeightSectionModel : NSObject

@property (nonatomic, assign) NSInteger section;//索引

@property (nonatomic, assign) CGFloat height;//高度

@end

@interface SESectionHeightManager : NSObject


/**
 单例

 @return 对象
 */
+ (instancetype)manager;

/**
 插入高度

 @param height 高度
 @param section 索引
 */
- (void)insertHeight:(CGFloat)height forSection:(NSInteger)section;

/**
 更新高度
 
 @param height 高度
 @param section 索引
 */
- (void)updateHeight:(CGFloat)height forSection:(NSInteger)section;

/**
 获取高度

 @param section 索引
 @return 高度
 */
- (CGFloat)heightForSection:(NSInteger)section;

/**
 删除指定索引的数据

 @param section 索引
 */
- (void)removeHeightForSection:(NSInteger)section;

/**
 删除全部
 */
- (void)removeAllHeight;

@end
