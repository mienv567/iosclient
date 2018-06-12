//
//  ActivityTableViewCell.h
//  FanweO2O
//
//  Created by hym on 2017/1/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ActivityItem;


@interface ActivityTableViewCell : UITableViewCell

@property (nonatomic, strong) ActivityItem *item;

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview;



@end
