//
//  SEPraiseListView.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/17.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEPraiseModel.h"
#import "SEUserModel.h"

@class SEPraiseListView;

@protocol SEPraiseListViewDelegate <NSObject>

/**
 点击点赞者回调

 @param praiseListView 视图
 @param laudatorModel 点赞者
 */
- (void)praiseListView:(SEPraiseListView *)praiseListView touchUpTheResponseOfLaudator:(SEUserModel *)laudatorModel;

/**
 点击人数查看更多回调

 @param praiseListView 视图
 @param praises 点赞数组
 */
- (void)praiseListView:(SEPraiseListView *)praiseListView touchUpTheResponseOfNumber:(NSArray *)praises;

@end

@interface SEPraiseListView : UIView

@property (nonatomic, strong) NSArray *praises;//赞

@property (nonatomic, weak) id <SEPraiseListViewDelegate> delegate;

+ (CGFloat)se_calculateViewHeightWith:(NSArray *)praises;

@end
