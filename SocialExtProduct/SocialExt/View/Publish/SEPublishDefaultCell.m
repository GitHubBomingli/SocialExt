//
//  SEPublishDefaultCell.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/26.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SEPublishDefaultCell.h"
#import "SEConfig.h"

@interface SEPublishDefaultCell ()

@end

@implementation SEPublishDefaultCell
#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.rightLabel];
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).mas_offset(seSpacing * 2);
            make.centerY.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(seSpacing);
            make.centerY.mas_equalTo(self.contentView);
        }];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).mas_offset(-seSpacing);
            make.centerY.mas_equalTo(self.contentView);
        }];
    }
    return self;
}
#pragma mark - event response
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - setter and getter
- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.backgroundColor = [UIColor clearColor];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UILabel *)rightLabel {
    if (_rightLabel == nil) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.backgroundColor = [UIColor clearColor];
        _rightLabel.textColor = [UIColor blackColor];
        _rightLabel.font = [UIFont systemFontOfSize:14];
        _rightLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rightLabel;
}

@end
