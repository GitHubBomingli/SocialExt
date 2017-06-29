//
//  SEEmotionCollectionViewCell.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/22.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SEEmotionCollectionViewCell.h"
#import "SEConfig.h"

@implementation SEEmotionCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor = SERGB(0xEEEEEE);
        
        [self.contentView addSubview:self.label];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top);
            make.left.mas_equalTo(self.contentView.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
        }];
    }
    return self;
}

- (UILabel *)label {
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

@end
