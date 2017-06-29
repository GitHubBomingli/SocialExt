//
//  SEBodyView.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/9.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEBodyModel.h"
#import "SESectionHeightManager.h"

@class SEBodyView;

@protocol SEBodyViewDelegate <NSObject>

/**
 点击头像的响应

 @param bodyView 动态视图
 @param userModel 用户数据
 */
- (void)bodyView:(SEBodyView *)bodyView touchUpTheResponseOfHead:(SEUserModel *)userModel;

/**
 点击折叠按钮的响应
 
 @param bodyView 动态视图
 @param fold 是否折叠。NO，不折叠
 @param section 索引
 */
- (void)bodyView:(SEBodyView *)bodyView touchUpTheResponseOfFold:(BOOL)fold section:(NSInteger)section;

/**
 点击地址按钮的响应
 
 @param bodyView 动态视图
 @param address 地址链接
 */
- (void)bodyView:(SEBodyView *)bodyView touchUpTheResponseOfAddress:(NSString *)address;

/**
 点击删除按钮的响应
 
 @param bodyView 动态视图
 @param section 索引
 @param bodyId 动态ID
 */
- (void)bodyView:(SEBodyView *)bodyView touchUpTheResponseOfDeleteForSection:(NSInteger)section bodyId:(NSString *)bodyId;

/**
 点击视频的响应
 
 @param bodyView 动态视图
 @param vidoeUrl 视频链接
 */
- (void)bodyView:(SEBodyView *)bodyView touchUpTheResponseOfPlayVideo:(NSString *)vidoeUrl;

/**
 点击分享的响应
 
 @param bodyView 动态视图
 @param shareModel 分享内容
 */
- (void)bodyView:(SEBodyView *)bodyView touchUpTheResponseOfIntoShare:(SEShareModel *)shareModel;

/**
 点赞或取消按钮回调
 
 @param bodyView 视图
 @param praiseOrcancel YES，点赞；NO，取消
 */
- (void)bodyView:(SEBodyView *)bodyView touchUpTheResponseOfPraise:(BOOL)praiseOrcancel;

/**
 点击评论按钮回调

 @param bodyView 视图
 @param bodyModel 数据
 */
- (void)bodyView:(SEBodyView *)bodyView touchUpTheResponseOfComment:(SEBodyModel *)bodyModel;

/**
 点击点赞者回调
 
 @param bodyView 视图
 @param laudatorModel 点赞者
 */
- (void)bodyView:(SEBodyView *)bodyView touchUpTheResponseOfLaudator:(SEUserModel *)laudatorModel;

/**
 点击人数查看更多回调
 
 @param bodyView 视图
 @param praises 点赞数组
 */
- (void)bodyView:(SEBodyView *)bodyView touchUpTheResponseOfNumber:(NSArray *)praises;

@end

@interface SEBodyView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIScrollView *scrollView;//

@property (nonatomic, assign) NSInteger section;//header or footer section

@property (nonatomic, copy) NSString *userHeadPlaceholderImageName;//默认头像

@property (nonatomic, strong) SEUserModel *userModel;//登录用户

@property (nonatomic, strong) SEBodyModel *model;//动态

@property (nonatomic, weak) id <SEBodyViewDelegate> delegate;

@property (nonatomic, assign) BOOL fold;//是否折叠。默认YES，折叠

/**
 计算视图的高度

 @param model 数据
 @param fold 是否折叠
 @return 视图高度
 */
+ (CGFloat)se_calculateViewHeightWith:(SEBodyModel *)model fold:(BOOL)fold section:(NSInteger)section;

@end
