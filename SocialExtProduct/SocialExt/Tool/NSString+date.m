//
//  NSString+date.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/6/2.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "NSString+date.h"

@implementation NSString (date)

+ (NSString *)se_stringFromDate:(NSDate *)date {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    return [dateFormatter stringFromDate:date];
}

@end
