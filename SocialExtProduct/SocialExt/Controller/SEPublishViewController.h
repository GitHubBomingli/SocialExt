//
//  SEPublishTextImageViewController.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/23.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEBodyView.h"

typedef enum : NSUInteger {
    SEPublishResourceTypeText,//纯文本
    SEPublishResourceTypePhotograph,//拍照
    SEPublishResourceTypePhotoAlbum,//相册
    SEPublishResourceTypeVideo,//视频
} SEPublishResourceType;

@interface SEPublishViewController : UIViewController

@property (nonatomic, assign) SEPublishResourceType resourceType;//资源类型

@property (nonatomic, strong) SEUserModel *userModel;//登录用户数据

@property (nonatomic, copy) void (^publishFinishCallback)(SEBodyModel *model);

@end
