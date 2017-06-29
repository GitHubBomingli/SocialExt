//
//  SEPraiseListView.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/17.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SEPraiseListView.h"
#import "SEConfig.h"

#define SEViewMoreLaudatorAction @"SEViewMoreLaudatorAction"
@interface SEPraiseListView () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@end

@implementation SEPraiseListView

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, seSpacing * 2, seSpacing);
        self.backgroundColor = SEBackgroundColor_Comment;
        [self addSubview:self.textView ];
        
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(seSpacing / 2);
        make.left.mas_equalTo(self.mas_left).mas_offset(seSpacing);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-seSpacing / 2);
        make.right.mas_equalTo(self.mas_right).mas_offset(-seSpacing);
    }];
}

#pragma mark - private methods
+ (CGFloat)se_calculateViewHeightWith:(NSArray *)praises {
    SEPraiseListView *view = [[SEPraiseListView alloc] init];
    view.praises = praises;
    return ceilf([view.textView sizeThatFits:CGSizeMake((SEScreen_Width - seLeftSpacing - seSpacing * 3), 0)].height + seSpacing);
}

/**
 根据点赞列表获取富文本

 @param praises 点赞列表
 @return 富文本
 */
+ (NSMutableAttributedString *)se_praiseListStringWith:(NSArray *)praises {
    
    //拼接字符串
    NSMutableString *string = [NSMutableString stringWithFormat:@" "];
    NSInteger indexMax = praises.count < SEPraise_Max_NumberOfLaudator ? praises.count : SEPraise_Max_NumberOfLaudator;//显示点赞者的人数
    for (NSInteger index = 0; index < indexMax; index ++) {
        SEPraiseModel *model = praises[index];
        if (index == indexMax - 1) {
            [string appendString:model.laudatorName];
        } else {
            [string appendFormat:@"%@、",model.laudatorName];
        }
    }
    if (praises.count > indexMax) {
        [string appendFormat:@"…等%ld人觉得很赞",praises.count];
    }
    
    //带图片的附件
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    textAttachment.image = [UIImage imageNamed:@"icon-xin"];
    NSAttributedString *attachmentAttributeString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    //富文本
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString insertAttributedString:attachmentAttributeString atIndex:0];//插入附件
    
    //插入链接
    NSInteger location = [[attributedString string] rangeOfString:@" "].location + 1;
    for (NSInteger index = 0; index < indexMax; index ++) {
        SEPraiseModel *model = praises[index];
        [attributedString addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%@://",model.laudatorId] range:NSMakeRange(location, model.laudatorName.length)];
        location += model.laudatorName.length + 1;
    }
    if (praises.count > indexMax) {
        [attributedString addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%@://",SEViewMoreLaudatorAction] range:[[attributedString string] rangeOfString:[NSString stringWithFormat:@"%ld人",praises.count]]];
    }
    [attributedString addAttribute:NSFontAttributeName value:SETextFont_Content range:NSMakeRange(0, [attributedString string].length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:SETextColor_content range:NSMakeRange(0, [attributedString string].length)];
    return attributedString;
}

#pragma mark - getter and setter
- (void)setPraises:(NSArray *)praises {
    _praises = praises;
    
    self.textView.attributedText = [SEPraiseListView se_praiseListStringWith:praises];
}

- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.textContainer.lineFragmentPadding = 0;
        _textView.textContainerInset = UIEdgeInsetsZero;//textView 的上下左右都有 8px 的padding
        _textView.showsVerticalScrollIndicator = NO;
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.delegate = self;
        _textView.editable = NO;
        _textView.scrollEnabled = NO;
        _textView.backgroundColor = SEBackgroundColor_clear;
        _textView.linkTextAttributes = @{
                                         NSForegroundColorAttributeName : SETextColor_Response,
                                         NSFontAttributeName : SETextFont_Content,
                                         };
    }
    return _textView;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    NSLog(@"laudatorId = %@, laudatorName = %@",URL.scheme, [[textView.attributedText string] substringWithRange:characterRange]);
    if ([URL.scheme isEqualToString:SEViewMoreLaudatorAction]) {
        if ([self.delegate respondsToSelector:@selector(praiseListView:touchUpTheResponseOfNumber:)]) {
            [self.delegate praiseListView:self touchUpTheResponseOfNumber:_praises];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(praiseListView:touchUpTheResponseOfLaudator:)]) {
            SEUserModel *user = [[SEUserModel alloc] init];
            user.userName = [[textView.attributedText string] substringWithRange:characterRange];
            user.userId = URL.scheme;
            [self.delegate praiseListView:self touchUpTheResponseOfLaudator:user];
        }
    }
    return NO;
}

@end
