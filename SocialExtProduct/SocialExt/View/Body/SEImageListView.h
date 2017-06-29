//
//  SEImageListView.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/10.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEImageModel.h"
@interface SEImageListView : UIView

@property (nonatomic, strong) NSArray *images;//图片

+ (CGFloat)se_calculateViewHeightWith:(NSArray *)images;

@end
