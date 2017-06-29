//
//  SEVideoView.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/10.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SEVideoView : UIView

@property (nonatomic, copy) NSString *videoUrl;//视频连接

@property (nonatomic, assign, readonly) BOOL playing;

+ (CGFloat)se_calculateViewHeight;

- (void)pause;

- (void)play;

@end
