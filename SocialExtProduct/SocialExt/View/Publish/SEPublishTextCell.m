//
//  SEPublishTextCell.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/26.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SEPublishTextCell.h"
#import "SEConfig.h"

@interface SEPublishTextCell () <UITextViewDelegate>

@property (nonatomic, strong) UILabel *placeholder;

@end

@implementation SEPublishTextCell
#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.textView];
        [self.contentView insertSubview:self.placeholder aboveSubview:self.textView];
        
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).mas_offset(seSpacing);
            make.left.mas_equalTo(self.contentView).mas_offset(seSpacing);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-seSpacing);
            make.right.mas_equalTo(self.contentView).mas_offset(-seSpacing);
            make.height.mas_equalTo(self.textView.mas_width).multipliedBy(0.33).priority(999);
        }];
        
        [self.placeholder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.textView).mas_offset(8);
            make.left.mas_equalTo(self.textView).mas_offset(8);
            make.height.mas_equalTo(self.placeholder.font.lineHeight);
        }];
    }
    return self;
}

#pragma mark - event response
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //长度限制
    if (! [text isEqualToString:@""] && textView.text.length + text.length > SEPublishText_Max_Length) {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    //根据需要隐藏或显示提示文本
    self.placeholder.hidden = (BOOL)textView.text.length;
}

#pragma mark - getter and setter
- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = [UIFont systemFontOfSize:13];
        _textView.delegate = self;
    }
    return _textView;
}

- (UILabel *)placeholder {
    if (_placeholder == nil) {
        _placeholder = [[UILabel alloc] init];
        _placeholder.textColor = [UIColor lightGrayColor];
        _placeholder.font = [UIFont systemFontOfSize:13];
        _placeholder.backgroundColor = [UIColor clearColor];
        _placeholder.text = @"说点什么吧……";
    }
    return _placeholder;
}
@end
