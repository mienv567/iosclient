//
//  CustomGoodsComTBCell.h
//  FanweO2O
//
//  Created by hym on 2016/12/13.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomGoodsModel.h"
@interface CustomGoodsComTBCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (nonatomic, strong) CustomGoodsModel *goodModel;
@property (nonatomic,assign)int count; //1:表示从团购列表进来的
+ (instancetype)cellWithTbaleview:(UITableView *)newTableview;

@end
