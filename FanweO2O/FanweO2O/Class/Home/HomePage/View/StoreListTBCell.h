//
//  StoreListTBCell.h
//  FanweO2O
//
//  Created by hym on 2017/1/18.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreListModel.h"

@protocol  StoreListTBCellDelegate <NSObject>

@optional

- (void)selectPayTheBill:(StoreListModel *)model;

@end


@interface StoreListTBCell : UITableViewCell

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview;

@property (nonatomic, strong) StoreListModel *model;

@property (nonatomic, weak)id <StoreListTBCellDelegate>delegate;

@end
