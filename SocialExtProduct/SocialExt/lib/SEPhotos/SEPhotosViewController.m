//
//  SEPhotosViewController.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/25.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SEPhotosViewController.h"
#import "SEPhotosCell.h"
#import "SEPhotosObject.h"
#import "SEConfig.h"

@interface SEPhotosViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, strong) NSMutableArray *selectedIndexPaths;

@end

@implementation SEPhotosViewController {
    CGFloat _itemWidthHeight;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _itemWidthHeight = floorf((SEScreen_Width - seSpacing / 2.f * 5) / 4.f);
    }
    return self;
}

+ (instancetype)photosWithMaximumNumber:(NSInteger)maximumNumber completion:(void (^)(NSArray *))completion target:(id)target {
    SEPhotosViewController *photosVC = [[SEPhotosViewController alloc] init];
    photosVC.completion = completion;
    photosVC.maximumNumber = maximumNumber;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:photosVC];
    [target presentViewController:navigationController animated:YES completion:nil];
    return photosVC;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // add subview
    self.title = @"相册";
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishAction)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
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
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SEPhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SEPhotosCell class]) forIndexPath:indexPath];
    PHAsset *asset = self.photos[indexPath.item];
    [self getImageWithAsset:asset completion:^(UIImage *image) {
        cell.imageView.image = image;
        cell.isSelected = [self.selectedIndexPaths containsObject:indexPath];
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndexPaths.count >= _maximumNumber && _maximumNumber > 0) {
        if ([self.selectedIndexPaths containsObject:indexPath] == NO) {
            return ;
        }
    }
    
    SEPhotosCell *cell = (SEPhotosCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.isSelected == NO) {
        [self.selectedIndexPaths addObject:indexPath];
        cell.isSelected = YES;
    } else {
        [self.selectedIndexPaths removeObject:indexPath];
        cell.isSelected = NO;
    }
    
    if (self.selectedIndexPaths.count > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

#pragma mark - event response
- (void)finishAction {
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.center = self.view.center;
    [self.navigationController.view addSubview:activity];
    [activity startAnimating];
    
    NSMutableArray *images = [NSMutableArray array];
    [self getOriginalImageWith:0 container:images completion:^(NSMutableArray *container) {
        if (_completion) self.completion(container);
        [activity stopAnimating];
        [self cancelAction];
    }];
}

- (void)cancelAction {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - private methods
//从这个回调中获取所有的图片（缩放）
- (void)getImageWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *image))completion {
    CGSize size = [self getSizeWithAsset:asset];
    [[SEPhotosObject sharePhotoObject] requestImageForAsset:asset size:size resizeMode:PHImageRequestOptionsResizeModeFast completion:completion];
}

//获取图片及图片尺寸的相关方法
- (CGSize)getSizeWithAsset:(PHAsset *)asset {
    CGFloat width  = (CGFloat)asset.pixelWidth;
    CGFloat height = (CGFloat)asset.pixelHeight;
    CGFloat scale = width/height;
    
    return CGSizeMake(self.collectionView.frame.size.height*scale, self.collectionView.frame.size.height);
}

/**
 循环获取图片

 @param index 索引，= 0
 @param container 获取到的图片存放容器
 @param completion 全部获取后的回调
 */
- (void)getOriginalImageWith:(NSInteger)index container:(NSMutableArray *)container completion:(void (^)(NSMutableArray *container))completion {
    
    NSIndexPath *indexPath = self.selectedIndexPaths[index];
    PHAsset *asset = self.photos[indexPath.item];
    //获取原尺寸图片
    [[SEPhotosObject sharePhotoObject] requestImageMaximumSizeForAsset:asset resizeMode:PHImageRequestOptionsResizeModeNone completion:^(UIImage *image) {
        [container addObject:image];
        if (index < (self.selectedIndexPaths.count - 1)) {
            [self getOriginalImageWith:(index + 1) container:container completion:completion];
        } else if (container.count == self.selectedIndexPaths.count) {
           completion(container);
        }
    }];
}

#pragma mark - getters and setters
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(_itemWidthHeight, _itemWidthHeight);
        layout.minimumLineSpacing = seSpacing / 2.f;
        layout.minimumInteritemSpacing = seSpacing / 2.f;
        layout.sectionInset = UIEdgeInsetsMake(seSpacing, seSpacing / 2.f, seSpacing, seSpacing / 2.f);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = SERGB(0xEEEEEE);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[SEPhotosCell class] forCellWithReuseIdentifier:NSStringFromClass([SEPhotosCell class])];
        
    }
    return _collectionView;
}

- (NSMutableArray *)photos {
    if (_photos == nil) {
        _photos = [NSMutableArray arrayWithArray:[[SEPhotosObject sharePhotoObject] getAllAssetInPhotoAblumWithAscending:NO]];
    }
    return _photos;
}

- (NSMutableArray *)selectedIndexPaths {
    if (_selectedIndexPaths == nil) {
        _selectedIndexPaths = [NSMutableArray array];
    }
    return _selectedIndexPaths;
}
#pragma mark - memory manage
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
