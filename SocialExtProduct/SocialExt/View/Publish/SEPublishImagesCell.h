//
//  SEPublishImagesCell.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/26.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SEPublishImagesCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, copy) void (^addCallback) ();

@property (nonatomic, copy) void (^deleteCallback) (NSInteger index);

@end
