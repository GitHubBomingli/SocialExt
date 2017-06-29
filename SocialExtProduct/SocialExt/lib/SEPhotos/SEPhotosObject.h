//
//  SEPhotosObject.h
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/25.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface SEAblumList : NSObject

/**
 相册名字
 */
@property (nonatomic, copy) NSString *title;

/**
 相册内相片数量
 */
@property (nonatomic, assign) NSInteger count;

/**
 相册第一张图片缩略图
 */
@property (nonatomic, strong) PHAsset *headImageAsset;

/**
 相册集，通过该属性获取该相册集下所有照片
 */
@property (nonatomic, strong) PHAssetCollection *assetCollection;

@end

@interface SEPhotosObject : NSObject

+ (instancetype)sharePhotoObject;

/**
 * @brief 获取用户所有相册列表
 */
- (NSArray<SEAblumList *> *)getPhotoAblumList;


/**
 获取相册内所有图片资源
 @param ascending 是否按创建时间正序排列 YES,创建时间正（升）序排列; NO,创建时间倒（降）序排列
 */
- (NSArray<PHAsset *> *)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending;


/**
 获取指定相册内的所有图片
 */
- (NSArray<PHAsset *> *)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending;


/**
 获取每个Asset对应的图片（缩放）
 */
- (void)requestImageForAsset:(PHAsset *)asset size:(CGSize)size resizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *image))completion;

/**
 获取原图
 */
- (void)requestImageMaximumSizeForAsset:(PHAsset *)asset resizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *image))completion;
@end
