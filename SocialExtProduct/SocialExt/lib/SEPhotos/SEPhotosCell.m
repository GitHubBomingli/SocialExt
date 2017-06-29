//
//  SEPhotosCell.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/25.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SEPhotosCell.h"
#import "SEConfig.h"

@interface SEPhotosCell ()

@property (nonatomic, strong) UIImageView *selectedImageView;

@property (nonatomic, strong) UIView *mask;

@end

@implementation SEPhotosCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor = SERGB(0xEEEEEE);
        
        [self.contentView addSubview:self.imageView];
        [self.contentView insertSubview:self.selectedImageView aboveSubview:self.imageView];
        [self.contentView insertSubview:self.mask aboveSubview:self.selectedImageView];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top);
            make.left.mas_equalTo(self.contentView.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
        }];
        
        [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-8);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-8);
            make.size.mas_equalTo(CGSizeMake(24, 24));
        }];
        
        [self.mask mas_makeConstraints:^(MASConstraintMaker *make) {
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
        _imageView.layer.masksToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UIImageView *)selectedImageView {
    if (_selectedImageView == nil) {
        _selectedImageView = [[UIImageView alloc] init];
        _selectedImageView.backgroundColor = [UIColor clearColor];
        _selectedImageView.contentMode = UIViewContentModeScaleAspectFit;
        _selectedImageView.image = [UIImage imageNamed:@"AssetsPickerChecked"];
        _selectedImageView.hidden = YES;
    }
    return _selectedImageView;
}

- (UIView *)mask {
    if (_mask == nil) {
        _mask = [[UIView alloc] init];
        _mask.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        _mask.hidden = YES;
    }
    return _mask;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    self.selectedImageView.hidden = !_isSelected;
    
    self.mask.hidden = !_isSelected;
}

@end
