//
//  ConsumptionLiftView.h
//  FanweO2O
//
//  Created by ycp on 17/3/6.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConsumptionModel.h"
#import "PickUpGoodsModel.h"
@interface ConsumptionLiftView : UIView
@property (nonatomic,strong)UILabel *oderNumber;
@property (nonatomic,strong)UIImageView *storesIcon;
@property (nonatomic,strong)UILabel *storesName;
@property (nonatomic,strong)UILabel *storesNumberLabel;
@property (nonatomic,strong)UIImageView *arrowImageView;
@property (nonatomic,strong)ConsumptionModel *model;
@property (nonatomic,strong)PickUpGoodsModel  *pModel;
@end
