//
//  SEBodyView.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/9.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SEBodyView.h"
#import "SEConfig.h"
#import "SEImageListView.h"
#import "SEShareView.h"
#import "SEVideoView.h"
#import "SEPraiseListView.h"
#import "SEMoreView.h"

@interface SEBodyView () <SEPraiseListViewDelegate, SEMoreViewDelegate>

/**
 头像
 */
@property (nonatomic, strong) UIImageView *headImageView;

/**
 姓名按钮
 */
@property (nonatomic, strong) UIButton *nameBtn;

/**
 内容
 */
@property (nonatomic, strong) UILabel *contentLabel;

/**
 折叠按钮
 */
@property (nonatomic, strong) UIButton *foldBtn;

/**
 图片列表
 */
@property (nonatomic, strong) SEImageListView *imageListView;

/**
 分享
 */
@property (nonatomic, strong) SEShareView *shareView;

/**
 视频
 */
@property (nonatomic, strong) SEVideoView *videoView;

/**
 地址按钮
 */
@property (nonatomic, strong) UIButton *addressBtn;

/**
 时间
 */
@property (nonatomic, strong) UILabel *dateLabel;

/**
 来源
 */
@property (nonatomic, strong) UILabel *sourceLabel;

/**
 shanc按钮
 */
@property (nonatomic, strong) UIButton *deleteBtn;

/**
 更多按钮（评论、点赞）
 */
@property (nonatomic, strong) UIButton *moreBtn;

/**
 更多列表（赞、评论）
 */
@property (nonatomic, strong) SEMoreView *moreView;

/**
 赞列表
 */
@property (nonatomic, strong) SEPraiseListView *praiseView;

/**
 点击手势，个人动态
 */
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureForViewHead;

/**
 点击手势，播放视频
 */
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureForPlayVideo;

/**
 点击手势，进入分享
 */
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureForIntoShare;

@end

@implementation SEBodyView

#pragma mark - life cycle
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = SEBackgroundColor_Main;
        
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.nameBtn];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.foldBtn];
        [self.contentView addSubview:self.imageListView];
        [self.contentView addSubview:self.videoView];
        [self.contentView addSubview:self.shareView];
        [self.contentView addSubview:self.addressBtn];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.sourceLabel];
        [self.contentView addSubview:self.deleteBtn];
        [self.contentView addSubview:self.moreBtn];
        [self.contentView addSubview:self.praiseView];
        [self.contentView addSubview:self.moreView];
        
        [self.headImageView addGestureRecognizer:self.tapGestureForViewHead];
        [self.videoView addGestureRecognizer:self.tapGestureForPlayVideo];
        [self.shareView addGestureRecognizer:self.tapGestureForIntoShare];
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
}

- (void)dealloc {
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)layoutUI {
    self.contentView.frame = CGRectMake(0, 0, SEScreen_Width, SEScreen_Width);//避免约束警告
    
    //添加初始约束，mas_remakeConstraints：重制约束，避免tableViewcell复用时旧约束产生影响
    [self.nameBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(seSpacing);
        make.left.mas_equalTo(self.contentView.mas_left).mas_equalTo(seLeftSpacing);
        make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).mas_offset(-seSpacing);
    }];
    
    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(seSpacing);
        make.left.mas_equalTo(self.contentView.mas_left).mas_equalTo(seSpacing);
        make.width.mas_equalTo(seLeftSpacing - seSpacing * 2);
        make.height.mas_equalTo(seLeftSpacing - seSpacing * 2);
    }];
    
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameBtn.mas_bottom).mas_offset(seSpacing);
        make.left.mas_equalTo(self.nameBtn.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-seSpacing);
    }];
    
    [self.foldBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom).mas_offset(seSpacing);
        make.left.mas_equalTo(self.nameBtn.mas_left);
        make.height.mas_equalTo(self.foldBtn.titleLabel.font.lineHeight);
    }];
    
    [self.imageListView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameBtn.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-seSpacing);
    }];
    
    [self.videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameBtn.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-seSpacing);
    }];
    
    [self.shareView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameBtn.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-seSpacing);
    }];
    
    [self.addressBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameBtn.mas_left);
        make.height.mas_equalTo(self.addressBtn.titleLabel.font.lineHeight);
    }];
    
    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameBtn.mas_left);
    }];
    
    [self.sourceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dateLabel.mas_right).mas_offset(seSpacing);
    }];
    
    [self.deleteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.sourceLabel.mas_right).mas_offset(seSpacing);
        make.height.mas_equalTo(self.deleteBtn.titleLabel.font.lineHeight);
    }];
    
    [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dateLabel.mas_top);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-seSpacing);
        make.size.mas_equalTo(CGSizeMake(20, 16));
    }];
}

#pragma mark - delegate
#pragma mark SEPraiseListViewDelegate
- (void)praiseListView:(SEPraiseListView *)praiseListView touchUpTheResponseOfLaudator:(SEUserModel *)laudatorModel {
    if ([self.delegate respondsToSelector:@selector(bodyView:touchUpTheResponseOfLaudator:)]) {
        [self.delegate bodyView:self touchUpTheResponseOfLaudator:laudatorModel];
    }
}

- (void)praiseListView:(SEPraiseListView *)praiseListView touchUpTheResponseOfNumber:(NSArray *)praises {
    if ([self.delegate respondsToSelector:@selector(bodyView:touchUpTheResponseOfNumber:)]) {
        [self.delegate bodyView:self touchUpTheResponseOfNumber:praises];
    }
}

#pragma mark SEMoreViewDelegate
- (void)moreView:(SEMoreView *)moreView touchUpTheResponseOfPraise:(BOOL)praiseOrcancel {
    if ([self.delegate respondsToSelector:@selector(bodyView:touchUpTheResponseOfPraise:)]) {
        [self.delegate bodyView:self touchUpTheResponseOfPraise:praiseOrcancel];
    }
}

- (void)moreViewTouchUpTheResponseOfComment:(SEMoreView *)moreView {
    if ([self.delegate respondsToSelector:@selector(bodyView:touchUpTheResponseOfComment:)]) {
        [self.delegate bodyView:self touchUpTheResponseOfComment:self.model];
    }
}

#pragma mark - event response
- (void)touchUpTheResponseOfViewHead:(UIGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(bodyView:touchUpTheResponseOfHead:)]) {
        [self.delegate bodyView:self touchUpTheResponseOfHead:self.model.user];
    }
}

- (void)touchUpTheResponseOfPlayVideo:(UIGestureRecognizer *)gesture {
    if (self.videoView.playing == NO) {//未播放时，则开始播放
        [self.videoView play];
    } else {//已播放时，则暂停播放，并进入播放界面
        [self.videoView pause];
        if ([self.delegate respondsToSelector:@selector(bodyView:touchUpTheResponseOfPlayVideo:)]) {
            [self.delegate bodyView:self touchUpTheResponseOfPlayVideo:self.model.video];
        }
    }
}

- (void)touchUpTheResponseOfIntoShare:(UIGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(bodyView:touchUpTheResponseOfIntoShare:)]) {
        [self.delegate bodyView:self touchUpTheResponseOfIntoShare:self.model.share];
    }
}

- (void)touchUpTheResponseOfNameBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(bodyView:touchUpTheResponseOfHead:)]) {
        [self.delegate bodyView:self touchUpTheResponseOfHead:self.model.user];
    }
}

- (void)touchUpTheResponseOfFoldBtn:(UIButton *)sender {
    [[SESectionHeightManager manager] removeHeightForSection:_section];
    self.fold = !self.fold;
    if ([self.delegate respondsToSelector:@selector(bodyView:touchUpTheResponseOfFold:section:)]) {
        [self.delegate bodyView:self touchUpTheResponseOfFold:self.fold section:self.section];
    }
}

- (void)touchUpTheResponseOfAddressBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(bodyView:touchUpTheResponseOfAddress:)]) {
        [self.delegate bodyView:self touchUpTheResponseOfAddress:self.model.address.addressUrl];
    }
}

- (void)touchUpTheResponseOfDeleteBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(bodyView:touchUpTheResponseOfDeleteForSection:bodyId:)]) {
        [self.delegate bodyView:self touchUpTheResponseOfDeleteForSection:self.section bodyId:self.model.bodyId];
    }
}

- (void)touchUpTheResponseOfMoreBtn:(UIButton *)sender {
    if (self.moreView.hidden == YES) {
        [self.moreView showWithPoint:CGPointMake(CGRectGetMinX(self.moreBtn.frame), CGRectGetMidY(self.moreBtn.frame) - [SEMoreView se_calculateViewHeight] / 2.f)];
    } else {
        [self.moreView hidden];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.moreView.hidden == NO) {
        [self.moreView hidden];
    }
}

#pragma mark - private methods
+ (CGFloat)se_calculateViewHeightWith:(SEBodyModel *)model fold:(BOOL)fold section:(NSInteger)section {
    
    CGFloat setHeight = [[SESectionHeightManager manager] heightForSection:section];
    if (setHeight > 0) {
        return setHeight;
    }
    
    SEBodyView *bodyView = [[SEBodyView alloc] init];
    
    CGFloat miniHeight = seUserIconWidthHeight + seSpacing * 2;//最小高度
    CGFloat height = seSpacing;//初始高度
    height += bodyView.nameBtn.titleLabel.font.lineHeight + seSpacing;//加上姓名视图高度
    //加上文本高度
    if (model.content && ![model.content isEqualToString:@""]) {
        if ([model.content se_calculateNumberOfLinesWithWidth:(SEScreen_Width - seLeftSpacing - seSpacing) font:bodyView.contentLabel.font paragraphStyle:nil] > SEFlod_Max_NumberOfLines) {
            if (fold) {
                height += bodyView.contentLabel.font.lineHeight * SEFlod_Max_NumberOfLines;
            } else {
                 height += [model.content se_calculateTextHeightWithWidth:(SEScreen_Width - seLeftSpacing - seSpacing) font:bodyView.contentLabel.font];
            }
            height += bodyView.foldBtn.titleLabel.font.lineHeight + seSpacing;//加上折叠按钮高度
        } else {
            height += [model.content se_calculateTextHeightWithWidth:(SEScreen_Width - seLeftSpacing - seSpacing) font:bodyView.contentLabel.font];
        }
        height += seSpacing;
    }
    //加上图片列表高度
    if (model.type == KSEBodyTypeImageText) {
        height += [SEImageListView se_calculateViewHeightWith:model.images] + seSpacing;
    }
    //加上视频高度
    if (model.type == KSEBodyTypeVideoText) {
        height += [SEVideoView se_calculateViewHeight] + seSpacing;
    }
    //加上分享视图高度
    if (model.type == KSEBodyTypeShareText) {
        height += [SEShareView se_calculateViewHeightWith:model.share] + seSpacing;
    }
    //加上地址高度
    if (model.address.addressName) {
        height += bodyView.addressBtn.titleLabel.font.lineHeight + seSpacing;
    }
    //加上时间、来源、删除、更多等标签的高度
    height += bodyView.dateLabel.font.lineHeight + seSpacing;
    //加上点赞列表的高度
    if (model.praises.count > 0) {
        height += [SEPraiseListView se_calculateViewHeightWith:model.praises];
    }
    
    height = height > miniHeight ? height : miniHeight;
    
    [[SESectionHeightManager manager] insertHeight:height forSection:section];
    
    return height;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if (self.moreView.hidden == NO) {
            [self.moreView hidden];
        }
    }
}

#pragma mark - getter and setter
- (void)setModel:(SEBodyModel *)model {
    if ([model isEqual:_model] && seAvoidRepeatedLoadingSetMethods) {//tableView滚动时，避免重复加载set方法
        if (model.type == KSEBodyTypeVideoText && self.videoView.playing == YES) {
            [self.videoView pause];
        }
        return;
    }
    _model = model;
    NSAssert(model.user.userId != nil, @"发布者的ID不能为空");
    //重制约束
    [self layoutUI];
    //头像
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.user.userIcon] placeholderImage:[UIImage imageNamed:_userHeadPlaceholderImageName] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    //名称
    [self.nameBtn setTitle:model.user.userName forState:UIControlStateNormal];
    [self.nameBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.nameBtn.titleLabel.font.lineHeight);
    }];
    
    UIView *topView = self.nameBtn;//确定下一个视图的对上约束视图
    if (model.content && ![model.content isEqualToString:@""]) {//文本内容非空时
        self.contentLabel.hidden = NO;
        self.contentLabel.text = model.content;
        if ([model.content se_calculateNumberOfLinesWithWidth:(SEScreen_Width - seLeftSpacing - seSpacing) font:self.contentLabel.font paragraphStyle:nil] > SEFlod_Max_NumberOfLines) {//如果文本内容的行数大于折叠时可以显示的最大行数，则显示折叠按钮
            self.foldBtn.hidden = NO;
            topView = self.foldBtn;
            
            self.foldBtn.selected = self.fold;
            self.contentLabel.numberOfLines = self.fold ? SEFlod_Max_NumberOfLines : 0;
        } else {
            self.foldBtn.hidden = YES;
            topView = self.contentLabel;
        }
    } else {
        self.contentLabel.hidden = YES;
        self.foldBtn.hidden = YES;
    }
    
    if (model.type == KSEBodyTypeImageText) {//如果动态类型为 图文
        NSAssert(model.images.count > 0, @"type == KSEBodyTypeImageText时，images数组不能为空");
        self.imageListView.hidden = NO;
        self.imageListView.images = model.images;
        [self.imageListView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topView.mas_bottom).mas_offset(seSpacing);
            make.height.mas_equalTo([SEImageListView se_calculateViewHeightWith:model.images]);
        }];
        topView = self.imageListView;
    } else {
        self.imageListView.hidden = YES;
    }
    
    if (model.type == KSEBodyTypeVideoText) {//如果动态类型为 视频
        NSAssert(model.video != nil, @"type == KSEBodyTypeVideoText时，video视频链接不能为空");
        self.videoView.hidden = NO;
        self.videoView.videoUrl = model.video;
        [self.videoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topView.mas_bottom).mas_offset(seSpacing);
            make.height.mas_equalTo([SEVideoView se_calculateViewHeight]);
        }];
        topView = self.videoView;
    } else {
        self.videoView.hidden = YES;
    }
    
    if (model.type == KSEBodyTypeShareText) {//如果动态类型为 分享
        NSAssert(model.share != nil, @"type == KSEBodyTypeShareText时，share分享内容不能为空");
        self.shareView.hidden = NO;
        self.shareView.model = model.share;
        [self.shareView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topView.mas_bottom).mas_offset(seSpacing);
            make.height.mas_equalTo([SEShareView se_calculateViewHeightWith:model.share]);
        }];
        topView = self.shareView;
    } else {
        self.shareView.hidden = YES;
    }
    
    if (model.address.addressName) {//是否包含地址
        NSAssert(model.address.addressUrl != nil, @"包含地址时，地址链接不能为空");
        self.addressBtn.hidden = NO;
        [self.addressBtn setTitle:model.address.addressName forState:UIControlStateNormal];
        [self.addressBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topView.mas_bottom).mas_offset(seSpacing);
        }];
        topView = self.addressBtn;
    } else {
        self.addressBtn.hidden = YES;
    }
    //发布时间
    NSAssert(model.date!= nil, @"发布时间不能为空");
    self.dateLabel.text = [model.date se_calculateDateChineseDescription];//转为中文描述
    [self.dateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).mas_offset(seSpacing);
    }];
    
    UIView *leftView = self.dateLabel;//确定下一个视图的对左约束视图
    
    if (model.source.sourceName) {//是否包含来源
        NSAssert(model.source.sourceUrl != nil, @"包含来源时，来源链接不能为空");
        self.sourceLabel.hidden = NO;
        self.sourceLabel.text = model.source.sourceName;
        [self.sourceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topView.mas_bottom).mas_offset(seSpacing);
        }];
        leftView = self.sourceLabel;
    } else {
        self.sourceLabel.hidden = YES;
    }
    
    if ([model.user.userId isEqualToString:_userModel.userId]) {//如果发布者是当前用户，则显示删除按钮
        self.deleteBtn.hidden = NO;
        [self.deleteBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topView.mas_bottom).mas_offset(seSpacing);
            make.left.mas_equalTo(leftView.mas_right).mas_offset(seSpacing);
        }];
    } else {
        self.deleteBtn.hidden = YES;
    }
    
    if (model.praises.count > 0) {//如果有点赞列表
        self.praiseView.hidden = NO;
        self.praiseView.praises = model.praises;
        [self.praiseView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.dateLabel.mas_bottom).mas_offset(seSpacing);
            make.left.mas_equalTo(self.nameBtn.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(- seSpacing);
            make.height.mas_equalTo([SEPraiseListView se_calculateViewHeightWith:model.praises]);
        }];
    } else {
        self.praiseView.hidden = YES;
    }
    
    self.moreView.praised = NO;
    for (SEPraiseModel *praiseModel in model.praises) {
        if ([praiseModel.laudatorId isEqualToString:_userModel.userId]) {
            self.moreView.praised = YES;
            break;
        }
    }
}

- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (UIImageView *)headImageView {
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.backgroundColor = SEBackgroundColor_Comment;
        _headImageView.userInteractionEnabled = YES;
    }
    return _headImageView;
}

- (UIButton *)nameBtn {
    if (_nameBtn == nil) {
        _nameBtn = [[UIButton alloc] init];
        _nameBtn.backgroundColor = SEBackgroundColor_clear;
        [_nameBtn setTitleColor:SETextColor_Response forState:UIControlStateNormal];
        [_nameBtn setTitleColor:SETextColor_Response_Highlighted forState:UIControlStateHighlighted];
        _nameBtn.titleLabel.font = SETextFont_Title;
        [_nameBtn addTarget:self action:@selector(touchUpTheResponseOfNameBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nameBtn;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = SEFlod_Max_NumberOfLines;
        _contentLabel.backgroundColor = SEBackgroundColor_clear;
        _contentLabel.textColor = SETextColor_SubTitle;
        _contentLabel.font = SETextFont_SubTitle;
        _contentLabel.hidden = YES;
    }
    return _contentLabel;
}

- (UIButton *)foldBtn {
    if (_foldBtn == nil) {
        _foldBtn = [[UIButton alloc] init];
        _foldBtn.backgroundColor = SEBackgroundColor_clear;
        [_foldBtn setTitleColor:SETextColor_Response forState:UIControlStateNormal];
        [_foldBtn setTitleColor:SETextColor_Response_Highlighted forState:UIControlStateHighlighted];
        _foldBtn.titleLabel.font = SETextFont_Content;
        [_foldBtn addTarget:self action:@selector(touchUpTheResponseOfFoldBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_foldBtn setTitle:@"全文" forState:UIControlStateSelected];
        [_foldBtn setTitle:@"收起" forState:UIControlStateNormal];
        _foldBtn.hidden = YES;
        _foldBtn.selected = YES;
        _fold = YES;
    }
    return _foldBtn;
}

- (SEImageListView *)imageListView {
    if (_imageListView == nil) {
        _imageListView = [[SEImageListView alloc] init];
        _imageListView.hidden = YES;
    }
    return _imageListView;
}

- (SEShareView *)shareView {
    if (_shareView == nil) {
        _shareView = [[SEShareView alloc] init];
        _shareView.hidden = YES;
    }
    return _shareView;
}

- (SEVideoView *)videoView {
    if (_videoView == nil) {
        _videoView = [[SEVideoView alloc] init];
        _videoView.hidden = YES;
    }
    return _videoView;
}

- (UIButton *)addressBtn {
    if (_addressBtn == nil) {
        _addressBtn = [[UIButton alloc] init];
        _addressBtn.backgroundColor = SEBackgroundColor_clear;
        [_addressBtn setTitleColor:SETextColor_Response forState:UIControlStateNormal];
        [_addressBtn setTitleColor:SETextColor_Response_Highlighted forState:UIControlStateHighlighted];
        _addressBtn.titleLabel.font = SETextFont_Content;
        [_addressBtn addTarget:self action:@selector(touchUpTheResponseOfAddressBtn:) forControlEvents:UIControlEventTouchUpInside];
        _addressBtn.hidden = YES;
    }
    return _addressBtn;
}

- (UILabel *)dateLabel {
    if (_dateLabel == nil) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.backgroundColor = SEBackgroundColor_clear;
        _dateLabel.textColor = SETextColor_Label;
        _dateLabel.font = SETextFont_Label;
    }
    return _dateLabel;
}

- (UILabel *)sourceLabel {
    if (_sourceLabel == nil) {
        _sourceLabel = [[UILabel alloc] init];
        _sourceLabel.backgroundColor = SEBackgroundColor_clear;
        _sourceLabel.textColor = SETextColor_Label;
        _sourceLabel.font = SETextFont_Label;
        _sourceLabel.hidden = YES;
    }
    return _sourceLabel;
}

- (UIButton *)deleteBtn {
    if (_deleteBtn == nil) {
        _deleteBtn = [[UIButton alloc] init];
        _deleteBtn.backgroundColor = SEBackgroundColor_clear;
        [_deleteBtn setTitleColor:SETextColor_Response forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:SETextColor_Response_Highlighted forState:UIControlStateHighlighted];
        _deleteBtn.titleLabel.font = SETextFont_Label;
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(touchUpTheResponseOfDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.hidden = YES;
    }
    return _deleteBtn;
}

- (UIButton *)moreBtn {
    if (_moreBtn == nil) {
        _moreBtn = [[UIButton alloc] init];
        _moreBtn.backgroundColor = SEBackgroundColor_clear;
        _moreBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_moreBtn setImage:[UIImage imageNamed:@"icon-pinglun"] forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = SETextFont_Label;
        [_moreBtn addTarget:self action:@selector(touchUpTheResponseOfMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (SEMoreView *)moreView {
    if (_moreView == nil) {
        _moreView = [[SEMoreView alloc] init];
        _moreView.delegate = self;
        _moreView.hidden = YES;
    }
    return _moreView;
}

- (SEPraiseListView *)praiseView {
    if (_praiseView == nil) {
        _praiseView = [[SEPraiseListView alloc] init];
        _praiseView.delegate = self;
        _praiseView.hidden = YES;
    }
    return _praiseView;
}

- (UITapGestureRecognizer *)tapGestureForViewHead {
    if (_tapGestureForViewHead == nil) {
        _tapGestureForViewHead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpTheResponseOfViewHead:)];
    }
    return _tapGestureForViewHead;
}

- (UITapGestureRecognizer *)tapGestureForPlayVideo {
    if (_tapGestureForPlayVideo == nil) {
        _tapGestureForPlayVideo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpTheResponseOfPlayVideo:)];
    }
    return _tapGestureForPlayVideo;
}

- (UITapGestureRecognizer *)tapGestureForIntoShare {
    if (_tapGestureForIntoShare == nil) {
        _tapGestureForIntoShare = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpTheResponseOfIntoShare:)];
    }
    return _tapGestureForIntoShare;
}

@end
