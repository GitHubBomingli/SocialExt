//
//  SECommentModel.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/8.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SECommentModel.h"

@implementation SECommentModel

//- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
//    if ([property.name isEqualToString:@"comment"]) {
//        return [NSString stringWithFormat:@"：%@",oldValue];
//    } else {
//        return oldValue;
//    }
//}

- (NSString *)comment {
    if (_comment) {
        NSRange range = [_comment rangeOfString:@"："];
        if (range.length == 0 || range.location != 0) {
            _comment = [NSString stringWithFormat:@"：%@",_comment];
        }
    }
    return _comment;
}

@end
