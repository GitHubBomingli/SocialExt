//
//  UIView+Effect.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/10.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "UIView+Effect.h"

@implementation UIView (Effect)

- (void)se_shadowWithRadius:(CGFloat)radius {
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(radius, radius);
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = 0.5;
}

@end
