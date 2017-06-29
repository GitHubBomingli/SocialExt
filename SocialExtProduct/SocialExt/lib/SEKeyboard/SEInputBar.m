//
//  SEInputBar.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/19.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SEInputBar.h"
#import "SEConfig.h"
#import "SEEmotionKeyboard.h"

#define SEBtnWidthHeight 32
#define SEVerticalSpacing 4
#define SEHorizontalSpacing 8
@interface SEInputBar () <UITextViewDelegate, SEEmotionKeyboardDelegate>

/**
 输入框
 */
@property (nonatomic, strong) UITextView *textView;

/**
 表情键盘切换按钮
 */
@property (nonatomic, strong) UIButton *emoticonBnt;

/**
 表情键盘
 */
@property (nonatomic, strong) SEEmotionKeyboard *emotionKeyboard;

@end

@implementation SEInputBar

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 0.5;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
        
        self.backgroundColor = SERGB(0xEEEEEE);
        
        [self addSubview:self.textView];
        [self addSubview:self.emoticonBnt];
        
        self.frame = CGRectMake(0, SEScreen_Height, SEScreen_Width, 40);
        
        [self.emoticonBnt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).mas_offset(-SEHorizontalSpacing);
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-SEVerticalSpacing);
            make.size.mas_equalTo(CGSizeMake(SEBtnWidthHeight, SEBtnWidthHeight));
        }];
        
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(SEVerticalSpacing);
            make.left.mas_equalTo(self.mas_left).mas_offset(SEHorizontalSpacing);
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-SEVerticalSpacing);
            make.right.mas_equalTo(self.emoticonBnt.mas_left).mas_offset(-SEHorizontalSpacing);
        }];
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    [self.textView becomeFirstResponder];
    
    [self.superview addSubview:self.emotionKeyboard];
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    
    self.frame = CGRectMake(0, SEScreen_Height, SEScreen_Width, 40);
    _emoticonBnt.selected = NO;
    _emotionKeyboard.frame = CGRectMake(0, SEScreen_Height , SEScreen_Width, 0);
    [_emotionKeyboard removeFromSuperview];
    _textView.text = @"";
    self.text = @"";
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Delegate
#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    CGFloat height = [_textView sizeThatFits:CGSizeMake(SEScreen_Width - SEHorizontalSpacing * 3 - SEBtnWidthHeight, 0)].height + SEVerticalSpacing * 2;
    CGFloat maxHeight = textView.font.lineHeight * 6 + textView.contentInset.top + textView.contentInset.bottom + SEVerticalSpacing * 2;
    if (height > maxHeight) {
        height = maxHeight;
    }
    CGRect frame = self.frame;
    self.frame = CGRectMake(0, CGRectGetMaxY(frame) - height, SEScreen_Width, height);
    
    self.text = textView.text;
    if (_textDidChange) {
        _textDidChange(textView.text, _type, _indexPath);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self sendAction];
    }
    return YES;
}

#pragma mark SEEmotionKeyboardDelegate
- (void)emotionKeyboard:(SEEmotionKeyboard *)emotionKeyboard touchUpTheResponseOfEmoticon:(NSString *)emotion {
    self.textView.text = [self.text stringByAppendingString:emotion];
    [self textViewDidChange:_textView];
    if (_textView.text.length > 1) {
        [_textView scrollRangeToVisible:NSMakeRange(_textView.text.length - 1, 1)];
    }
}

- (void)emotionKeyboardTouchUpTheResponseOfBackspace:(SEEmotionKeyboard *)emotionKeyboard {
    if (_textView.text.length >= 2) {
        self.textView.text = [_textView.text substringWithRange:NSMakeRange(0, _textView.text.length - 2)];
        [self textViewDidChange:_textView];
        if (_textView.text.length > 1) {
            [_textView scrollRangeToVisible:NSMakeRange(_textView.text.length - 1, 1)];
        }
    }
}

- (void)emotionKeyboardTouchUpTheResponseOfSend:(SEEmotionKeyboard *)emotionKeyboard {
    if (_textView.text.length > 0) {
        [self sendAction];
    }
}

#pragma mark - event response
- (void)touchUpTheResponseOfEmoticonBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        [self.textView resignFirstResponder];
        [UIView animateWithDuration:0.4 animations:^{
            self.emotionKeyboard.frame = CGRectMake(0, SEScreen_Height - [SEEmotionKeyboard se_calculateHeight], SEScreen_Width, [SEEmotionKeyboard se_calculateHeight]);
            CGFloat height = CGRectGetHeight(self.frame);
            self.frame = CGRectMake(0, SEScreen_Height - [SEEmotionKeyboard se_calculateHeight] - height, SEScreen_Width, height);
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [self.textView becomeFirstResponder];
        [UIView animateWithDuration:0.4 animations:^{
            self.emotionKeyboard.frame = CGRectMake(0, SEScreen_Height , SEScreen_Width, 0);
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark - private methods
+ (CGFloat)se_calculateHeight {
    SEInputBar *bar = [[SEInputBar alloc] init];
    CGFloat textHeight = [bar.textView sizeThatFits:CGSizeMake(SEScreen_Width - SEHorizontalSpacing * 3 - SEBtnWidthHeight, 0)].height;
    return textHeight + SEVerticalSpacing * 2;
}

- (void)keyboardWillShowNotification:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGFloat keyboardHeight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGRect frame = self.frame;
    frame.origin.y = SEScreen_Height - frame.size.height - keyboardHeight;
    self.frame = frame;
}

- (void)keyboardWillHideNotification:(NSNotification *)notification {
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.frame;
    frame.origin.y = SEScreen_Height - frame.size.height;
    [UIView animateWithDuration:duration animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)sendAction {
    if ([self.delegate respondsToSelector:@selector(inputBar:touchUpTheResponseOfSendReturnWithText:type:indexPath:)]) {
        [self.delegate inputBar:self touchUpTheResponseOfSendReturnWithText:_textView.text type:_type indexPath:_indexPath];
    }
    
    [_textView resignFirstResponder];
    [self removeFromSuperview];
}

#pragma mark - getter and setter
- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.layer.cornerRadius = 2;
        _textView.layer.masksToBounds = YES;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.font = SETextFont_Content;
        _textView.textColor = SETextColor_content;
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.enablesReturnKeyAutomatically = YES;
    }
    return _textView;
}

- (UIButton *)emoticonBnt {
    if (_emoticonBnt == nil) {
        _emoticonBnt = [[UIButton alloc] init];
        _emoticonBnt.contentMode = UIViewContentModeScaleAspectFit;
        [_emoticonBnt setImage:[UIImage imageNamed:@"btn_expression"] forState:UIControlStateNormal];
        [_emoticonBnt setImage:[UIImage imageNamed:@"btn_keyboard"] forState:UIControlStateSelected];
        [_emoticonBnt addTarget:self action:@selector(touchUpTheResponseOfEmoticonBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emoticonBnt;
}

- (SEEmotionKeyboard *)emotionKeyboard {
    if (_emotionKeyboard == nil) {
        _emotionKeyboard = [[SEEmotionKeyboard alloc] init];
        _emotionKeyboard.frame = CGRectMake(0, SEScreen_Height, SEScreen_Width, 0);
        _emotionKeyboard.delegate = self;
    }
    return _emotionKeyboard;
}

- (NSString *)text {
    if (_text == nil) {
        _text = @"";
    }
    return _text;
}

@end
