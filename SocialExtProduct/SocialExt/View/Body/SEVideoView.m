//
//  SEVideoView.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/10.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SEVideoView.h"
#import "SEConfig.h"
#import <AVFoundation/AVFoundation.h>

@interface SEVideoView ()

/**
 用于添加开始的图片
 */
@property (nonatomic, strong) CALayer *startLayer;

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

@end

@implementation SEVideoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = SERGB(0xDDDDDD);
        self.layer.masksToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        [self.layer addSublayer:self.startLayer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDidFinish:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (CGFloat)se_calculateViewHeight {
    return (CGFloat)(SEScreen_Width - seLeftSpacing - seSpacing) / seVideoResolution;
}

- (void)pause {
    _startLayer.hidden = NO;
    [_player pause];
    _playing = NO;
}

- (void)play {
    if (_playerLayer == nil || _player == nil) {
        NSURL *url = [NSURL URLWithString:_videoUrl];
        _playerItem = [[AVPlayerItem alloc] initWithURL:url];
        _player = [AVPlayer playerWithPlayerItem:_playerItem];
        _player.muted = YES;
        [_playerLayer removeFromSuperlayer];
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _playerLayer.frame = CGRectMake(0, 0, (SEScreen_Width - seLeftSpacing - seSpacing), [SEVideoView se_calculateViewHeight]);
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.layer insertSublayer:_playerLayer below:_startLayer];
    }
    
    _startLayer.hidden = YES;
    [_player play];
    _playing = YES;
}

- (void)playDidFinish:(NSNotification *)notification {
    [_player seekToTime:CMTimeMake(0, 1)];
    [self play];
}

- (void)setVideoUrl:(NSString *)videoUrl {
    if ([videoUrl isEqualToString:_videoUrl] && seAvoidRepeatedLoadingSetMethods) {//tableView滚动时，避免重复加载set方法
        return ;
    }

    [_playerLayer removeFromSuperlayer];
    _playerLayer = nil;
    _videoUrl = videoUrl;
    
    NSURL *url = [NSURL URLWithString:_videoUrl];
    
    dispatch_async(dispatch_queue_create("thumbnailImageRequestURL", DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL), ^{
        UIImage *thumbnailImage = [self thumbnailImageRequestURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.layer.contents = (__bridge id _Nullable)(thumbnailImage.CGImage);
        });
        
    });
    
}


- (CALayer *)startLayer {
    if (_startLayer == nil) {
        _startLayer = [CALayer layer];
        CGFloat superViewWidth = SEScreen_Width - seLeftSpacing - seSpacing;
        CGFloat widthHeight = 40;//宽高
        _startLayer.frame = CGRectMake((superViewWidth - widthHeight) / 2.f, ([SEVideoView se_calculateViewHeight] - widthHeight) / 2.f, widthHeight, widthHeight);//居中显示
        _startLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"icon-bofang"].CGImage);
    }
    return _startLayer;
}

/**
 *  截取指定时间的视频缩略图
 */
-(UIImage *)thumbnailImageRequestURL:(NSURL *)url {
    
    //根据url创建AVURLAsset
    AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:url options:nil];
    //根据AVURLAsset创建AVAssetImageGenerator
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:urlAsset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    
    NSError *error = nil;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);//CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要获得某一秒的第几帧可以使用CMTimeMake方法)
    CMTime actualTime;
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    if(error){
        NSLog(@"截取视频缩略图时发生错误，错误信息：%@",error);
        return nil;
    } else {
        CMTimeShow(actualTime);
        UIImage *image = [UIImage imageWithCGImage:cgImage];//转化为UIImage
        CGImageRelease(cgImage);
        return image;
    }
}

@end
