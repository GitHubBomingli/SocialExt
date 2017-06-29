//
//  NSString+Calculate.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/9.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "NSString+Calculate.h"

@implementation NSString (Calculate)

- (CGFloat)se_calculateTextHeightWithWidth:(CGFloat)width font:(UIFont *_Nonnull)font {
    return [self boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : font} context:nil].size.height;
}

- (CGFloat)se_calculateTextHeightWithWidth:(CGFloat)width font:(UIFont *)font paragraphStyle:(NSParagraphStyle *)paragraphStyle {
    if (paragraphStyle == nil) {
        paragraphStyle = [NSParagraphStyle defaultParagraphStyle];
    }
    CGFloat height = ceilf([self boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle} context:nil].size.height);
    return height;
}

- (CGFloat)se_calculateTextHeightWithHeight:(CGFloat)height font:(UIFont *_Nonnull)font {
    return ceilf([self boundingRectWithSize:CGSizeMake(0, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : font} context:nil].size.width);
}

- (NSString *_Nonnull)se_calculateDateChineseDescription {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    formatter.locale = [NSLocale currentLocale];
    NSDate *date = [formatter dateFromString:self];
    NSInteger interval = ABS([date timeIntervalSinceNow]);
    
    NSString *chineseDescription = nil;
    if (interval < 60) {
        chineseDescription = @"刚刚";
    } else if (interval < 60 * 60) {
        chineseDescription = [NSString stringWithFormat:@"%ld分钟前",interval / 60];
    } else if (interval < 60 * 60 * 24) {
        chineseDescription = [NSString stringWithFormat:@"%ld小时前",interval / 60 / 60];
    } else if (interval < 60 * 60 * 24 * 30) {
        chineseDescription = [NSString stringWithFormat:@"%ld天前",interval / 60 / 60 / 24];
    } else if (interval < 60 * 60 * 24 * 365) {
        chineseDescription = [NSString stringWithFormat:@"%ld月前",interval / 60 / 60 / 24 / 30];
    } else {
        chineseDescription = [NSString stringWithFormat:@"%ld年前",interval / 60 / 60 / 24 / 365];
    }
    return chineseDescription;
}

- (NSInteger)se_calculateNumberOfLinesWithWidth:(CGFloat)width font:(UIFont *_Nonnull)font paragraphStyle:(NSParagraphStyle *_Nullable)paragraphStyle {
    if (paragraphStyle == nil) {
        paragraphStyle = [NSParagraphStyle defaultParagraphStyle];
    }
    CGFloat height = [self boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle} context:nil].size.height;
    
    CGFloat lineHeight = font.lineHeight + paragraphStyle.lineSpacing;
    if ([self containsString:@"\n"]) {
        NSArray *paragraphs = [self componentsSeparatedByString:@"\n"];
        lineHeight += paragraphs.count * paragraphStyle.paragraphSpacing;
    }
    return (NSInteger)ceilf(height / lineHeight);
}

@end
