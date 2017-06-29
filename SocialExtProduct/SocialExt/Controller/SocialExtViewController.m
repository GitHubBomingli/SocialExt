//
//  SocialExtViewController.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/8.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SocialExtViewController.h"
#import "SECommentTableViewCell.h"
#import "SETableHeaderView.h"
#import "SEBodyModel.h"
#import "SEConfig.h"
#import "SEImageViewManager.h"
#import "SEInputBar.h"

#import "SEPublishViewController.h"
#import "SEWebViewController.h"
#import "SEPersonalCenterViewController.h"
#import "SEPraiseListViewController.h"

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

#import "SEDBTableBody.h"

#define SEFooterViewWithIdentifier @"SEFooterViewWithIdentifier"

@interface SocialExtViewController () <UITableViewDelegate, UITableViewDataSource, SECommentDelegate, SETableHeaderViewDelegate, SEBodyViewDelegate, SEInputBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SETableHeaderView *tableHeaderView;//头视图
@property (nonatomic, strong) UIView *tableFooterView;//脚视图
@property (nonatomic, strong) UIImageView *headerImageView;//背景头视图
/**
 模糊视图，添加手势
 */
@property (nonatomic, strong) UIView *blurView;

@property (nonatomic, strong) NSMutableArray *resourcesMA;

@property (nonatomic, strong) NSMutableArray *foldMA;

@property (nonatomic, strong) SEInputBar *inputBar;

@end

@implementation SocialExtViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // add subview
    self.view.backgroundColor = SEBackgroundColor_Main;
    self.title = @"朋友圈";
    
    [self.view addSubview:self.headerImageView];
    [self.headerImageView addSubview:self.blurView];
    [self.view insertSubview:self.tableView aboveSubview:self.headerImageView];
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableFooterView = self.tableFooterView;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(theResponseOfPublish:)];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right);
    }];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(self.headerImageView.mas_width);
    }];
    
    self.blurView.frame = CGRectMake(0, 0, SEScreen_Width, SEScreen_Width);
    
    self.tableHeaderView.frame = CGRectMake(0, 0, SEScreen_Width, SEScreen_Width-30);
    
    [self simulateData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //layout
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[SESectionHeightManager manager] removeAllHeight];
    [[SEImageViewManager manager] removeAllObjects];
    
    if (_inputBar) [_inputBar removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //notification
}

- (void)dealloc {
}

#pragma mark - delegate
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.resourcesMA.count > 0) {
        self.tableFooterView.frame = CGRectMake(0, 0, SEScreen_Width, 0);
    } else {
        self.tableFooterView.frame = CGRectMake(0, 0, SEScreen_Width, SEScreen_Height * 0.4);
    }
    return self.resourcesMA.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SEBodyModel *bodyModel = self.resourcesMA[section];
    return bodyModel.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SECommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SECommentTableViewCell class]) forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[SECommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SECommentTableViewCell class])];
    }
    cell.indexPath = indexPath;
    
    SEBodyModel *bodyModel = self.resourcesMA[indexPath.section];
    SECommentModel *commentModel = bodyModel.comments[indexPath.row];
    cell.model = commentModel;
    cell.delegate = self;
    return cell;
}

#pragma mark UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SEBodyView *bodyView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([SEBodyView class])];
    if (bodyView == nil) {
        bodyView = [[SEBodyView alloc] initWithReuseIdentifier:NSStringFromClass([SEBodyView class])];
    }
    bodyView.delegate = self;
    bodyView.fold = [self.foldMA[section] boolValue];
    bodyView.section = section;
    bodyView.userModel = _userModel;
    bodyView.userHeadPlaceholderImageName = _userHeadPlaceholderImageName;
    bodyView.scrollView = tableView;
    
    SEBodyModel *bodyModel = self.resourcesMA[section];
    bodyView.model = bodyModel;
    return bodyView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SEFooterViewWithIdentifier];
    if (footerView == nil) {
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:SEFooterViewWithIdentifier];
    }
    footerView.contentView.backgroundColor = SEBackgroundColor_Main;
    return footerView;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    SEBodyModel *bodyModel = self.resourcesMA[indexPath.section];
//    SECommentModel *commentModel = bodyModel.comments[indexPath.row];
//    CGFloat height = [SECommentTableViewCell se_calculateCellHeightWith:commentModel];
//    return height;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    SEBodyModel *bodyModel = self.resourcesMA[section];
    BOOL fold = [self.foldMA[section] boolValue];
    return [SEBodyView se_calculateViewHeightWith:bodyModel fold:fold section:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return seSpacing;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetY = scrollView.contentInset.top + scrollView.contentOffset.y;
    CGRect frame = self.headerImageView.frame;
    frame.size.height = SEScreen_Width - contentOffsetY;
    if (frame.size.height < 64) {
        frame.size.height = 64;
    }
    self.headerImageView.frame = frame;
    self.blurView.frame = self.headerImageView.bounds;
    
    if (_inputBar) {
        [_inputBar removeFromSuperview];
    }
}

#pragma mark SECommentDelegate
- (void)commentCell:(SECommentTableViewCell *)cell touchUpTheResponseOfComment:(SECommentModel *)commentModel {
    //追问
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.inputBar.type = SEInputBarTypeToComment;
    self.inputBar.indexPath = cell.indexPath;
    [window addSubview:self.inputBar];
}

- (void)commentCell:(SECommentTableViewCell *)cell touchUpTheResponseOfCommenter:(SECommentModel *)commentModel {
    //进入评论者的主页
    [self privateMethodsForViewPersonalCenter:commentModel.commenter];
}

- (void)commentCell:(SECommentTableViewCell *)cell touchUpTheResponseOfToCommenter:(SECommentModel *)commentModel {
    //进入被追问者的主页
    [self privateMethodsForViewPersonalCenter:commentModel.toCommenter];
}

#pragma mark SETableHeaderViewDelegate
- (void)tableHeaderView:(SETableHeaderView *)headerView touchUpTheResponseOfChangeHead:(SEUserModel *)userModel {
    //访问相册或相机
}

- (void)tableHeaderView:(SETableHeaderView *)headerView touchUpTheResponseOfViewHead:(SEUserModel *)userModel {
    //进入个人主页
    [self privateMethodsForViewPersonalCenter:userModel];
}

- (void)tableHeaderView:(SETableHeaderView *)headerView touchUpTheResponseOfViewUnread:(SEUserModel *)userModel {
    //查看未读消息
}

#pragma mark SEBodyViewDelegate
- (void)bodyView:(SEBodyView *)bodyView touchUpTheResponseOfHead:(SEUserModel *)userModel {
    //进入个人主页
    [self privateMethodsForViewPersonalCenter:userModel];
}

- (void)bodyView:(SEBodyView *)bodyView touchUpTheResponseOfFold:(BOOL)fold section:(NSInteger)section {
    //刷新header的高度
    [self.foldMA replaceObjectAtIndex:section withObject:@(fold)];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)bodyView:(SEBodyView *)bodyView touchUpTheResponseOfAddress:(NSString *)address {
    //进入地址链接
    [self privateMethodsForViewWeb:address type:SEWebViewControllerTypeAddress];
}

- (void)bodyView:(SEBodyView *)bodyView touchUpTheResponseOfIntoShare:(SEShareModel *)shareModel {
    //进入分享链接
    [self privateMethodsForViewWeb:shareModel.shareUrl type:SEWebViewControllerTypeShare];
}

- (void)bodyView:(SEBodyView *)bodyView touchUpTheResponseOfPlayVideo:(NSString *)vidoeUrl {
    //播放视频
    AVPlayerViewController *playerController = [[AVPlayerViewController alloc] init];
    AVPlayer *player = [AVPlayer playerWithURL:[NSURL URLWithString:vidoeUrl]];
    playerController.player = player;
    [self presentViewController:playerController animated:YES completion:^{
    }];
}

- (void)bodyView:(SEBodyView *)bodyView touchUpTheResponseOfDeleteForSection:(NSInteger)section bodyId:(NSString *)bodyId {
    //删除指定动态
    [self.resourcesMA removeObjectAtIndex:section];
    [[SESectionHeightManager manager] removeAllHeight];
    [[[SEDBTableBody alloc] init] deleteDataWithBodyId:bodyId];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationTop];
}

- (void)bodyView:(SEBodyView *)bodyView touchUpTheResponseOfPraise:(BOOL)praiseOrcancel {
    //点赞或取消
}

- (void)bodyView:(SEBodyView *)bodyView touchUpTheResponseOfComment:(SEBodyModel *)bodyModel {
    //对动态评论
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.inputBar.type = SEInputBarTypeToBody;
    self.inputBar.indexPath = [NSIndexPath indexPathForRow:0 inSection:bodyView.section];
    [window addSubview:self.inputBar];
}

- (void)bodyView:(SEBodyView *)bodyView touchUpTheResponseOfLaudator:(SEUserModel *)laudatorModel {
    //进入个人主页
    [self privateMethodsForViewPersonalCenter:laudatorModel];
}

- (void)bodyView:(SEBodyView *)bodyView touchUpTheResponseOfNumber:(NSArray *)praises {
    //进入点赞列表界面
    [self privateMethodsForViewPraiseList:praises];
}

#pragma mark SEInputBarDelegate
- (void)inputBar:(SEInputBar *)inputBar touchUpTheResponseOfSendReturnWithText:(NSString *)text type:(SEInputBarType)type indexPath:(NSIndexPath *)indexPath {
    //模拟数据；应该在接口调用成功后，将返回的数据插入到数据库
    SEBodyModel *body = self.resourcesMA[indexPath.section];
    SECommentModel *model = [[SECommentModel alloc] init];
    model.commentId = [NSString stringWithFormat:@"%@%d", body.bodyId, rand() % 1000];
    model.comment = text;
    model.commenter = _userModel;
    model.type = (KSECommentType)type;
    if (type == KSECommentTypeToUser) {
        SECommentModel *commentModel = body.comments[indexPath.row];
        model.toCommenter = commentModel.commenter;
    }
    //更新数据库，并刷新页面
    SEDBTableComment *tableComment = [[SEDBTableComment alloc] init];
    NSLog(@"insert : %d", [tableComment insertData:model withbodyId:body.bodyId]);
    SEDBTableBody *tableBody = [[SEDBTableBody alloc] init];
    body = [tableBody bodyWith:body.bodyId];
    [self.resourcesMA replaceObjectAtIndex:indexPath.section withObject:body];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - event response
- (void)theResponseOfPublish:(UIBarButtonItem *)item {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"文字" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self privateMethodsForPublish:SEPublishResourceTypeText];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self privateMethodsForPublish:SEPublishResourceTypePhotograph];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self privateMethodsForPublish:SEPublishResourceTypePhotoAlbum];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self privateMethodsForPublish:SEPublishResourceTypeVideo];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alertController animated:YES completion:^{
    }];
}

#pragma mark - private methods
- (void)simulateData {
    
    SEDBTableBody *tableBody = [[SEDBTableBody alloc] init];
    [self.resourcesMA addObjectsFromArray:[tableBody allData]];
    for (NSInteger index = 0; index < self.resourcesMA.count; index ++) {
        [self.foldMA addObject:@(YES)];
    }
    [self.tableView reloadData];
    
//    self.tableHeaderView.unreadNumber = 2;
//    
//    for (NSInteger index = 0; index < 4; index ++) {
//        NSError *error = nil;
//        NSString *resource = [NSString stringWithFormat:@"SEBody%ld",index];
//        NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:@"json"];
//        NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
//        if (error) NSLog(@"error = %@",error);
//        SEBodyModel *model = [SEBodyModel mj_objectWithKeyValues:dic];
//        
//        [self.resourcesMA addObject:model];
//    }
//    
//    for (NSInteger index = 0; index < self.resourcesMA.count; index ++) {
//        [self.foldMA addObject:@(YES)];
//    }
//    [self.tableView reloadData];
}

/**
 查看个人主页
 */
- (void)privateMethodsForViewPersonalCenter:(SEUserModel *)user {
    SEPersonalCenterViewController *personalCenterVC = [[SEPersonalCenterViewController alloc] init];
    personalCenterVC.user = user;
    [self.navigationController pushViewController:personalCenterVC animated:YES];
}

/**
 查看网页
 */
- (void)privateMethodsForViewWeb:(NSString *)url type:(SEWebViewControllerType)type {
    SEWebViewController *webVC = [[SEWebViewController alloc] init];
    webVC.type = type;
    webVC.url = url;
    [self.navigationController pushViewController:webVC animated:YES];
}

/**
 查看点赞者列表
 */
- (void)privateMethodsForViewPraiseList:(NSArray *)praises {
    SEPraiseListViewController *praiseVC = [[SEPraiseListViewController alloc] init];
    praiseVC.praises = praises;
    [self.navigationController pushViewController:praiseVC animated:YES];
}

/**
 发布动态
 */
- (void)privateMethodsForPublish:(SEPublishResourceType)type {
    SEPublishViewController *publishVC = [[SEPublishViewController alloc] init];
    publishVC.resourceType = type;
    publishVC.userModel = _userModel;
    publishVC.publishFinishCallback = ^(SEBodyModel *model) {
        [self.resourcesMA insertObject:model atIndex:0];
        [self.foldMA insertObject:@1 atIndex:0];
        [self.tableView reloadData];
    };
    if (type == SEPublishResourceTypeText) {
        [self.navigationController pushViewController:publishVC animated:YES];
    } else {
        [self.navigationController pushViewController:publishVC animated:NO];
    }
}

#pragma mark - getters and setters
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 20;
        [_tableView registerClass:[SECommentTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SECommentTableViewCell class])];
        [_tableView registerClass:[SEBodyView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([SEBodyView class])];
        [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:SEFooterViewWithIdentifier];
    }
    return _tableView;
}

- (SETableHeaderView *)tableHeaderView {
    if (_tableHeaderView == nil) {
        _tableHeaderView = [[SETableHeaderView alloc] init];
        _tableHeaderView.delegate = self;
        _tableHeaderView.userHeadPlaceholderImageName = _userHeadPlaceholderImageName;
        _tableHeaderView.userModel = _userModel;
    }
    return _tableHeaderView;
}

- (UIView *)blurView {
    if (_blurView == nil) {
        _blurView = [[UIView alloc] init];
        _blurView.backgroundColor = [UIColor clearColor];
        _blurView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:_colorWithAlphaComponent];
    }
    return _blurView;
}

- (UIView *)tableFooterView {
    if (_tableFooterView == nil) {
        _tableFooterView = [[UIView alloc] init];
        _tableFooterView.backgroundColor = SEBackgroundColor_Main;
    }
    return _tableFooterView;
}

- (UIImageView *)headerImageView {
    if (_headerImageView == nil) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.image = [UIImage imageNamed:_headerBackgroundImageName];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headerImageView;
}

- (NSMutableArray *)resourcesMA {
    if (_resourcesMA == nil) {
        _resourcesMA = [NSMutableArray array];
    }
    return _resourcesMA;
}

- (NSMutableArray *)foldMA {
    if (_foldMA == nil) {
        _foldMA = [NSMutableArray array];
    }
    return _foldMA;
}

- (SEInputBar *)inputBar {
    if (_inputBar == nil) {
        _inputBar = [[SEInputBar alloc] init];
        _inputBar.delegate = self;
    }
    return _inputBar;
}

- (void)setUserModel:(SEUserModel *)userModel {
    _userModel = userModel;
    NSAssert(userModel.userId != nil, @"用户ID不能为空");
}

#pragma mark - memory manage
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
