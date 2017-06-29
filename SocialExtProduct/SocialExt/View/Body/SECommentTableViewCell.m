//
//  SECommentTableViewCell.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/8.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SECommentTableViewCell.h"
#import "SEConfig.h"

#define SETextLineHeight 17.5
@interface SECommentTableViewCell ()

/**
 评论者
 */
@property (nonatomic, strong) UIButton *commenterBtn;

/**
 被追问者
 */
@property (nonatomic, strong) UIButton *toCommenterBtn;

/**
 “回复”
 */
@property (nonatomic, strong) UILabel *replyLab;

/**
 评论内容
 */
@property (nonatomic, strong) UILabel *commentLab;

/**
 背景
 */
@property (nonatomic, strong) UIView *bgView;

/**
 点击评论
 */
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation SECommentTableViewCell


#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = SEBackgroundColor_Main;
        
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.commentLab];
        [self.bgView addSubview:self.commenterBtn];
        [self.bgView addSubview:self.toCommenterBtn];
        [self.bgView addSubview:self.replyLab];
        [self.commentLab addGestureRecognizer:self.tapGesture];
        
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(seLeftSpacing);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(1);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-seSpacing);
    }];
    
    [self.commentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_top).mas_offset(seSpacing/2.f);
        make.left.mas_equalTo(self.bgView.mas_left).mas_offset(seSpacing);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).mas_offset(-seSpacing/2.f);
        make.right.mas_equalTo(self.bgView.mas_right).mas_offset(-seSpacing);
    }];
    
    [self.commenterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.commentLab.mas_top);
        make.left.mas_equalTo(self.bgView.mas_left).mas_offset(seSpacing);
        make.height.mas_equalTo(self.replyLab.mas_height);
    }];
    
    [self.replyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.commentLab.mas_top);
        make.left.mas_equalTo(self.commenterBtn.mas_right);
        make.height.mas_equalTo(SETextLineHeight);
    }];
    
    [self.toCommenterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.commentLab.mas_top);
        make.left.mas_equalTo(self.replyLab.mas_right);
        make.height.mas_equalTo(self.replyLab.mas_height);
    }];
}

#pragma mark - event response
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)touchUpTheResponseOfCommenterBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(commentCell:touchUpTheResponseOfCommenter:)]) {
        [self.delegate commentCell:self touchUpTheResponseOfCommenter:self.model];
    }
}

- (void)touchUpTheResponseOfToCommenterBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(commentCell:touchUpTheResponseOfToCommenter:)]) {
        [self.delegate commentCell:self touchUpTheResponseOfToCommenter:self.model];
    }
}

- (void)touchUpTheResponseOfCommentLab:(UIGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(commentCell:touchUpTheResponseOfComment:)]) {
        [self.delegate commentCell:self touchUpTheResponseOfComment:self.model];
    }
}

#pragma mark - private methods
+ (CGFloat)se_calculateCellHeightWith:(SECommentModel *)commentModel {
    NSString *firstLineString = nil;
    if (commentModel.type == KSECommentTypeToBody) {
        firstLineString = commentModel.commenter.userName;
    } else {
        firstLineString = [NSString stringWithFormat:@"%@回复%@",commentModel.commenter.userName, commentModel.toCommenter.userName];
    }
    //段落格式：首行缩进
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.firstLineHeadIndent = [firstLineString se_calculateTextHeightWithHeight:SETextLineHeight font:SETextFont_Content];
    return [commentModel.comment boundingRectWithSize:CGSizeMake(SEScreen_Width - (seLeftSpacing + seSpacing * 3), 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : SETextFont_Content,NSParagraphStyleAttributeName : paragraphStyle} context:nil].size.height + seSpacing + 1;
}

#pragma mark - getter and setter
- (void)setModel:(SECommentModel *)model {
    _model = model;
    NSAssert(model.commenter.userId != nil, @"评论者的ID不能为空");
    if (model.type == KSECommentTypeToUser) {
        NSAssert(model.toCommenter.userId != nil, @"被追问者的ID不能为空");
    }
    
    [self.commenterBtn setTitle:model.commenter.userName forState:UIControlStateNormal];
    NSString *firstLineString = nil;
    if (model.type == KSECommentTypeToBody) {
        self.replyLab.text = nil;
        [self.toCommenterBtn setTitle:nil forState:UIControlStateNormal];
        firstLineString = model.commenter.userName;
    } else {
        self.replyLab.text = @"回复";
        [self.toCommenterBtn setTitle:model.toCommenter.userName forState:UIControlStateNormal];
        firstLineString = [NSString stringWithFormat:@"%@回复%@",model.commenter.userName, model.toCommenter.userName];
    }
    
    //段落格式：首行缩进
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.firstLineHeadIndent = [firstLineString se_calculateTextHeightWithHeight:SETextLineHeight font:SETextFont_Content];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.comment attributes:@{NSFontAttributeName : SETextFont_Content,NSForegroundColorAttributeName : SETextColor_content,NSParagraphStyleAttributeName : paragraphStyle}];
    self.commentLab.attributedText = attributedString;
}

- (UIButton *)commenterBtn {
    if (_commenterBtn == nil) {
        _commenterBtn = [[UIButton alloc] init];
        _commenterBtn.backgroundColor = SEBackgroundColor_clear;
        [_commenterBtn setTitleColor:SETextColor_Response forState:UIControlStateNormal];
        [_commenterBtn setTitleColor:SETextColor_Response_Highlighted forState:UIControlStateHighlighted];
        _commenterBtn.titleLabel.font = SETextFont_Content;
        [_commenterBtn addTarget:self action:@selector(touchUpTheResponseOfCommenterBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commenterBtn;
}

- (UIButton *)toCommenterBtn {
    if (_toCommenterBtn == nil) {
        _toCommenterBtn = [[UIButton alloc] init];
        _toCommenterBtn.backgroundColor = SEBackgroundColor_clear;
        [_toCommenterBtn setTitleColor:SETextColor_Response forState:UIControlStateNormal];
        [_toCommenterBtn setTitleColor:SETextColor_Response_Highlighted forState:UIControlStateHighlighted];
        _toCommenterBtn.titleLabel.font = SETextFont_Content;
        [_toCommenterBtn addTarget:self action:@selector(touchUpTheResponseOfToCommenterBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toCommenterBtn;
}

- (UILabel *)replyLab {
    if (_replyLab == nil) {
        _replyLab = [[UILabel alloc] init];
        _replyLab.backgroundColor = SEBackgroundColor_clear;
        _replyLab.textColor = SETextColor_content;
        _replyLab.font = SETextFont_Content;
    }
    return _replyLab;
}

- (UILabel *)commentLab {
    if (_commentLab == nil) {
        _commentLab = [[UILabel alloc] init];
        _commentLab.numberOfLines = 0;
        _commentLab.backgroundColor = SEBackgroundColor_clear;
        _commentLab.textColor = SETextColor_content;
        _commentLab.font = SETextFont_Content;
        _commentLab.userInteractionEnabled = YES;
    }
    return _commentLab;
}

- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = SEBackgroundColor_Comment;
    }
    return _bgView;
}


- (UITapGestureRecognizer *)tapGesture {
    if (_tapGesture == nil) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpTheResponseOfCommentLab:)];
    }
    return _tapGesture;
}
@end
