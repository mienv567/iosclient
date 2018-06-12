//
//  RefundApplicationContentTableViewCell.h
//  FanweO2O
//
//  Created by ycp on 17/3/14.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefundApplicationModel.h"
@interface RefundApplicationContentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;
@property (weak, nonatomic) IBOutlet UILabel *stroeName;
@property (weak, nonatomic) IBOutlet UILabel *attrLabel;  //规格
@property (weak, nonatomic) IBOutlet UILabel *storeContet;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property(nonatomic,strong)MainContent  *model;
@end
