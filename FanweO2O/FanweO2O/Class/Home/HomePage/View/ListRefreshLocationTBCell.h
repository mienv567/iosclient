//
//  ListRefreshLocationTBCell.h
//  FanweO2O
//
//  Created by hym on 2017/1/18.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListRefreshLocationModel.h"

@protocol  ListRefreshLocationTBCellDelegate <NSObject>

@optional

- (void)startLocation;

@end



@interface ListRefreshLocationTBCell : UITableViewCell

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview;

@property (nonatomic, weak)id <ListRefreshLocationTBCellDelegate>delegate;

@property (nonatomic, strong) ListRefreshLocationModel *model;

@end
