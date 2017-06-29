//
//  SEPublishVideoCell.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/26.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SEPublishVideoCell : UITableViewCell

@property (nonatomic, strong) NSURL *videoUrl;//视频连接

@property (nonatomic, copy) void (^touchUpVideoCallback)(NSURL *URL);

@end
