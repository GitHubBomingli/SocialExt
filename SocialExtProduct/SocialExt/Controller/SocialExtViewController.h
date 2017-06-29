//
//  SocialExtViewController.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/8.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEBodyView.h"

@interface SocialExtViewController : UIViewController

@property (nonatomic, copy) NSString *headerBackgroundImageName;//头视图背景，图片名，作为默认图片

@property (nonatomic, copy) NSString *userHeadPlaceholderImageName;//默认头像

@property (nonatomic, strong) SEUserModel *userModel;//登录用户数据

@property (nonatomic, assign) CGFloat colorWithAlphaComponent;//背景视图遮罩效果。value取值0~1之间。默认0，无遮罩

@end
