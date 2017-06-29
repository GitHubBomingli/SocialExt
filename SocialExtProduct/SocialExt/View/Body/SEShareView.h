//
//  SEShareView.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/10.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEShareModel.h"

@interface SEShareView : UIView

@property (nonatomic, strong) SEShareModel *model;//分享数据

+ (CGFloat)se_calculateViewHeightWith:(SEShareModel *)model;

@end
