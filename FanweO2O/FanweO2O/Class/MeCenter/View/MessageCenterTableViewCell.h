//
//  MessageCenterTableViewCell.h
//  FanweO2O
//
//  Created by ycp on 17/1/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCenterTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *angleIcon;
@property (weak, nonatomic) IBOutlet UILabel *timerLbael;

//@property (nonatomic,strong)
@end
