//
//  SEWebViewController.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/23.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SEWebViewController.h"
#import "SEConfig.h"

@interface SEWebViewController ()

@end

@implementation SEWebViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SEBackgroundColor_Main;
    // add subview
    switch (_type) {
        case SEWebViewControllerTypeShare:
            self.title = @"分享";
            break;
            
        case SEWebViewControllerTypeAddress:
            self.title = @"地址";
            
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //layout
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //notification
}

- (void)dealloc {
}

#pragma mark - delegate

#pragma mark - event response

#pragma mark - private methods

#pragma mark - getters and setters

#pragma mark - memory manage
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
