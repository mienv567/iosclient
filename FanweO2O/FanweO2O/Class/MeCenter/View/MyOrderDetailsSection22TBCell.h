//
//  MyOrderDetailsSection22TBCell.h
//  FanweO2O
//
//  Created by hym on 2017/5/4.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyOrderDetailsModel;
@interface MyOrderDetailsSection22TBCell : UITableViewCell

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview;

@property (nonatomic, strong) MyOrderDetailsModel *orderModel;

@end
