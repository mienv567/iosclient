//
//  BrandCustomView.h
//  FanweO2O
//
//  Created by ycp on 17/1/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassSectionDataModel.h"

@protocol BrandCustomViewDelegate <NSObject>

- (void)brand:(NSMutableArray *)brandArray;
- (void)goBackBrandView;
@end
@interface BrandCustomView : UIView
@property (nonatomic,strong)UIView *view;
@property (nonatomic,strong)UIButton *btn1;
@property (nonatomic,strong)UIButton *btn2;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)ClassSectionDataModel *model;
@property (nonatomic,strong)NSMutableArray *brandArray;
@property UIButton *brandBtn;
@property (nonatomic,strong)UILabel *hiddenLabel;
@property (nonatomic,strong)UILabel *lineLabel2;
@property (nonatomic,assign)id<BrandCustomViewDelegate>delegate;
@end
