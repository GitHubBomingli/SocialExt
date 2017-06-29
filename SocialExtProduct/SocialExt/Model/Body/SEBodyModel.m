//
//  SEBodyModel.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/8.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SEBodyModel.h"

@implementation SEBodyModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"images" : [SEImageModel class],
             @"comments" : [SECommentModel class],
             @"praises" : [SEPraiseModel class]};
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"date"]) {
        return oldValue;
    }
    return oldValue;
}

- (NSString *)video {
    if ([_video containsString:@"http"]) {
        NSString *charactersToEscape = @"";// @"!@#$^*+,; ";
        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
        return [_video stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    }
    return _video;
}

@end
