//
//  SEPublishImagesCell.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/26.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SEPublishImagesCell.h"
#import "SEConfig.h"
#import "SEPublishImageCollectionViewCell.h"
#import "SDPhotoBrowser.h"

@interface SEPublishImagesCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SDPhotoBrowserDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SEPublishImagesCell {
    CGFloat _itemWidthHeight;
    SDPhotoBrowser *_photoBrowser;
    NSInteger _movingIndex;
}
#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat width = MIN(SEScreen_Width, SEScreen_Height);
        _itemWidthHeight = floorf((width - seSpacing * 7) / 4.f);
        
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}

#pragma mark - event response
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)longPressTheResponseOfItem:(UIGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan : {
            // 判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[gesture locationInView:self.collectionView]];
            if (indexPath == nil) {
                break;
            }
            _movingIndex = indexPath.item;
            // 在路径上则开始移动该路径上的cell
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged :
            // 移动过程当中随时更新cell位置
            [self.collectionView updateInteractiveMovementTargetPosition:[gesture locationInView:self.collectionView]];
            break;
        case UIGestureRecognizerStateEnded:
            // 判断当前位置是否在视图内
            if (CGRectContainsPoint(self.collectionView.bounds, [gesture locationInView:self.collectionView])) {
                // 移动结束后关闭cell移动
                [self.collectionView endInteractiveMovement];
            } else {
                // 超出当前视图则取消移动
                [self.collectionView cancelInteractiveMovement];
                if (_movingIndex >= 0 && _movingIndex < _images.count) {
                    if (_deleteCallback) self.deleteCallback(_movingIndex);
                }
            }
            break;
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}

#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count == SEImage_Max_NumberOfImages ? SEImage_Max_NumberOfImages : self.images.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SEPublishImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SEPublishImageCollectionViewCell class]) forIndexPath:indexPath];
    if (indexPath.item < self.images.count) {
        cell.imageView.image = self.images[indexPath.item];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"icon-tianjia"];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.images.count) {//预览
        _photoBrowser = [[SDPhotoBrowser alloc] init];
        _photoBrowser.sourceImagesContainerView = self.collectionView;
        _photoBrowser.imageCount = _images.count;
        _photoBrowser.delegate = self;
        _photoBrowser.currentImageIndex = indexPath.item;
        [_photoBrowser show];
    } else {//添加回调
        if (_addCallback) self.addCallback();
    }
}
/**
 允许移动的item
 */
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.images.count) {//禁止移动添加图标
        return NO;
    }
    return YES;
}
/**
 对交换过的item数据进行操作
 */
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    
    [self.images exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
    [self.collectionView reloadData];
}
/**
 抑制item移动
 */
- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath {
    // 可以指定位置禁止交换
    if (proposedIndexPath.item == self.images.count) {
        return originalIndexPath;
    } else {
        return proposedIndexPath;
    }
}

#pragma mark SDPhotoBrowserDelegate
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    return _images[index];
}

#pragma mark - setter and getter

- (void)setImages:(NSMutableArray *)images {
    _images = images;
    _movingIndex = -1;
    NSInteger count = self.images.count == SEImage_Max_NumberOfImages ? SEImage_Max_NumberOfImages : self.images.count + 1;
    int numberOfLine = ceilf(count / 4.f);
    numberOfLine = numberOfLine > 0 ? numberOfLine : 1;
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).mas_offset(seSpacing);
        make.left.mas_equalTo(self.contentView).mas_offset(seSpacing);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-seSpacing);
        make.right.mas_equalTo(self.contentView).mas_offset(-seSpacing);
        make.height.mas_equalTo((_itemWidthHeight + seSpacing) * numberOfLine - seSpacing).priority(999);
    }];
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(_itemWidthHeight, _itemWidthHeight);
        layout.minimumLineSpacing = seSpacing;
        layout.minimumInteritemSpacing = seSpacing;
        layout.sectionInset = UIEdgeInsetsMake(0, seSpacing, 0, seSpacing);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[SEPublishImageCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([SEPublishImageCollectionViewCell class])];
        //添加长按手势，用于实现拖动排序
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressTheResponseOfItem:)];
        [_collectionView addGestureRecognizer:longPress];
    }
    return _collectionView;
}

@end
