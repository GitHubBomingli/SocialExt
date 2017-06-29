//
//  SEMoreView.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/17.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SEMoreView;

@protocol SEMoreViewDelegate <NSObject>

/**
 点赞或取消回调

 @param moreView 控件
 @param praiseOrcancel YES，点赞；NO，取消
 */
- (void)moreView:(SEMoreView *)moreView touchUpTheResponseOfPraise:(BOOL)praiseOrcancel;

/**
 评论回调

 @param moreView 控件
 */
- (void)moreViewTouchUpTheResponseOfComment:(SEMoreView *)moreView;

@end

@interface SEMoreView : UIView

+ (CGFloat)se_calculateViewHeight;

@property (nonatomic, assign) BOOL praised;//是否已赞

@property  id <SEMoreViewDelegate> delegate;

/**
 显示控件

 @param point 控件右上角的坐标
 */
- (void)showWithPoint:(CGPoint)point;

/**
 隐藏控件
 */
- (void)hidden;

@end
