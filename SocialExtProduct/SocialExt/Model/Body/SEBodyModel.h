//
//  SEBodyModel.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/8.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

#import "SEUserModel.h"
#import "SEImageModel.h"
#import "SEShareModel.h"
#import "SESourceModel.h"
#import "SECommentModel.h"
#import "SEAddressModel.h"
#import "SEPraiseModel.h"

typedef enum : NSUInteger {
    KSEBodyTypePlainText = 0,//纯文本
    KSEBodyTypeImageText,//图+文
    KSEBodyTypeVideoText,//视频+文本
    KSEBodyTypeShareText,//分享+文本
} KSEBodyType;

@interface SEBodyModel : NSObject

@property (nonatomic, copy) NSString *bodyId;//动态ID

@property (nonatomic, assign) KSEBodyType type ;//动态类型

@property (nonatomic, strong) SEUserModel *user;//发布者

@property (nonatomic, copy) NSString *content;//文本

@property (nonatomic, strong) NSArray *images;//图片链接

@property (nonatomic, copy) NSString *video;//视频链接

@property (nonatomic, strong) SEShareModel *share;//分享

@property (nonatomic, strong) SEAddressModel *address;//地址

@property (nonatomic, copy) NSString *date;//时间,yyyy-MM-dd HH:mm:ss

@property (nonatomic, strong) SESourceModel *source;//来源

//@property (nonatomic, assign) BOOL praised;//是否已赞

@property (nonatomic, strong) NSMutableArray *praises;//赞

@property (nonatomic, strong) NSMutableArray *comments;//评论

@end
