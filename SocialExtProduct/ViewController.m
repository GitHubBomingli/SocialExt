//
//  ViewController.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/5.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "ViewController.h"
#import "SocialExtViewController.h"
#import "SEDBTableBody.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
 
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchUpTheResponseOfSocialExtBtn:(UIButton *)sender {
    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SEBody0" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) NSLog(@"error = %@",error);
    SEBodyModel *model = [SEBodyModel mj_objectWithKeyValues:dic];
    
    SocialExtViewController *vc = [[SocialExtViewController alloc] init];
    vc.headerBackgroundImageName = @"sebackground";
    vc.userModel = model.user;
    vc.userHeadPlaceholderImageName = @"sebackground";
    vc.colorWithAlphaComponent = 0.2;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)insertData:(UIButton *)sender {
    [self simulateData];
}
- (IBAction)viewData:(UIButton *)sender {
    
    SEDBTableBody *db = [[SEDBTableBody alloc] init];
    NSMutableArray *resourcesMA = [db allData];
    for (SEBodyModel *body in resourcesMA) {
        NSLog(@"%@",body.content);
    }
}
- (IBAction)deleteData:(UIButton *)sender {
    SEDBTableBody *db = [[SEDBTableBody alloc] init];
    [db deleteAllData];
}
- (IBAction)updateAction:(UIButton *)sender {
//    NSError *error = nil;
//    NSString *resource = @"SEBody0";
//    NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:@"json"];
//    NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
//    if (error) NSLog(@"error = %@",error);
//    SEBodyModel *model = [SEBodyModel mj_objectWithKeyValues:dic];
//    model.content = @"update";
//    model.user.userName = @"火狐";
//    [model.comments removeLastObject];
//    SEDBTableBody *db = [[SEDBTableBody alloc] init];
//    [db updateData:model];
    
    [self updataData];
}

- (void)updataData {
    NSMutableArray *resourcesMA = [NSMutableArray array];
    SEDBTableBody *db = [[SEDBTableBody alloc] init];
    for (NSInteger index = 0; index < 4; index ++) {
        NSError *error = nil;
        NSString *resource = [NSString stringWithFormat:@"SEBody%ld",index];
        NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (error) NSLog(@"error = %@",error);
        SEBodyModel *model = [SEBodyModel mj_objectWithKeyValues:dic];
        model.content = [NSString stringWithFormat:@"更新%ld",index];
        [resourcesMA addObject:model];
    }
    [db updateDatas:resourcesMA];
}

- (void)simulateData {
    NSMutableArray *resourcesMA = [NSMutableArray array];
    SEDBTableBody *db = [[SEDBTableBody alloc] init];
    for (NSInteger index = 0; index < 4; index ++) {
        NSError *error = nil;
        NSString *resource = [NSString stringWithFormat:@"SEBody%ld",index];
        NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (error) NSLog(@"error = %@",error);
        SEBodyModel *model = [SEBodyModel mj_objectWithKeyValues:dic];
        
        [resourcesMA addObject:model];
        
        [db insertData:model];
    }
}

@end
