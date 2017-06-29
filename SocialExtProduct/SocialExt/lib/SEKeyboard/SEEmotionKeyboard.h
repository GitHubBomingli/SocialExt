//
//  SEEmotionKeyboard.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/22.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SEEmotionKeyboard;

@protocol SEEmotionKeyboardDelegate <NSObject>

- (void)emotionKeyboard:(SEEmotionKeyboard *)emotionKeyboard touchUpTheResponseOfEmoticon:(NSString *)emotion;

- (void)emotionKeyboardTouchUpTheResponseOfBackspace:(SEEmotionKeyboard *)emotionKeyboard;

- (void)emotionKeyboardTouchUpTheResponseOfSend:(SEEmotionKeyboard *)emotionKeyboard;

@end

@interface SEEmotionKeyboard : UIView

+ (CGFloat)se_calculateHeight;

@property (nonatomic, weak) id <SEEmotionKeyboardDelegate> delegate;

@end
