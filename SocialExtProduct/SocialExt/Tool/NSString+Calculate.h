//
//  NSString+Calculate.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/9.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Calculate)

/**
 给定宽度和字体大小，计算文本的高度

 @param width 给定的宽度
 @param font 字体大小
 @return 文本的高度
 */
- (CGFloat)se_calculateTextHeightWithWidth:(CGFloat)width font:(UIFont *_Nonnull)font;

/**
 给定宽度和字体大小，计算文本的高度
 
 @param width 给定的宽度
 @param font 字体大小
 @param paragraphStyle 段落格式，可为nil
 @return 文本的高度
 */
- (CGFloat)se_calculateTextHeightWithWidth:(CGFloat)width font:(UIFont *_Nonnull)font paragraphStyle:(NSParagraphStyle *_Nullable)paragraphStyle;

/**
 给定高度和字体大小，计算文本的宽度

 @param height 给定的高度
 @param font 字体大小
 @return 文本宽度
 */
- (CGFloat)se_calculateTextHeightWithHeight:(CGFloat)height font:(UIFont *_Nonnull)font;

/**
 将数字形式的时间字符串转为中文描述

 @return 中文描述
 */
- (NSString *_Nonnull)se_calculateDateChineseDescription;

/**
 计算字符串行数

 @param width 制定宽度
 @param font 字体大小
 @param paragraphStyle 段落格式(只考虑行间距和段落间距)，可为nil
 @return 行数
 */
- (NSInteger)se_calculateNumberOfLinesWithWidth:(CGFloat)width font:(UIFont *_Nonnull)font paragraphStyle:(NSParagraphStyle *_Nullable)paragraphStyle;

@end
