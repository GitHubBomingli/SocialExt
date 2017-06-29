//
//  SEImageModel.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/8.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

@interface SEImageModel : NSObject

@property (nonatomic, copy) NSString *imageUrl;//图片链接

@property (nonatomic, copy) NSString *highQualityImageURL;//高质量

@property (nonatomic, assign) float imageHeight;//图片高度

@property (nonatomic, assign) float imageWidth;//图片宽度

@property (nonatomic, assign) float whRate;//宽比高
@end
