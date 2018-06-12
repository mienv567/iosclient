//
//  ClassificationMessageTableViewCell.h
//  FanweO2O
//
//  Created by ycp on 17/3/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassificationMessageModel.h"
@interface ClassificationMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic,strong)ClassificationMessageModel *model;
@end
