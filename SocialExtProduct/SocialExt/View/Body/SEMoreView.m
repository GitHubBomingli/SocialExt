//
//  SEMoreView.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/17.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SEMoreView.h"
#import "SEConfig.h"
#define SEMoreItem_Image_WidthAndHeight 20 //图标宽高
#define SEMoreItem_Padding 4 //距边框的填充距离
#define SEMoreItem_Width 120 //控件的宽度(>=100)
@interface SEMoreView ()

/**
 点赞按钮
 */
@property (nonatomic, strong) UIButton *praiseBtn;

/**
 评论按钮
 */
@property (nonatomic, strong) UIButton *commentBtn;

/**
 分割线
 */
@property (nonatomic, strong) UIView *separateLine;

@end

@implementation SEMoreView {
    CGPoint _point;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.618];
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        self.frame = CGRectMake(0, 0, SEMoreItem_Width, SEMoreItem_Image_WidthAndHeight + SEMoreItem_Padding * 2);
        [self addSubview:self.praiseBtn];
        [self addSubview:self.commentBtn];
        [self addSubview:self.separateLine];
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self layoutUI];
}

- (void)layoutUI {
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(SEMoreItem_Padding);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(- SEMoreItem_Padding);
        make.width.mas_equalTo(1);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.right.mas_equalTo(self.separateLine.mas_left);
    }];
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.separateLine.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.right.mas_equalTo(self.mas_right);
    }];
}

#pragma mark - event response
- (void)touchUpTheResponseOfPraiseBtn:(UIButton *)sender {
    self.praised = !self.praised;
    [self hidden];
    if ([self.delegate respondsToSelector:@selector(moreView:touchUpTheResponseOfPraise:)]) {
        [self.delegate moreView:self touchUpTheResponseOfPraise:self.praised];
    }
}

- (void)touchUpTheResponseOfCommentBtn:(UIButton *)sender {
    [self hidden];
    if ([self.delegate respondsToSelector:@selector(moreViewTouchUpTheResponseOfComment:)]) {
        [self.delegate moreViewTouchUpTheResponseOfComment:self];
    }
}

#pragma mark - private methods
+ (CGFloat)se_calculateViewHeight {
    return SEMoreItem_Padding * 2 + SEMoreItem_Image_WidthAndHeight;
}

- (void)showWithPoint:(CGPoint)point {
    _point = point;
    self.hidden = NO;
    self.frame = CGRectMake(_point.x, _point.y, 1, [SEMoreView se_calculateViewHeight]);
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        self.frame = CGRectMake(point.x - SEMoreItem_Width, point.y, SEMoreItem_Width, [SEMoreView se_calculateViewHeight]);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hidden {
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        self.frame = CGRectMake(_point.x, _point.y, 1, [SEMoreView se_calculateViewHeight]);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - getter and setter
- (void)setPraised:(BOOL)praised {
    _praised = praised;
    self.praiseBtn.selected = praised;
}

- (UIButton *)praiseBtn {
    if (_praiseBtn == nil) {
        _praiseBtn = [[UIButton alloc] init];
        _praiseBtn.backgroundColor = SEBackgroundColor_clear;
        _praiseBtn.titleLabel.font = SETextFont_Label;
        [_praiseBtn setTitle:@" 赞" forState:UIControlStateNormal];
        [_praiseBtn setTitleColor:SERGB(0xFFFFFF) forState:UIControlStateNormal];
        [_praiseBtn setTitle:@" 取消" forState:UIControlStateSelected];
        [_praiseBtn setTitleColor:SERGB(0xFFFFFF) forState:UIControlStateSelected];
        [_praiseBtn setImage:[UIImage imageNamed:@"icon-xin"] forState:UIControlStateNormal];
        [_praiseBtn setImage:[UIImage imageNamed:@"icon-xin"] forState:UIControlStateSelected];
        [_praiseBtn addTarget:self action:@selector(touchUpTheResponseOfPraiseBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _praiseBtn;
}

- (UIButton *)commentBtn {
    if (_commentBtn == nil) {
        _commentBtn = [[UIButton alloc] init];
        _commentBtn.backgroundColor = SEBackgroundColor_clear;
        _commentBtn.titleLabel.font = SETextFont_Label;
        [_commentBtn setTitle:@" 评论" forState:UIControlStateNormal];
        [_commentBtn setTitleColor:SERGB(0xFFFFFF) forState:UIControlStateNormal];
        [_commentBtn setImage:[UIImage imageNamed:@"icon-L"] forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(touchUpTheResponseOfCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}

- (UIView *)separateLine {
    if (_separateLine == nil) {
        _separateLine = [[UIView alloc] init];
        _separateLine.backgroundColor = SERGB(0x333333);
    }
    return _separateLine;
}
@end
