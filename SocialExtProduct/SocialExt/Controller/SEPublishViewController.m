//
//  SEPublishTextImageViewController.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/23.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SEPublishViewController.h"
#import "SEConfig.h"
#import "SECapturePhotoVideo.h"
#import "SEPhotosViewController.h"
#import "SEPublishTextCell.h"
#import "SEPublishImagesCell.h"
#import "SEPublishVideoCell.h"
#import "SEPublishDefaultCell.h"

#import "SEDBTableBody.h"

@interface SEPublishViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, strong) NSURL *outputFileURL;

@end

@implementation SEPublishViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SEBackgroundColor_Main;
    self.title = @"发布";
    // add subview

    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishAction)];
    
    //弹出拍照、相册或视频拍摄界面
    if (_resourceType == SEPublishResourceTypePhotograph) {
        [SECapturePhotoVideo captureWithType:SECapturePhotoVideoTypePhotograph maximumNumber:SEImage_Max_NumberOfImages finish:^(SECapturePhotoVideoType type, NSArray *images, NSURL *outputFileURL) {
            [self.images addObjectsFromArray:images];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        } target:self];
    } else if (_resourceType == SEPublishResourceTypePhotoAlbum) {
        [SEPhotosViewController photosWithMaximumNumber:SEImage_Max_NumberOfImages completion:^(NSArray *images) {
            [self.images addObjectsFromArray:images];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        } target:self];
    } else if (_resourceType == SEPublishResourceTypeVideo) {
        [SECapturePhotoVideo captureWithType:SECapturePhotoVideoTypeVideo maximumNumber:0 finish:^(SECapturePhotoVideoType type, NSArray *images, NSURL *outputFileURL) {
            _outputFileURL = outputFileURL;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        } target:self];
    }
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        SEPublishTextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SEPublishTextCell class])];
        if (cell == nil) {
            cell = [[SEPublishTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SEPublishTextCell class])];
        }
        return cell;
    } else if (indexPath.row == 1) {
        if (_resourceType == SEPublishResourceTypeVideo) {
            SEPublishVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SEPublishVideoCell class])];
            if (cell == nil) {
                cell = [[SEPublishVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SEPublishVideoCell class])];
            }
            cell.videoUrl = _outputFileURL;
            //点击视频
            cell.touchUpVideoCallback = ^(NSURL *URL) {
                [self alertForTouchUpTheResponseOfVideo];
            };
            return cell;
        } else {
            SEPublishImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SEPublishImagesCell class])];
            if (cell == nil) {
                cell = [[SEPublishImagesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SEPublishImagesCell class])];
            }
            //添加图片
            cell.addCallback = ^ {
                [self alertForAddImageWay];
            };
            //删除图片
            cell.deleteCallback = ^(NSInteger index) {
                [self alertForDeleteImage:index];
            };
            cell.images = self.images;
            return cell;
        }
    } else {
        SEPublishDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SEPublishDefaultCell class])];
        if (cell == nil) {
            cell = [[SEPublishDefaultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SEPublishDefaultCell class])];
        }
        [self setDefaultValueWith:indexPath completion:^(NSString *icon, NSString *title) {
            cell.iconImageView.image = [UIImage imageNamed:icon];
            cell.titleLabel.text = title;
        }];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - event response
- (void)finishAction {
    
    //模拟数据(此处不支持图片模拟)；应该在接口调用成功后，将返回的数据插入到数据库
    SEPublishTextCell *textCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    SEBodyModel *model = [[SEBodyModel alloc] init];
    model.bodyId = [NSString stringWithFormat:@"%d",rand()%1000];
    model.user = _userModel;
    model.content = textCell.textView.text;
    if (_resourceType == SEPublishResourceTypePhotoAlbum || _resourceType == SEPublishResourceTypePhotograph) {
        model.type = KSEBodyTypeImageText;
        NSMutableArray *images = [NSMutableArray array];
        for (UIImage *image in self.images) {
            SEImageModel *imageModel = [[SEImageModel alloc] init];
            [images addObject:imageModel];
        }
        model.images = images;
    } else if (_resourceType == SEPublishResourceTypeVideo) {
        model.video = [NSString stringWithFormat:@"%@",self.outputFileURL];
        model.type = KSEBodyTypeVideoText;
    } else {
        model.type = KSEBodyTypePlainText;
    }
    model.date = [NSString se_stringFromDate:[NSDate date]];
    
    SEDBTableBody *tableBody = [[SEDBTableBody alloc] init];
    [tableBody insertData:model];
    
    
    if (_publishFinishCallback) self.publishFinishCallback(model);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private methods

/**
 添加照片
 */
- (void)alertForAddImageWay {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SECapturePhotoVideo captureWithType:SECapturePhotoVideoTypePhotograph maximumNumber:(SEImage_Max_NumberOfImages - self.images.count) finish:^(SECapturePhotoVideoType type, NSArray *images, NSURL *outputFileURL) {
            [self.images addObjectsFromArray:images];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        } target:self];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SEPhotosViewController photosWithMaximumNumber:(SEImage_Max_NumberOfImages - self.images.count) completion:^(NSArray *images) {
            [self.images addObjectsFromArray:images];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        } target:self];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 删除照片
 */
- (void)alertForDeleteImage:(NSInteger)index {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否确认删除" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.images removeObjectAtIndex:index];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [alertController addAction:deleteAction];
    //修改action颜色
    [deleteAction setValue:[UIColor redColor] forKey:@"titleTextColor"];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 重新录制或保存视频
 */
- (void)alertForTouchUpTheResponseOfVideo {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"重新录制" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SECapturePhotoVideo captureWithType:SECapturePhotoVideoTypeVideo maximumNumber:0 finish:^(SECapturePhotoVideoType type, NSArray *images, NSURL *outputFileURL) {
            _outputFileURL = outputFileURL;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        } target:self];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SECapturePhotoVideo se_writeVideoToPhotoAlbum:_outputFileURL];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)setDefaultValueWith:(NSIndexPath *)indexPath completion:(void(^)(NSString *icon, NSString *title))completion {
    //可以根据indexPath返回不同的值
    if (indexPath.row == 2) {
        completion(@"se_icon_location",@"所在位置");
    }
}

#pragma mark - getters and setters

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = SERGB(0xEEEEEE);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 60;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (NSMutableArray *)images {
    if (_images == nil) {
        _images = [NSMutableArray array];
    }
    if (_images.count > 0) {
        _resourceType = SEPublishResourceTypePhotoAlbum;
    }
    return _images;
}

#pragma mark - memory manage
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
