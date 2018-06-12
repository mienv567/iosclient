//
//  AccountManagerTableViewCell.h
//  FanweO2O
//
//  Created by ycp on 17/1/14.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountManagerModel.h"
@interface AccountManagerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstTitleView;
@property (weak, nonatomic) IBOutlet UIButton *firstLittleButton;
@property (weak, nonatomic) IBOutlet UILabel *firstLeftLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *firstProgressView;
@property (weak, nonatomic) IBOutlet UILabel *firstRightLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstBottomLabel;
@property (weak, nonatomic) IBOutlet UIView *secondView;

@property (weak, nonatomic) IBOutlet UILabel *secondTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *secondLittleButton;
@property (weak, nonatomic) IBOutlet UILabel *secondLeftLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *secondProgressView;
@property (weak, nonatomic) IBOutlet UILabel *secondRightLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondBottomLabel;

@property (nonatomic,strong)AccountManagerModel *model;
@property (nonatomic,assign)BOOL isComing;
@property NSTimer *timer;


@end
