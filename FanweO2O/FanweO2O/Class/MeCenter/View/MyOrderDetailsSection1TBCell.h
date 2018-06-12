//
//  MyOrderDetailsSection1TBCell.h
//  FanweO2O
//
//  Created by hym on 2017/3/6.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyOrderDetailsModel;

@interface MyOrderDetailsSection1TBCell : UITableViewCell

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview;

@property (nonatomic, strong) MyOrderDetailsModel *orderModel;

@end
