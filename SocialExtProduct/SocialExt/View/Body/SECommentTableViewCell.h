//
//  SECommentTableViewCell.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/8.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SECommentModel.h"

@class SECommentTableViewCell;

@protocol SECommentDelegate <NSObject>

@required

/**
 点击评论的响应

 @param cell 自定义cell
 @param commentModel 评论数据
 */
- (void)commentCell:(SECommentTableViewCell *)cell touchUpTheResponseOfComment:(SECommentModel *)commentModel;

@optional

/**
 点击评论者的响应
 
 @param cell 自定义cell
 @param commentModel 评论数据
 */
- (void)commentCell:(SECommentTableViewCell *)cell touchUpTheResponseOfCommenter:(SECommentModel *)commentModel;

/**
 点击被追问者的响应
 
 @param cell 自定义cell
 @param commentModel 评论数据
 */
- (void)commentCell:(SECommentTableViewCell *)cell touchUpTheResponseOfToCommenter:(SECommentModel *)commentModel;
@end

@interface SECommentTableViewCell : UITableViewCell

@property (nonatomic, strong) SECommentModel *model;//评论

@property (nonatomic, weak) id <SECommentDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

/**
 计算cell的高度

 @param commentModel 评论数据
 @return cell的高度
 */
+ (CGFloat)se_calculateCellHeightWith:(SECommentModel *)commentModel;

@end
