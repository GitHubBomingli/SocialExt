//
//  SECapturePhotoVideo.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/23.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

typedef enum : NSUInteger {
    SECapturePhotoVideoTypePhotograph,
    SECapturePhotoVideoTypeVideo,
} SECapturePhotoVideoType;

@interface SECapturePhotoVideo : UIViewController 

@property (nonatomic, assign, readonly) SECapturePhotoVideoType type;//

@property (nonatomic, strong, readonly) NSMutableArray *images;

@property (nonatomic, strong, readonly) NSURL *outputFileURL;

@property (nonatomic, assign) NSInteger maximumNumber;//拍照的最大数量限制。≤ 0 时无限制

+ (instancetype)captureWithType:(SECapturePhotoVideoType)type maximumNumber:(NSInteger)maximumNumber finish:(void(^)(SECapturePhotoVideoType type, NSArray *images, NSURL *outputFileURL))finish target:(id)target;

/**
 将视频文件保存到相册

 @param fileURL 视频文件链接
 @return 是否成功
 */
+ (BOOL)se_writeVideoToPhotoAlbum:(NSURL *)fileURL;

@end
