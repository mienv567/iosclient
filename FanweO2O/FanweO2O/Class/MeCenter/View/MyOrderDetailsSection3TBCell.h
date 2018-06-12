//
//  MyOrderDetailsSection3TBCell.h
//  FanweO2O
//
//  Created by hym on 2017/3/7.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyOrderDetailsStoreItem;

@interface MyOrderDetailsSection3TBCell : UITableViewCell

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview;

@property (nonatomic, strong) MyOrderDetailsStoreItem *model;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutHeight;

@end
