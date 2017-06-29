//
//  SECapturePhotoVideo.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/23.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SECapturePhotoVideo.h"
#import "SEConfig.h"
#import "SECapturePhotoShowCell.h"

#define SETakeSender_widthAndHeight 100

typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);

@interface SECapturePhotoVideo () <AVCapturePhotoCaptureDelegate, AVCaptureFileOutputRecordingDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/**
 #import <AVFoundation/AVFoundation.h>
 */
@property (nonatomic, strong) AVCaptureSession *captureSession;

/**
 负责从AVCaptureDevice获得输入数据
 */
@property (nonatomic, strong) AVCaptureDeviceInput *captureDeviceInput;

/**
 照片输出流
 */
@property (nonatomic, strong) AVCapturePhotoOutput *capturePhotoOutput;

/**
 视频输出流
 */
@property (nonatomic, strong) AVCaptureMovieFileOutput *captureMovieFileOutput;

/**
 相机拍摄预览图层
 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

/**
 容器
 */
@property (nonatomic, strong) UIView *viewContainer;

/**
 聚焦
 */
@property (nonatomic, strong) UIImageView *viewFocus;

/**
 拍照或录像按钮
 */
@property (nonatomic, strong) UIView *takeSender;

/**
 切换摄像头
 */
@property (nonatomic, strong) UIButton *switchCameraBtn;

/**
 展示
 */
@property (nonatomic, strong) UICollectionView *collectionView;

/**
 完成
 */
@property (nonatomic, strong) UIButton *finishBtn;

/**
 取消
 */
@property (nonatomic, strong) UIButton *cancelBtn;

/**
 录制进度
 */
@property (nonatomic, strong) UIProgressView *progressView;

/**
 操作提示
 */
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, copy) void (^finish)(SECapturePhotoVideoType, NSArray *, NSURL *);

@property (nonatomic, assign) BOOL enableRotation;

@end

@implementation SECapturePhotoVideo {
    NSTimer *_timer;
    BOOL _cancelMovieFileOutput;
}

#pragma mark - life cycle

+ (instancetype)captureWithType:(SECapturePhotoVideoType)type maximumNumber:(NSInteger)maximumNumber finish:(void (^)(SECapturePhotoVideoType, NSArray *, NSURL *))finish target:(id)target {
    SECapturePhotoVideo *captrure = [[SECapturePhotoVideo alloc] init];
    captrure.type = type;
    captrure.maximumNumber = maximumNumber;
    captrure.finish = finish;
    [target presentViewController:captrure animated:YES completion:nil];
    return captrure;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.enableRotation = YES;
    // add subview
    [self.view addSubview:self.viewContainer];
    [self.viewContainer addSubview:self.viewFocus];
    [self.view insertSubview:self.takeSender aboveSubview:self.viewContainer];
    [self.view insertSubview:self.collectionView aboveSubview:self.viewContainer];
    [self.view insertSubview:self.finishBtn aboveSubview:self.viewContainer];
    [self.view insertSubview:self.cancelBtn aboveSubview:self.viewContainer];
    [self.view insertSubview:self.switchCameraBtn aboveSubview:self.viewContainer];
    [self.view addSubview:self.progressView];
    [self.view insertSubview:self.messageLabel aboveSubview:self.viewContainer];
    
    _images = [NSMutableArray array];
    
    if (_type == SECapturePhotoVideoTypePhotograph) {
        [self.viewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view);
            make.left.mas_equalTo(self.view);
            make.right.mas_equalTo(self.view);
            make.height.mas_equalTo(self.view);
        }];
        
    } else if (_type == SECapturePhotoVideoTypeVideo) {
        [self.viewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view);
            make.left.mas_equalTo(self.view);
            make.right.mas_equalTo(self.view);
            make.height.mas_equalTo(self.view.mas_width).multipliedBy(1.f/seVideoResolution);
        }];
    }
    
    [self.takeSender mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).mas_offset(- 60);
        make.size.mas_equalTo(CGSizeMake(SETakeSender_widthAndHeight, SETakeSender_widthAndHeight));
    }];
    
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).mas_offset(-8);
        make.bottom.mas_equalTo(self.view).mas_offset(-8);
        make.size.mas_equalTo(CGSizeMake(44 / 0.618, 44));
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(8);
        make.right.mas_equalTo(self.finishBtn.mas_left).mas_offset(-8);
        make.bottom.mas_equalTo(self.view).mas_offset(-8);
        make.height.mas_equalTo(44);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.takeSender.mas_left).mas_offset(-8);
        make.centerY.mas_equalTo(self.takeSender);
        make.height.mas_equalTo(44);
    }];
    
    [self.switchCameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).mas_offset(-8);
        make.top.mas_equalTo(self.view).mas_offset(28);
        make.size.mas_equalTo(CGSizeMake(44 / 0.618, 44));
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.viewContainer.mas_bottom).mas_offset(-2);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.takeSender.mas_top).mas_offset(-8);
        make.centerX.mas_equalTo(self.takeSender);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //初始化会画
    _captureSession = [[AVCaptureSession alloc] init];
    
    //初始化设备输入
    NSError *error = nil;
    _captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self getCaptureDeviceWithPosition:AVCaptureDevicePositionBack mediaType:AVMediaTypeVideo] error:&error];
    if (error) {
        NSLog(@"error = %@",error);
        [self alertWith:error.localizedDescription];
        return ;
    }
    //添加音频输入设备
    AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput *audioCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:&error];
    if (error) {
        NSLog(@"error = %@",error);
        [self alertWith:error.localizedDescription];
        return ;
    }
    
    //初始化设备输出对象
    _capturePhotoOutput = [[AVCapturePhotoOutput alloc] init];
    _captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    //将设备输入添加到会话中
    if ([self.captureSession canAddInput:self.captureDeviceInput]) {
        [self.captureSession addInput:self.captureDeviceInput];
        [self.captureSession addInput:audioCaptureDeviceInput];
        AVCaptureConnection *captureConnection = [_captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([captureConnection isVideoStabilizationSupported]) {
            captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
    }
    
    //将设备输出添加到会话中
    if ([self.captureSession canAddOutput:self.capturePhotoOutput]) {
        [self.captureSession addOutput:self.capturePhotoOutput];
    }
    if ([_captureSession canAddOutput:_captureMovieFileOutput]) {
        [_captureSession addOutput:_captureMovieFileOutput];
    }
    
    if (_type == SECapturePhotoVideoTypePhotograph) {//拍照
        
    } else if (_type == SECapturePhotoVideoTypeVideo) {//视频
        
    }
    
    //创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    CALayer *layer = self.viewContainer.layer;
    layer.masksToBounds = YES;
    if (_type == SECapturePhotoVideoTypePhotograph) {
        _captureVideoPreviewLayer.frame = self.view.bounds;
    } else if (_type == SECapturePhotoVideoTypeVideo) {
        CGRect frame = self.view.bounds;
        frame.size.height = CGRectGetWidth(self.view.frame) / seVideoResolution;
        _captureVideoPreviewLayer.frame = frame;
    }
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;//填充模式
    [layer insertSublayer:_captureVideoPreviewLayer below:self.viewFocus.layer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //notification
    self.viewFocus.center = self.viewContainer.center;
    [self.captureSession startRunning];
    
//    [UIApplication sharedApplication].delegate 
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.captureSession stopRunning];
}

/**
 是否允许旋转屏幕
 */
-(BOOL)shouldAutorotate{
    return self.enableRotation;
}

//屏幕旋转时调整视频预览图层的方向
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    AVCaptureConnection *captureConnection = [_captureVideoPreviewLayer connection];
    captureConnection.videoOrientation = (AVCaptureVideoOrientation)toInterfaceOrientation;
}
//旋转后重新设置大小
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    _captureVideoPreviewLayer.frame = self.viewContainer.bounds;
}

/**
 隐藏状态栏
 */
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)dealloc {
}

#pragma mark - delegate
#pragma mark AVCapturePhotoCaptureDelegate
- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(nullable CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(nullable CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(nullable AVCaptureBracketedStillImageSettings *)bracketSettings error:(nullable NSError *)error {
    if (error) {
        [self alertWith:error.localizedDescription];
    } else {
        NSData *data = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
        [_images insertObject:[UIImage imageWithData:data] atIndex:0];
        self.finishBtn.hidden = NO;
        self.finishBtn.enabled = YES;
        self.collectionView.hidden = NO;
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
        
        if (_maximumNumber > 0 && _images.count >= _maximumNumber && _type == SECapturePhotoVideoTypePhotograph) {
            self.takeSender.backgroundColor = [UIColor grayColor];
            self.takeSender.userInteractionEnabled = NO;
        } else {
            self.takeSender.backgroundColor = [UIColor whiteColor];
            self.takeSender.userInteractionEnabled = YES;
        }
        self.messageLabel.text = @"轻触拍照";
    }
}

//- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingLivePhotoToMovieFileAtURL:(NSURL *)outputFileURL duration:(CMTime)duration photoDisplayTime:(CMTime)photoDisplayTime resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings error:(nullable NSError *)error {
//    
//}

#pragma mark AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    self.takeSender.backgroundColor = [UIColor greenColor];
    [self.progressView setProgress:0 animated:NO];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    [_timer invalidate];
    self.takeSender.backgroundColor = [UIColor whiteColor];
    self.messageLabel.text = @"长按录制";
    if (error) {
        NSLog(@"error = %@",error);
        [self alertWith:error.localizedDescription];
    } else {
        if (_cancelMovieFileOutput == NO) {
            _outputFileURL = outputFileURL;
            if (_finish) self.finish(_type, nil, _outputFileURL);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SECapturePhotoShowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SECapturePhotoShowCell class]) forIndexPath:indexPath];
    cell.imageView.image = _images[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark - event response

/**
 拍照
 */
- (void)tapTheResponseOfTakeSender:(UIGestureRecognizer *)gestureRecognizer {
    if (_type == SECapturePhotoVideoTypeVideo) return ;
    
    AVCapturePhotoSettings *settings = [AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey : AVVideoCodecJPEG}];
    if ([_captureDeviceInput device].position == AVCaptureDevicePositionFront) {
        settings.flashMode = AVCaptureFlashModeOff;
    } else {
        settings.flashMode = AVCaptureFlashModeAuto;
    }
    settings.autoStillImageStabilizationEnabled = YES;
    [_capturePhotoOutput capturePhotoWithSettings:settings delegate:self];
}

/**
 摄像
 */
- (void)longPressTheResponseOfTakeSender:(UIGestureRecognizer *)gestureRecognizer {
    if (_type == SECapturePhotoVideoTypePhotograph) return ;
    
    UIGestureRecognizerState state = gestureRecognizer.state;
    
    if (state == UIGestureRecognizerStateChanged) {
        CGPoint location = [gestureRecognizer locationInView:self.view];
        CGPoint center = self.takeSender.center;
        CGFloat radius = fabsf(sqrtf(powf(location.x - center.x, 2) + powf(location.y - center.y, 2)));
        if (radius > SETakeSender_widthAndHeight / 2.f) {
            _cancelMovieFileOutput = YES;
            self.takeSender.backgroundColor = [UIColor redColor];
            self.messageLabel.text = @"录制中，松开取消录制";
        } else {
            _cancelMovieFileOutput = NO;
            self.takeSender.backgroundColor = [UIColor greenColor];
            self.messageLabel.text = @"录制中，松开完成录制";
        }
    }
    
    if (state == UIGestureRecognizerStateBegan) {
        if ([_captureMovieFileOutput isRecording] == NO) {//如果未录制，则开始录制
            //根据设备输出获得连接
            AVCaptureConnection *captureConnection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
            //视频方向与预览图层保持方向一致
            captureConnection.videoOrientation = [_captureVideoPreviewLayer connection].videoOrientation;
            //获得临时缓存路径
            NSString *outputFilePath = [NSTemporaryDirectory() stringByAppendingString:@"seMovie.mov"];
            NSURL *fileURL = [NSURL fileURLWithPath:outputFilePath];
            //开始录制
            [_captureMovieFileOutput startRecordingToOutputFileURL:fileURL recordingDelegate:self];
            
            self.messageLabel.text = @"录制中，松开完成录制";
            self.switchCameraBtn.enabled = NO;
            self.enableRotation = NO;
        }
    } else if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled || state == UIGestureRecognizerStateFailed) {
        self.switchCameraBtn.enabled = YES;
        self.enableRotation = YES;
        if ([_captureMovieFileOutput isRecording]) {
            [_captureMovieFileOutput stopRecording];
        }
    }
}

/**
 完成按钮
 */
- (void)touchUpTheResponseOfFinishBtn:(UIButton *)sender {
    if (_finish) self.finish(_type, _images, nil);
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 取消按钮
 */
- (void)touchUpTheResponseOfCancelBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 切换前后摄像头
 */
- (void)touchUpTheResponseOfSwitchCameraBtn:(UIButton *)sender {
    //获得与当前设备方向相反的设备
    AVCaptureDevice *currentDevice = [self.captureDeviceInput device];
    AVCaptureDevicePosition currentPosition = [currentDevice position];
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition = AVCaptureDevicePositionFront;
    if (currentPosition == AVCaptureDevicePositionUnspecified || currentPosition == AVCaptureDevicePositionFront) {
        toChangePosition = AVCaptureDevicePositionBack;
    }
    toChangeDevice = [self getCaptureDeviceWithPosition:toChangePosition mediaType:AVMediaTypeVideo];
    
    //改变会话的配置前一定要先开启配置，配置完成后提交配置改变
    [self.captureSession beginConfiguration];
    //移除原有输入对象
    [self.captureSession removeInput:_captureDeviceInput];
    //获得要调整的设备输入对象
    NSError *error = nil;
    _captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:toChangeDevice error:&error];
    if (error) {
        NSLog(@"error = %@",error);
        [self alertWith:error.localizedDescription];
        return ;
    }
    //添加新的输入对象
    if ([self.captureSession canAddInput:_captureDeviceInput]) {
        [self.captureSession addInput:_captureDeviceInput];
    }
    //提交会话配置
    [self.captureSession commitConfiguration];
}

/**
 聚焦
 */
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = touches.anyObject;
    if ([touch.view isEqual:self.viewContainer] && self.takeSender.userInteractionEnabled == YES) {
        [UIView animateWithDuration:0.4 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
            self.viewFocus.center = [touch locationInView:self.viewContainer];
        } completion:^(BOOL finished) {
            //将UI坐标转化为摄像头坐标
            CGPoint cameraPoint= [self.captureVideoPreviewLayer captureDevicePointOfInterestForPoint:[touch locationInView:self.viewContainer]];
            [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
        }];
    }
}

- (void)timerAction:(NSTimer *)timer {
    [self.progressView setProgress:(self.progressView.progress + 0.1) animated:YES];
    if (self.progressView.progress >= 1) {
        [self.captureMovieFileOutput stopRecording];
        [timer invalidate];
    }
}

#pragma mark - private methods
- (AVCaptureDevice *)getCaptureDeviceWithPosition:(AVCaptureDevicePosition)position mediaType:(NSString *)mediaType {
//    = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:mediaType position:position];
    return captureDevice;
}

/**
 *  设置聚焦点
 *
 *  @param point 聚焦点
 */
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point {
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        }
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
    }];
}

/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 */
-(void)changeDeviceProperty:(PropertyChangeBlock)propertyChange {
    AVCaptureDevice *captureDevice= [self.captureDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    } else {
        [self alertWith:error.localizedDescription];
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

- (void)alertWith:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

+ (BOOL)se_writeVideoToPhotoAlbum:(NSURL *)fileURL {
    PHPhotoLibrary *photoLibrary = [PHPhotoLibrary sharedPhotoLibrary];
    NSError *error = nil;
    [photoLibrary performChangesAndWait:^{
        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:fileURL];
    } error:&error];
    if (error) {
        NSLog(@"error = %@",error);
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - getters and setters

- (void)setType:(SECapturePhotoVideoType)type {
    _type = type;
    
    if (type == SECapturePhotoVideoTypePhotograph) {
        if ([self.captureSession canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
            self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
        }
        self.progressView.hidden = YES;
        self.finishBtn.hidden = YES;
        self.collectionView.hidden = NO;
        self.messageLabel.text = @"轻触拍照";
    } else if (type == SECapturePhotoVideoTypeVideo) {
        if ([self.captureSession canSetSessionPreset:AVCaptureSessionPresetMedium]) {
            self.captureSession.sessionPreset = AVCaptureSessionPresetMedium;
        }
        self.progressView.hidden = NO;
        self.finishBtn.hidden = YES;
        self.collectionView.hidden = YES;
        self.messageLabel.text = @"长按录制";
    }
}

- (UIView *)viewContainer {
    if (_viewContainer == nil) {
        _viewContainer = [[UIView alloc] init];
    }
    return _viewContainer;
}

- (UIImageView *)viewFocus {
    if (_viewFocus == nil) {
        _viewFocus = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _viewFocus.center = self.view.center;
        _viewFocus.backgroundColor = [UIColor lightGrayColor];
        _viewFocus.image = [UIImage imageNamed:@""];
        _viewFocus.alpha = 0.5;
    }
    return _viewFocus;
}

- (UIView *)takeSender {
    if (_takeSender == nil) {
        _takeSender = [[UIView alloc] init];
        _takeSender.backgroundColor = [UIColor whiteColor];
        _takeSender.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _takeSender.layer.borderWidth = 8;
        _takeSender.layer.masksToBounds = YES;
        _takeSender.layer.cornerRadius = SETakeSender_widthAndHeight / 2.f;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTheResponseOfTakeSender:)];
        [_takeSender addGestureRecognizer:tap];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressTheResponseOfTakeSender:)];
        [_takeSender addGestureRecognizer:longPress];
    }
    return _takeSender;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        CGFloat height = 44;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(height / SEScreen_Height * SEScreen_Width, height);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 8;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(8, SEScreen_Height - height - 8, SEScreen_Width - 24 - 44 / 0.618, height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.hidden = YES;
        [_collectionView registerClass:[SECapturePhotoShowCell class] forCellWithReuseIdentifier:NSStringFromClass([SECapturePhotoShowCell class])];
    }
    return _collectionView;
}

- (UIButton *)finishBtn {
    if (_finishBtn == nil) {
        _finishBtn = [[UIButton alloc] init];
        _finishBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _finishBtn.layer.cornerRadius = 4;
        _finishBtn.layer.masksToBounds = YES;
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_finishBtn addTarget:self action:@selector(touchUpTheResponseOfFinishBtn:) forControlEvents:UIControlEventTouchUpInside];
        _finishBtn.enabled = NO;
    }
    return _finishBtn;
}

- (UIButton *)cancelBtn {
    if (_cancelBtn == nil) {
        _cancelBtn = [[UIButton alloc] init];
        _cancelBtn.backgroundColor = [UIColor clearColor];
        [_cancelBtn setTitle:@"∨" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(touchUpTheResponseOfCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)switchCameraBtn {
    if (_switchCameraBtn == nil) {
        _switchCameraBtn = [[UIButton alloc] init];
        _switchCameraBtn.backgroundColor = [UIColor clearColor];
        [_switchCameraBtn setTitle:@"🔄" forState:UIControlStateNormal];
        [_switchCameraBtn addTarget:self action:@selector(touchUpTheResponseOfSwitchCameraBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchCameraBtn;
}

- (UIProgressView *)progressView {
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.hidden = YES;
    }
    return _progressView;
}

- (UILabel *)messageLabel {
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:12];
    }
    return _messageLabel;
}

#pragma mark - memory manage
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
