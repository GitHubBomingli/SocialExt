//
//  SEConfig.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/9.
//  Copyright © 2017年 伯明利. All rights reserved.
//

/************************************************************************************************
 =======================================    温馨提示    ==========================================
 ************************************************************************************************
 
 1、
 Info.plist中必须包含以下key：
 NSCameraUsageDescription
 NSPhotoLibraryUsageDescription
 NSMicrophoneUsageDescription
 
 您也可以直接拷贝下面内容至您的应用Info.plist中：
 <key>NSCameraUsageDescription</key>
 <string>我们需要您的同意才可以访问摄像头</string>
 <key>NSPhotoLibraryUsageDescription</key>
 <string>我们需要您的同意才可以访问相簿</string>
 <key>NSMicrophoneUsageDescription</key>
 <string>我们需要您的同意才可以访问麦克风</string>
 
 2、
 SocialExtViewController.m 中针对tableView的任何增删改操作（reload、delete、insert等）都必须先调用[[SESectionHeightManager manager] removeAllHeight] 方法（更新cell的高度缓存）
 
 3、
 调试过程中，如果包含视频的情况下设置全局断点，请将__cxa_throw断点释放
 
 4、
 数据结构请参考文件 SEBody0.json
 type == 0 : 纯文本；type == 1 : 图文；type == 2 : 视频；type == 3 : 分享
 
 5、
 视频、拍照、相册支持横、竖屏，建议在TAGETS/General里设置屏幕旋转方向支持横、竖屏；同时可以通过在UINavigationController里设置shouldAutorotate方法返回NO和preferredInterfaceOrientationForPresentation方法返回UIInterfaceOrientationPortrait的方式禁止其它屏幕横屏。
 
 6、
 SEDBTable...是对本地数据库的操作文件，用于本地缓存，发布动态或者评论、点赞等任意更改数据的操作请注意同步更新本地数据库（demo中含有“模拟数据”的注释为模拟操作，实际情况中，应该在网络请求后将返回的数据及时更新到本地数据库中）。
 
 ************************************************************************************************
 ************************************************************************************************/

#ifndef SEConfig_h
#define SEConfig_h

/* ------ frame ------ */
#define SEScreen_Height [UIScreen mainScreen].bounds.size.height
#define SEScreen_Width  [UIScreen mainScreen].bounds.size.width

static CGFloat const seSpacing = 8;                                                 //控件之间的留白
static CGFloat const seUserIconWidthHeight = 44;                                    //动态头像的宽与高
static CGFloat const seLeftSpacing = seSpacing + seUserIconWidthHeight + seSpacing; //图文等主要视图对左距离
static CGFloat const seShareHeight = 44;                                            //分享视图高度
static CGFloat const seVideoResolution = 16/9.f;                                    //视频分辨率

static BOOL const seAvoidRepeatedLoadingSetMethods = YES;                           //是否避免重复加载set方法
#define SEFlod_Max_NumberOfLines 6                                                  //折叠后显示的最多行数
#define SEPublishText_Max_Length 200                                                //发布动态时，文本的最大长度限制
#define SEPraise_Max_NumberOfLaudator 9                                             //显示点赞者的最大人数
#define SEImage_Max_NumberOfImages 9                                                //一次发布的图片最大数量
#define SEImageLoadPlaceholderName @"seDefault"                                     //默认加载图片

/* ------ color ------ */
#define SERGB(c)    [UIColor colorWithRed:((c>>16)&0xFF)/255.0	\
green:((c>>8)&0xFF)/255.0	\
blue:(c&0xFF)/255.0         \
alpha:1.0]

#define SETextColor_Title SERGB(0x333333)                                           //标题颜色
#define SETextColor_SubTitle SERGB(0x444444)                                        //副标题颜色
#define SETextColor_content SERGB(0x666666)                                         //文本颜色
#define SETextColor_Label SERGB(0x999999)                                           //标签颜色
#define SETextColor_Response SERGB(0x0B78E3)                                        //可响应文字颜色
#define SETextColor_Response_Highlighted SERGB(0x0B78E3)                            //可响应文字高亮颜色

#define SEBackgroundColor_Main SERGB(0xFFFFFF)                                      //主背景颜色
#define SEBackgroundColor_Comment SERGB(0xDDDDDD)                                   //评论等背景颜色
#define SEBackgroundColor_clear [UIColor clearColor]                                //透明背景
//#define SEBackgroundColor_clear [SERGB(0xEEEEEE) colorWithAlphaComponent:0.5]

/* ------ font ------ */
#define SETextFont_Title [UIFont systemFontOfSize:15]                               //标题字体大小
#define SETextFont_SubTitle [UIFont systemFontOfSize:14]                            //副标题字体大小
#define SETextFont_Content [UIFont systemFontOfSize:13]                             //文本字体大小
#define SETextFont_Label [UIFont systemFontOfSize:12]                               //标签字体大小

/* ------ import ------ */
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+Calculate.h"
#import "UIView+Effect.h"
#import "NSString+date.h"

#endif /* SEConfig_h */
