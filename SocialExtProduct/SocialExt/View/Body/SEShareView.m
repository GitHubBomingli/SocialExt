//
//  SEShareView.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/10.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SEShareView.h"
#import "SEConfig.h"

@interface SEShareView ()

/**
 分享图标
 */
@property (nonatomic, strong) UIImageView *imageView;

/**
 分享标题
 */
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SEShareView

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = SEBackgroundColor_Comment;
        self.frame = CGRectMake(0, 0, seSpacing * 2, seSpacing);
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(seSpacing / 2);
        make.left.mas_equalTo(self.mas_left).mas_offset(seSpacing / 2);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(- seSpacing / 2);
        make.width.mas_equalTo(self.imageView.mas_height);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(seSpacing / 2);
        make.left.mas_equalTo(self.imageView.mas_right).mas_offset(seSpacing / 2);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(- seSpacing / 2);
        make.right.mas_equalTo(self.mas_right).mas_offset(- seSpacing / 2);
    }];
}

#pragma mark - private methods
+ (CGFloat)se_calculateViewHeightWith:(SEShareModel *)model {
    return seShareHeight;
}

#pragma mark - getter and setter
- (void)setModel:(SEShareModel *)model {
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.shareIcon] placeholderImage:[UIImage imageNamed:SEImageLoadPlaceholderName] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    
    self.titleLabel.text = model.shareTitle;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = SEBackgroundColor_clear;
    }
    return _imageView;
}
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.backgroundColor = SEBackgroundColor_clear;
        _titleLabel.textColor = SETextColor_SubTitle;
        _titleLabel.font = SETextFont_SubTitle;
    }
    return _titleLabel;
}

@end
