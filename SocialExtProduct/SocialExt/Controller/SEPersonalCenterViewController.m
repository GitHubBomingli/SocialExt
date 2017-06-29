//
//  SEPersonalCenterViewController.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/23.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SEPersonalCenterViewController.h"
#import "SEConfig.h"

@interface SEPersonalCenterViewController ()

@end

@implementation SEPersonalCenterViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // add subview
    self.view.backgroundColor = SEBackgroundColor_Main;
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
- (void)setUser:(SEUserModel *)user {
    _user = user;
    self.title = user.userName;
}

#pragma mark - memory manage
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
