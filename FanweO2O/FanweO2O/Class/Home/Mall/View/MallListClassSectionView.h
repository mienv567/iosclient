//
//  MallListClassSectionView.h
//  FanweO2O
//
//  Created by hym on 2017/2/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClassSectionModel;

@protocol  MallListClassSectionViewDelegate <NSObject>

@optional

- (void)MallListClassSectionSelect:(ClassSectionModel *)model;

- (void)MallListClassSection:(BOOL)hsClass;

@end

@interface MallListClassSectionView : UIView

@property (weak,nonatomic) id <MallListClassSectionViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)upDataWith:(NSArray *)array hsClass:(BOOL)hsClass;

@end
