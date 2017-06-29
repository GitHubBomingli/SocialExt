//
//  SEWebViewController.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/23.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SEWebViewControllerTypeShare,
    SEWebViewControllerTypeAddress,
    SEWebViewControllerTypeOther,
} SEWebViewControllerType;

@interface SEWebViewController : UIViewController

@property (nonatomic, assign) SEWebViewControllerType type;//

@property (nonatomic, copy) NSString *url;//

@end
