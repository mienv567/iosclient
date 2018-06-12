//
//  RefundTableViewCell.h
//  FanweO2O
//
//  Created by ycp on 17/3/1.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefundListModel.h"
#import "MyOrderImageView.h"
@interface RefundTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *refundTypeLabel;
@property (weak, nonatomic) IBOutlet MyOrderImageView *stroeImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsDateilLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPricesLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsCountLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *money; //总价
@property (weak, nonatomic) IBOutlet UILabel *bulkNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *refundContent;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (nonatomic,strong)RefundListModel *model;
@property (nonatomic,copy)NSString *refund_type;
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,assign)BOOL isHiddenImage;
@end
