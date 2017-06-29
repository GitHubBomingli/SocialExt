//
//  SECommentModel.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/8.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

#import "SEUserModel.h"

typedef enum : NSUInteger {
    KSECommentTypeToBody = 0,//对动态评论
    KSECommentTypeToUser,//回复某个人
} KSECommentType;
@interface SECommentModel : NSObject

@property (nonatomic, copy) NSString *commentId;//评论ID

@property (nonatomic, strong) SEUserModel *commenter;//评论发布者

@property (nonatomic, strong) SEUserModel *toCommenter;//被回复的人

@property (nonatomic, copy) NSString *comment;//评论内容

@property (nonatomic, assign) KSECommentType type;//评论类型
@end
