//
//  ClassSectionView.h
//  FanweO2O
//
//  Created by hym on 2017/1/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassSectionModel.h"

typedef void (^ClassSectionBlock)(ClassSectionModel *select);

@interface ClassSectionView : UIView

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, assign) NSInteger iCount;     //显示的个数， 默认 4个

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, copy) ClassSectionBlock block;

@end
