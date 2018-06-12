//
//  MyFourTableViewCell.h
//  FanweO2O
//
//  Created by ycp on 17/1/9.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCenterModel.h"
#import "FWO2OJump.h"
#import "FWO2OJumpModel.h"
#import "ButtonCustom.h"

@protocol MyFourTableViewCellDelegate <NSObject>

- (void)loginView2;
- (void)newBingPhone;

@end
@interface MyFourTableViewCell : UITableViewCell
@property (nonatomic,strong) UIButton *allOrderButton;
@property (nonatomic,strong) MyCenterModel *model;
@property (nonatomic,strong) NSArray *numberArray;
@property (nonatomic,strong) ButtonCustom *btn;
@property (nonatomic,assign) id<MyFourTableViewCellDelegate>delegate;
@property (nonatomic,strong)GlobalVariables *fanweApp;
@end
