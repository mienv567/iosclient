//
//  SelectRefundShopTBCell.h
//  FanweO2O
//
//  Created by hym on 2017/3/14.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RefundShopModel;

@protocol SelectRefundShopTBCellDelegate <NSObject>

@optional
- (void)refreshTableView:(RefundShopModel *)orderItem;

@end

@interface SelectRefundShopTBCell : UITableViewCell

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview;

@property (nonatomic, strong) RefundShopModel *orderItem;

@property (nonatomic, retain) id<SelectRefundShopTBCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *line;
@end
