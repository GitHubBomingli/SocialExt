//
//  SEImageViewManager.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/15.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SEImageViewManager.h"

@interface SEImageViewManager ()

@property (nonatomic, strong) NSMutableSet *set;

@end

@implementation SEImageViewManager

#pragma mark - life cycle
+ (instancetype)manager {
    static SEImageViewManager *seImageViewManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        seImageViewManager = [[SEImageViewManager alloc] init];
    });
    return seImageViewManager;
}

- (void)insertImageView:(UIImageView *)imageView {
    [self.set addObject:imageView];
}

- (void)removeImageView:(UIImageView *)imageView {
    [self.set removeObject:imageView];
}

- (UIImageView *)imageView {
    UIImageView *imageView = self.set.anyObject;
    if (imageView) {
        [self.set removeObject:imageView];
    } else {
        imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled = YES;
        imageView.layer.masksToBounds = YES;
    }
    return imageView;
}

- (void)removeAllObjects {
    [self.set removeAllObjects];
}

- (NSMutableSet *)set {
    if (_set == nil) {
        _set = [NSMutableSet set];
    }
    return _set;
}

@end
