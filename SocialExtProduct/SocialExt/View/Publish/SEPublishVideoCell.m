//
//  SEPublishVideoCell.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/26.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SEPublishVideoCell.h"
#import <AVFoundation/AVFoundation.h>
#import "SEConfig.h"

@interface SEPublishVideoCell ()

/**
 播放器
 */
@property (nonatomic, strong) AVPlayer *player;

/**
 视频资源
 */
@property (nonatomic, strong) AVPlayerItem *playerItem;

/**
 播放器容器
 */
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) UIView *containerView;

@end

@implementation SEPublishVideoCell {
    CGFloat _itemWidthHeight;
}

#pragma mark - life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        _itemWidthHeight = 66.f;
        
        [self.contentView addSubview:self.containerView];
        
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).mas_offset(seSpacing);
            make.left.mas_equalTo(self.contentView).mas_offset(seSpacing * 2);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-seSpacing);
            make.height.mas_equalTo(_itemWidthHeight);
            make.width.mas_equalTo(_itemWidthHeight * seVideoResolution);
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDidFinish:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - event response
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)touchUpTheResponseOfVideo {
    if (_touchUpVideoCallback) {
        self.touchUpVideoCallback(_videoUrl);
    }
}

#pragma mark - private methods
- (void)playDidFinish:(NSNotification *)notification {
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player play];
}

#pragma mark - getter and setter
- (void)setVideoUrl:(NSURL *)videoUrl {
    _videoUrl = videoUrl;
    
    _playerItem = [[AVPlayerItem alloc] initWithURL:videoUrl];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    _player.muted = YES;
    
    [_playerLayer removeFromSuperlayer];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = CGRectMake(0, 0, _itemWidthHeight * seVideoResolution, _itemWidthHeight);
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.containerView.layer addSublayer:_playerLayer];
    
    [_player play];
}


- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpTheResponseOfVideo)];
        [_containerView addGestureRecognizer:tap];
    }
    return _containerView;
}

@end
