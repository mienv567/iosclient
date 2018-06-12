//
//  QrCodeTableViewCell.h
//  FanweO2O
//
//  Created by ycp on 17/3/3.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConsumptionModel.h"
#import "PreferentialModel.h"
#import "ActivityModel.h"
#import "PickUpGoodsModel.h"
@interface QrCodeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *codeNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowIcon;
@property (weak, nonatomic) IBOutlet UILabel *line;
@property (nonatomic,strong)CouponCount *model;
@property (nonatomic,strong)PreferentialModel *pModel;
@property (nonatomic,strong)PickUpGoodsModel *PGmodel;
@property (nonatomic,strong)ActivityModel *aModel;
@property (nonatomic,strong)UIColor *color1,*color2;
@end
