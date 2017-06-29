//
//  SETableHeaderView.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/9.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SETableHeaderView.h"
#import "SEConfig.h"

#define SEHeadImageViewWidthAndHeight 60.f
@interface SETableHeaderView ()

/**
 模糊视图，添加手势
 */
@property (nonatomic, strong) UIView *blurView;

/**
 底部视图，未读消息
 */
@property (nonatomic, strong) UIView *bottomView;

/**
 头像视图，用户头像
 */
@property (nonatomic, strong) UIImageView *headImageView;

/**
 昵称视图，用户昵称
 */
@property (nonatomic, strong) UILabel *nameLabel;

/**
 消息视图，提示未读
 */
@property (nonatomic, strong) UILabel *unreadLabel;

/**
 点击手势，更换头像
 */
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureForChangeHead;

/**
 点击手势，个人动态
 */
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureForViewHead;

/**
 点击手势，查看未读
 */
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureForViewUnread;
@end

@implementation SETableHeaderView

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.blurView];
        [self insertSubview:self.bottomView aboveSubview:self.blurView];
        [self insertSubview:self.headImageView aboveSubview:self.bottomView];
        [self insertSubview:self.nameLabel aboveSubview:self.blurView];
        [self insertSubview:self.unreadLabel aboveSubview:self.bottomView];
        
        [self.blurView addGestureRecognizer:self.tapGestureForChangeHead];
        [self.headImageView addGestureRecognizer:self.tapGestureForViewHead];
        [self.unreadLabel addGestureRecognizer:self.tapGestureForViewUnread];
        
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(44);// > 28
    }];
    
    [self.blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
        make.right.mas_equalTo(self.mas_right);
    }];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bottomView.mas_top).mas_offset(SEHeadImageViewWidthAndHeight/3);
        make.right.mas_equalTo(self.mas_right).mas_offset(- seSpacing);
        make.width.mas_equalTo(SEHeadImageViewWidthAndHeight);
        make.height.mas_equalTo(SEHeadImageViewWidthAndHeight);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bottomView.mas_top).mas_offset(- seSpacing);
        make.right.mas_equalTo(self.headImageView.mas_left).mas_offset(- seSpacing);
    }];
    
    [self.unreadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(28);
        make.centerX.mas_equalTo(self.bottomView.mas_centerX);
        make.centerY.mas_equalTo(self.bottomView.mas_centerY);
    }];
}

#pragma mark - event response
- (void)touchUpTheResponseOfChangeHead:(UIGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(tableHeaderView:touchUpTheResponseOfChangeHead:)]) {
        [self.delegate tableHeaderView:self touchUpTheResponseOfChangeHead:self.userModel];
    }
}

- (void)touchUpTheResponseOfViewHead:(UIGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(tableHeaderView:touchUpTheResponseOfViewHead:)]) {
        [self.delegate tableHeaderView:self touchUpTheResponseOfViewHead:self.userModel];
    }
}

- (void)touchUpTheResponseOfViewUnread:(UIGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(tableHeaderView:touchUpTheResponseOfViewUnread:)]) {
        [self.delegate tableHeaderView:self touchUpTheResponseOfViewUnread:self.userModel];
    }
}

#pragma mark - getter and setter
- (void)setUserModel:(SEUserModel *)userModel {
    _userModel = userModel;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:userModel.userIcon] placeholderImage:[UIImage imageNamed:self.userHeadPlaceholderImageName] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
    self.nameLabel.text = userModel.userName;
}

- (void)setUnreadNumber:(NSInteger)unreadNumber {
    _unreadNumber = unreadNumber;
    if (_unreadNumber > 0) {
        self.unreadLabel.hidden = NO;
        self.unreadLabel.text = unreadNumber < 100 ? [NSString stringWithFormat:@"您有%ld条未读消息", unreadNumber] : @"您有99+条未读消息";
    } else {
        self.unreadLabel.hidden = YES;
    }
}

- (UIView *)blurView {
    if (_blurView == nil) {
        _blurView = [[UIView alloc] init];
        _blurView.backgroundColor = [UIColor clearColor];
        _blurView.userInteractionEnabled = YES;
    }
    return _blurView;
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = SEBackgroundColor_Main;
    }
    return _bottomView;
}

- (UIImageView *)headImageView {
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.backgroundColor = SEBackgroundColor_Comment;
        _headImageView.layer.borderColor = SEBackgroundColor_Main.CGColor;
        _headImageView.layer.borderWidth = 2;
        _headImageView.userInteractionEnabled = YES;
        [_headImageView se_shadowWithRadius:2];
    }
    return _headImageView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = SEBackgroundColor_clear;
        _nameLabel.textColor = SEBackgroundColor_Main;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = SETextFont_Title;
        _nameLabel.shadowColor = [SERGB(0xCCCCCC) colorWithAlphaComponent:0.5];
        _nameLabel.shadowOffset = CGSizeMake(seSpacing/2, seSpacing/2);
        
    }
    return _nameLabel;
}

- (UILabel *)unreadLabel {
    if (_unreadLabel == nil) {
        _unreadLabel = [[UILabel alloc] init];
        _unreadLabel.backgroundColor = SEBackgroundColor_Comment;
        _unreadLabel.textColor = SETextColor_content;
        _unreadLabel.textAlignment = NSTextAlignmentCenter;
        _unreadLabel.font = SETextFont_SubTitle;
//        _unreadLabel.layer.cornerRadius = 4;
//        _unreadLabel.layer.masksToBounds = YES;
        _unreadLabel.userInteractionEnabled = YES;
        _unreadLabel.hidden = YES;
        [_unreadLabel se_shadowWithRadius:2];
    }
    return _unreadLabel;
}

- (UITapGestureRecognizer *)tapGestureForChangeHead {
    if (_tapGestureForChangeHead == nil) {
        _tapGestureForChangeHead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpTheResponseOfChangeHead:)];
    }
    return _tapGestureForChangeHead;
}

- (UITapGestureRecognizer *)tapGestureForViewHead {
    if (_tapGestureForViewHead == nil) {
        _tapGestureForViewHead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpTheResponseOfViewHead:)];
    }
    return _tapGestureForViewHead;
}

- (UITapGestureRecognizer *)tapGestureForViewUnread {
    if (_tapGestureForViewUnread == nil) {
        _tapGestureForViewUnread = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpTheResponseOfViewUnread:)];
    }
    return _tapGestureForViewUnread;
}
@end
