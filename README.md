# SocialExt
Circle of Friends

## 使用前请阅读
1、接口参考SEBody0.json,详情见《朋友圈接口文档》
2、请仔细阅读SEConfig.h里的温馨提示
3、引用头文件：#import "SocialExtViewController.h"

## 调用示例
```
    SocialExtViewController *vc = [[SocialExtViewController alloc] init];
    vc.headerBackgroundImageName = @"sebackground";
    vc.userModel = model.user;
    vc.userHeadPlaceholderImageName = @"sebackground";
    vc.colorWithAlphaComponent = 0.2;
    [self.navigationController pushViewController:vc animated:YES];
 ```
 
 headerBackgroundImageName默认头视图背景图片名；userModel当前用户；userHeadPlaceholderImageName默认头像
  
