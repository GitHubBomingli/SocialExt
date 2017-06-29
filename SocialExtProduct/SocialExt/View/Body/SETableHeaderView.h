//
//  SETableHeaderView.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/9.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEUserModel.h"

@class SETableHeaderView;

@protocol SETableHeaderViewDelegate <NSObject>

/**
 点击背景视图的响应

 @param headerView 头视图
 @param userModel 用户数据
 */
- (void)tableHeaderView:(SETableHeaderView *)headerView touchUpTheResponseOfChangeHead:(SEUserModel *)userModel;

/**
 点击用户头像的响应
 
 @param headerView 头视图
 @param userModel 用户数据
 */
- (void)tableHeaderView:(SETableHeaderView *)headerView touchUpTheResponseOfViewHead:(SEUserModel *)userModel;

/**
 点击未读消息的响应
 
 @param headerView 头视图
 @param userModel 用户数据
 */
- (void)tableHeaderView:(SETableHeaderView *)headerView touchUpTheResponseOfViewUnread:(SEUserModel *)userModel;

@end

@interface SETableHeaderView : UIView

@property (nonatomic, strong) SEUserModel *userModel;//登录用户

@property (nonatomic, assign) NSInteger unreadNumber;//未读消息数

@property (nonatomic, copy) NSString *userHeadPlaceholderImageName;//默认头像

@property (nonatomic, weak) id <SETableHeaderViewDelegate> delegate;

@end
