//
//  SEPraiseListViewController.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/23.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SEPraiseListViewController.h"
#import "SEPersonalCenterViewController.h"
#import "SEConfig.h"
#import "SEUserModel.h"

@interface SEPraiseListViewController () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@end

@implementation SEPraiseListViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SEBackgroundColor_Main;
    // add subview
    [self.view addSubview:self.textView];
    
    [self layoutUI];
}
- (void)layoutUI {
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(seSpacing / 2);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(seSpacing);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-seSpacing / 2);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-seSpacing);
    }];
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
#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    NSLog(@"laudatorId = %@, laudatorName = %@",URL.scheme, [[textView.attributedText string] substringWithRange:characterRange]);
    SEUserModel *user = [[SEUserModel alloc] init];
    user.userName = [[textView.attributedText string] substringWithRange:characterRange];
    user.userId = URL.scheme;
    [self privateMethodsForViewPersonalCenter:user];
    return NO;
}
#pragma mark - event response

#pragma mark - private methods
/**
 根据点赞列表获取富文本
 
 @param praises 点赞列表
 @return 富文本
 */
+ (NSMutableAttributedString *)se_praiseListStringWith:(NSArray *)praises {
    
    //拼接字符串
    NSMutableString *string = [NSMutableString string];
    for (NSInteger index = 0; index < praises.count; index ++) {
        SEPraiseModel *model = praises[index];
        if (index == praises.count - 1) {
            [string appendString:model.laudatorName];
        } else {
            [string appendFormat:@"%@、",model.laudatorName];
        }
    }
    
    //富文本
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    //插入链接
    NSInteger location = 0;
    for (NSInteger index = 0; index < praises.count; index ++) {
        SEPraiseModel *model = praises[index];
        [attributedString addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%@://",model.laudatorId] range:NSMakeRange(location, model.laudatorName.length)];
        location += model.laudatorName.length + 1;
    }
    [attributedString addAttribute:NSFontAttributeName value:SETextFont_Title range:NSMakeRange(0, [attributedString string].length)];
    return attributedString;
}

/**
 查看个人主页
 */
- (void)privateMethodsForViewPersonalCenter:(SEUserModel *)user {
    SEPersonalCenterViewController *personalCenterVC = [[SEPersonalCenterViewController alloc] init];
    personalCenterVC.user = user;
    [self.navigationController pushViewController:personalCenterVC animated:YES];
}
#pragma mark - getters and setters
- (void)setPraises:(NSArray *)praises {
    _praises = praises;
    self.title = [NSString stringWithFormat:@"%ld人觉得很赞",praises.count];
    self.textView.attributedText = [SEPraiseListViewController se_praiseListStringWith:praises];
}

- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.showsVerticalScrollIndicator = YES;
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.delegate = self;
        _textView.editable = NO;
        _textView.scrollEnabled = NO;
        _textView.backgroundColor = SEBackgroundColor_clear;
        _textView.linkTextAttributes = @{
                                         NSForegroundColorAttributeName : SETextColor_Response,
                                         NSFontAttributeName : SETextFont_Title,
                                         };
    }
    return _textView;
}
#pragma mark - memory manage
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
