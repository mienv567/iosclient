//
//  ConsumptionView.h
//  FanweO2O
//
//  Created by ycp on 17/3/3.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConsumptionModel.h"
#import "ActivityModel.h"
#import "MyOrderImageView.h"
@interface ConsumptionView : UIView
@property (nonatomic,strong)MyOrderImageView *bigImageView;
@property (nonatomic,strong)UILabel *goodsName;;
@property (nonatomic,strong)UILabel *goodsTime;
@property (nonatomic,strong)ConsumptionModel *model;
@property (nonatomic,strong)ActivityModel *aModel;
@property (nonatomic,strong)UILabel *line;
@property (nonatomic,strong)UIColor *backColor;
@property (nonatomic,strong)UIColor *lineColor;
@end
