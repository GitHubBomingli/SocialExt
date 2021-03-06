//
//  SECapturePhotoShowCell.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/24.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SECapturePhotoShowCell.h"
#import "SEConfig.h"

@implementation SECapturePhotoShowCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor = SERGB(0xEEEEEE);
        self.alpha = 0.8;
        
        [self.contentView addSubview:self.imageView];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top);
            make.left.mas_equalTo(self.contentView.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
        }];
    }
    return self;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

@end
