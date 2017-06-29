//
//  SEImageListView.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/10.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SEImageListView.h"
#import "SEConfig.h"
#import "SEImageViewManager.h"
#import "SDPhotoBrowser.h"

@interface SEImageListView () <SDPhotoBrowserDelegate>

@property (nonatomic, strong) SDPhotoBrowser *photoBrowser;

@end

@implementation SEImageListView

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = SEBackgroundColor_clear;
    }
    return self;
}

- (void)dealloc {
}

#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    SEImageModel *model = self.images[index];
    NSString *imageName = model.highQualityImageURL;
    NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = self.subviews[index];
    return imageView.image;
}

#pragma mark - event response
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = touches.anyObject;
    if ([touch.view isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)touch.view;
        _photoBrowser = nil;
        self.photoBrowser.currentImageIndex = imageView.tag;
        [self.photoBrowser show];
    }
}

#pragma mark - private methods
+ (CGFloat)se_calculateViewHeightWith:(NSArray *)images {
    CGFloat superViewWidth = SEScreen_Width - seLeftSpacing - seSpacing;
    if (images.count == 1) {
        SEImageModel *model = images.lastObject;
        float scale = 1;//缩放比例
        if (model.whRate >= 1) {
            scale = model.imageWidth / (superViewWidth * 0.66);
        } else {
            scale = model.imageWidth / (superViewWidth * 0.5);
        }
        return model.imageHeight / scale;
    } else {
        CGFloat itemHeight = floorf((superViewWidth - seSpacing) / 3);
        if (images.count == 4) {
            return itemHeight * 2 + seSpacing / 2;
        } else {
            int numberOflines = ceilf((images.count / 3.f));
            return numberOflines * itemHeight + (numberOflines - 1) * seSpacing / 2;
        }
    }
}

#pragma mrk - getter and setter
- (void)setImages:(NSArray *)images {
    _images = images;
    //遍历子视图，如果是UIImageView类型，则加入图片管理器并且从父视图移除
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        *stop = YES;
        if ([obj isKindOfClass:[UIImageView class]]) {
            [[SEImageViewManager manager] insertImageView:obj];
            [obj removeFromSuperview];
        }
        *stop = NO;
    }];
    //父视图的宽度
    CGFloat superViewWidth = SEScreen_Width - seLeftSpacing - seSpacing;
    //添加图片视图
    if (images.count == 1) {//如果只有一张图片
        UIImageView *imageView = [SEImageViewManager manager].imageView;//从图片管理器中获取图片
        imageView.tag = 0;
        [self addSubview:imageView];
        SEImageModel *model = images.lastObject;
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:SEImageLoadPlaceholderName] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        }];
        float scale = 1;//缩放比例
        if (model.whRate >= 1) {
            scale = model.imageWidth / (superViewWidth * 0.66);
        } else {
            scale = model.imageWidth / (superViewWidth * 0.5);
        }
        [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(model.imageWidth / scale, model.imageHeight / scale));
        }];
    } else {//如果有多张图片
        UIView *topView = nil;//下一张视图的对上约束视图
        UIView *leftView = nil;//下一张视图的对左约束视图
        CGFloat itemWidth = floorf((superViewWidth - seSpacing) / 3);//每张图片视图的宽度（高度与宽度相等）
        for (NSInteger index = 0; index < images.count; index ++) {//遍历数据
            
            UIImageView *imageView = [SEImageViewManager manager].imageView;//从图片管理器中获取图片
            imageView.tag = index;
            [self addSubview:imageView];
            SEImageModel *model = images[index];
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:SEImageLoadPlaceholderName] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            }];
            //重制约束
            [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(itemWidth, itemWidth));
            }];
            //更新约束
            if (topView == nil) {
                [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.mas_top);
                }];
            } else {
                [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(topView.mas_bottom).mas_offset(seSpacing / 2);
                }];
            }
            if (leftView == nil) {
                [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.mas_left);
                }];
            } else {
                [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(leftView.mas_right).mas_offset(seSpacing / 2);
                }];
            }
            //确定下一张视图的对上与对左约束视图
            if (images.count == 4) {//如果有4张图片，则按照 2X2 方式排列
                if ((index + 1) % 2 == 0) {
                    topView = imageView;
                    leftView = nil;
                } else {
                    leftView = imageView;
                }
            } else {//反之，按照 3X3 方式排列
                if ((index + 1) % 3 == 0) {
                    topView = imageView;
                    leftView = nil;
                } else {
                    leftView = imageView;
                }
            }
        }
    }
}

- (SDPhotoBrowser *)photoBrowser {
    if (_photoBrowser == nil) {
        _photoBrowser = [[SDPhotoBrowser alloc] init];
        _photoBrowser.sourceImagesContainerView = self;
        _photoBrowser.imageCount = _images.count;
        _photoBrowser.delegate = self;
    }
    return _photoBrowser;
}

@end
