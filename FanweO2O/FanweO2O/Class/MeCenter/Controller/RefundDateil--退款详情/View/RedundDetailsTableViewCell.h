//
//  RedundDetailsTableViewCell.h
//  FanweO2O
//
//  Created by ycp on 17/3/2.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedundDetailsTableViewCell : UITableViewCell
@property (nonatomic,strong)UILabel *resultsLabel;
@property (nonatomic,strong)UILabel *resultsDetailsLabel;
@property (nonatomic,copy)NSString *textContent;
@property (nonatomic,assign)CGFloat height;
@end
