# SocialExt
Circle of Friends

## 使用前请阅读
1、接口参考SEBody0.json,详情见《朋友圈接口文档》<br>
2、请仔细阅读SEConfig.h里的温馨提示<br>
3、引用头文件：#import "SocialExtViewController.h"<br>

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
  
## 本地数据库
文件SEDBTableBody：<br>
```
/**
 插入一条动态：不会主动更新已存在的数据
 
 @param body 数据
 */
- (BOOL)insertData:(SEBodyModel *)body;

/**
 插入一组动态：不会主动更新已存在的数据

 @param bodys 数组元素必须是SEBodyModel的实例
 @return 是否成功
 */
- (BOOL)insertDatas:(NSArray <SEBodyModel *>*)bodys;

/**
 更新数据：如果不存在，则会插入一条新数据；如果已存在，则更新原来的数据。推荐使用

 @param body 数据
 @return 是否成功
 */
- (BOOL)updateData:(SEBodyModel *)body;

/**
 更新一组动态：如果不存在，则会插入新数据；如果已存在，则更新原来的数据。推荐使用
 
 @param bodys 数组元素必须是SEBodyModel的实例
 @return 是否成功
 */
- (BOOL)updateDatas:(NSArray <SEBodyModel *>*)bodys;

/**
 删除指定动态
 
 @param bodyId 动态ID
 */
- (BOOL)deleteDataWithBodyId:(NSString *)bodyId;

/**
 删除全部数据
 */
- (BOOL)deleteAllData;

/**
 根据ID获取一条数据

 @param bodyId ID
 @return 数据
 */
- (SEBodyModel *)bodyWith:(NSString *)bodyId;

/**
 查询全部数据
 
 @return 数据
 */
- (NSMutableArray <SEBodyModel *>*)allData;
```

开发者可以利用“SEDBTable”开头的类进行缓存操作
