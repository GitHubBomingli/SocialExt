//
//  SEPhotosViewController.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/25.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SEPhotosViewController : UIViewController

+ (instancetype)photosWithMaximumNumber:(NSInteger)maximumNumber completion:(void(^)(NSArray *images))completion target:(id)target;

@property (nonatomic, assign) NSInteger maximumNumber;//可选的最大数量限制。≤ 0 时无限制

@property (nonatomic, copy) void(^completion)(NSArray *images);

@end
