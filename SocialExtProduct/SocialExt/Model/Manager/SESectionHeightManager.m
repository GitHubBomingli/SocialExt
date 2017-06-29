//
//  SESectionHeightManager.m
//  SocialExtProduct
//
//  Created by 伯明利 on 2017/5/12.
//  Copyright © 2017年 伯明利. All rights reserved.
//

#import "SESectionHeightManager.h"

@implementation SEHeightSectionModel

@end

@interface SESectionHeightManager ()

@property (nonatomic, strong) NSMutableSet *set;

@end

@implementation SESectionHeightManager

#pragma mark - life cycle
+ (instancetype)manager {
    static SESectionHeightManager *seSectionHeightManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        seSectionHeightManager = [[SESectionHeightManager alloc] init];
    });
    return seSectionHeightManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - private methods
- (void)insertHeight:(CGFloat)height forSection:(NSInteger)section {
    [self removeHeightForSection:section];
    SEHeightSectionModel *model = [[SEHeightSectionModel alloc] init];
    model.section = section;
    model.height = height;
    [self.set addObject:model];
}

- (void)updateHeight:(CGFloat)height forSection:(NSInteger)section {
    for (SEHeightSectionModel *model in self.set) {
        if (model.section == section) {
            model.height = height;
            break;
        }
    }
}

- (CGFloat)heightForSection:(NSInteger)section {
    for (SEHeightSectionModel *model in self.set) {
        if (model.section == section) {
            return model.height;
        }
    }
    return 0;
}

- (void)removeHeightForSection:(NSInteger)section {
    for (SEHeightSectionModel *model in self.set) {
        if (model.section == section) {
            [self.set removeObject:model];
            break;
        }
    }
}

- (void)removeAllHeight {
    [self.set removeAllObjects];
}

#pragma mark - getter and setter
- (NSMutableSet *)set {
    if (_set == nil) {
        _set = [NSMutableSet set];
    }
    return _set;
}

@end
