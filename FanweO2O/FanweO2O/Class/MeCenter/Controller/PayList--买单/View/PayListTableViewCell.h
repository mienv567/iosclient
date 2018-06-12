//
//  PayListTableViewCell.h
//  FanweO2O
//
//  Created by ycp on 17/3/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayListModel.h"
@interface PayListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet UILabel *ConsumptionAmount;
@property (weak, nonatomic) IBOutlet UILabel *DiscountAmount;
@property (weak, nonatomic) IBOutlet UILabel *AmountRealPay;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong)PayListModel *model;
@property (nonatomic,strong)UIColor *color1;
@property (nonatomic,strong)UIColor *color2;
@end
