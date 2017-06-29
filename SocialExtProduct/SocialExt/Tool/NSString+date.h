//
//  NSString+date.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/6/2.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (date)

/**
 时间转字符串

 @param date 时间
 @return 字符串
 */
+ (NSString *)se_stringFromDate:(NSDate *)date;

@end
