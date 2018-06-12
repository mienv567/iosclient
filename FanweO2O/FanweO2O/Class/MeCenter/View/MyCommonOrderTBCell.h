//
//  MyCommonOrderTBCell.h
//  FanweO2O
//
//  Created by hym on 2017/3/1.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyOrderItemModel;

@interface MyCommonOrderTBCell : UITableViewCell

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview;

@property (nonatomic, strong) MyOrderItemModel *orderItem;

@end
