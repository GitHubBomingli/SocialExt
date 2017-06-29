//
//  SEEmotionKeyboard.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/22.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SEEmotionKeyboard.h"
#import "SEConfig.h"
#import "SEEmotionCollectionViewCell.h"

@interface SEEmotionKeyboard () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *sendBtn;

@property (nonatomic, strong) UIButton *backspaceBtn;

@property (nonatomic, strong) UICollectionView *typeCollectionView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *resources;

@property (nonatomic, assign) NSInteger type;

@end

@implementation SEEmotionKeyboard {
    CGFloat _itemWidthHeight;
}

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _itemWidthHeight = SEScreen_Width / 7.f;
        
        [self addSubview:self.collectionView];
        [self addSubview:self.typeCollectionView];
        [self addSubview:self.sendBtn];
        [self addSubview:self.pageControl];
        [self addSubview:self.backspaceBtn];
        
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.height.mas_equalTo(ceilf(_itemWidthHeight * 3));
        make.right.mas_equalTo(self.mas_right);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.collectionView.mas_bottom);
        make.left.mas_equalTo(self.mas_left);
        make.height.mas_equalTo(_itemWidthHeight * 0.618);
        make.right.mas_equalTo(self.mas_right);
    }];
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pageControl.mas_bottom);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.width.mas_equalTo(self.sendBtn.mas_height).multipliedBy(1.62);
    }];
    
    [self.typeCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pageControl.mas_bottom);
        make.left.mas_equalTo(self.mas_left);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.right.mas_equalTo(self.sendBtn.mas_left);
    }];
    
    [self.backspaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.collectionView.mas_bottom);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.sendBtn.mas_top);
        make.width.mas_equalTo(self.sendBtn.mas_height).multipliedBy(1.62);
    }];
}

#pragma mark - Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.collectionView]) {
        return [self.resources[_type] count];
    } else {
        return [self.resources count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SEEmotionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SEEmotionCollectionViewCell class]) forIndexPath:indexPath];
    if ([collectionView isEqual:self.collectionView]) {
        cell.label.text = self.resources[_type][indexPath.item];
    } else {
        cell.label.text = [self.resources[_type] firstObject];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.collectionView]) {
        if ([self.delegate respondsToSelector:@selector(emotionKeyboard:touchUpTheResponseOfEmoticon:)]) {
            [self.delegate emotionKeyboard:self touchUpTheResponseOfEmoticon:self.resources[_type][indexPath.item]];
        }
    } else {
        _type = indexPath.item;
        self.pageControl.numberOfPages = ceilf([self.resources[_type] count] / 21.f);
        [self.collectionView reloadData];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.collectionView]) {
        int index = ceilf(scrollView.contentOffset.x / SEScreen_Width);
        self.pageControl.currentPage = index;
    } else {
    }
}

#pragma mark - event response
- (void)touchUpTheResponseOfSendBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(emotionKeyboardTouchUpTheResponseOfSend:)]) {
        [self.delegate emotionKeyboardTouchUpTheResponseOfSend:self];
    }
}

- (void)touchUpTheResponseOfBackspaceBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(emotionKeyboardTouchUpTheResponseOfBackspace:)]) {
        [self.delegate emotionKeyboardTouchUpTheResponseOfBackspace:self];
    }
}

- (void)touchUpTheResponseOfPageControl:(UIPageControl *)pageControl {
    [self.collectionView setContentOffset:CGPointMake(pageControl.currentPage * SEScreen_Width, 0)];
}

#pragma mark - private methods
+ (NSDictionary *)emojis{
    static NSDictionary *_emojis = nil;
    if (!_emojis){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"SEEmotion" ofType:@"json"];
        NSData *emojiData = [[NSData alloc] initWithContentsOfFile:path];
        _emojis = [NSJSONSerialization JSONObjectWithData:emojiData options:NSJSONReadingAllowFragments error:nil];
    }
    return _emojis;
}

+ (CGFloat)se_calculateHeight {
    return ceilf(SEScreen_Width / 7.f * 3 + SEScreen_Width / 7.f * 0.618 * 2);
}

#pragma mark - getter and setter
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(_itemWidthHeight, _itemWidthHeight);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SEScreen_Height - _itemWidthHeight * 5, SEScreen_Width, _itemWidthHeight * 5) collectionViewLayout:layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = SERGB(0xEEEEEE);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[SEEmotionCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([SEEmotionCollectionViewCell class])];
        
    }
    return _collectionView;
}

- (UICollectionView *)typeCollectionView {
    if (_typeCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(_itemWidthHeight, _itemWidthHeight);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _typeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SEScreen_Height - _itemWidthHeight * 5, SEScreen_Width, _itemWidthHeight * 5) collectionViewLayout:layout];
        _typeCollectionView.pagingEnabled = YES;
        _typeCollectionView.backgroundColor = [UIColor whiteColor];
        _typeCollectionView.dataSource = self;
        _typeCollectionView.delegate = self;
        
        [_typeCollectionView registerClass:[SEEmotionCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([SEEmotionCollectionViewCell class])];
    }
    return _typeCollectionView;
}

- (UIButton *)sendBtn {
    if (_sendBtn == nil) {
        _sendBtn = [[UIButton alloc] init];
        _sendBtn.backgroundColor = SERGB(0xEEEEEE);
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _sendBtn.layer.shadowColor = [UIColor blackColor].CGColor;
        _sendBtn.layer.shadowOpacity = 0.5;
        [_sendBtn addTarget:self action:@selector(touchUpTheResponseOfSendBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

- (UIButton *)backspaceBtn {
    if (_backspaceBtn == nil) {
        _backspaceBtn = [[UIButton alloc] init];
        _backspaceBtn.backgroundColor = SERGB(0xEEEEEE);
        _backspaceBtn.contentMode = UIViewContentModeScaleAspectFit;
        _backspaceBtn.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
        [_backspaceBtn setImage:[UIImage imageNamed:@"keyboard_btn_delete"] forState:UIControlStateNormal];
        [_backspaceBtn addTarget:self action:@selector(touchUpTheResponseOfBackspaceBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backspaceBtn;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = ceilf([self.resources[_type] count] / 21.f);
        _pageControl.backgroundColor = SERGB(0xEEEEEE);
        _pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        [_pageControl addTarget:self action:@selector(touchUpTheResponseOfPageControl:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

- (NSMutableArray *)resources {
    if (_resources == nil) {
        _resources = [NSMutableArray array];
        NSDictionary *dic = [SEEmotionKeyboard emojis];
        [_resources addObjectsFromArray:[dic objectForKey:@"emotion"]];
    }
    return _resources;
}
@end
