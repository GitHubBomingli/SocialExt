//
//  SEImageViewManager.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/15.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SEImageViewManager : NSObject

+ (instancetype)manager;

- (void)insertImageView:(UIImageView *)imageView;

- (void)removeImageView:(UIImageView *)imageView;

//- (UIImageView *)imageView;

- (void)removeAllObjects;

@property (nonatomic, strong) UIImageView *imageView;//

@end
