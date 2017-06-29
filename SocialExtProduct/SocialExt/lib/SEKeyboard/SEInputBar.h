//
//  SEInputBar.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/19.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SEInputBarTypeToBody,
    SEInputBarTypeToComment,
    SEInputBarTypeToOther,
} SEInputBarType;

@class SEInputBar;

@protocol SEInputBarDelegate <NSObject>

- (void)inputBar:(SEInputBar *)inputBar touchUpTheResponseOfSendReturnWithText:(NSString *)text type:(SEInputBarType)type indexPath:(NSIndexPath *)indexPath;

@end

@interface SEInputBar : UIView

+ (CGFloat)se_calculateHeight;

@property (nonatomic, copy) NSString *text;//

@property (nonatomic, weak) void (^textDidChange)(NSString *text, SEInputBarType type, NSIndexPath *indexPath);

@property (nonatomic, weak) id <SEInputBarDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) SEInputBarType type;

@end
