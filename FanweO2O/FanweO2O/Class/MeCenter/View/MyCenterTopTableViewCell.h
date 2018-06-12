//
//  MyCenterTopTableViewCell.h
//  FanweO2O
//
//  Created by ycp on 17/1/4.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCenterModel.h"
#import "FWO2OJump.h"
#import "FWO2OJumpModel.h"
@protocol MyCenterTopTableViewCellDelegate <NSObject>

- (void)set;

- (void)messageView;

- (void)loginOrRegister;

//vipName 和账户管理调用
- (void)loginUp;
@end
@interface MyCenterTopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *setButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIButton *userNameButton;
@property (weak, nonatomic) IBOutlet UIButton *accountManagementButton;//账户管理
@property (weak, nonatomic) IBOutlet UIImageView *VIPicon;
@property (weak, nonatomic) IBOutlet UILabel *messageIcon; //消息的小图标

@property (weak, nonatomic) IBOutlet UIButton *VIPname;
@property (weak, nonatomic) IBOutlet UIButton *circleOfFriendsButton;
@property (weak, nonatomic) IBOutlet UIButton *balanceButton;  //余额
@property (weak, nonatomic) IBOutlet UIButton *integralButton; //积分
@property (weak, nonatomic) IBOutlet UIView *backgroundRedView;

@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (nonatomic,strong)MyCenterModel *model;
@property (nonatomic,strong)GlobalVariables*fanweApp;
@property (nonatomic,assign)id<MyCenterTopTableViewCellDelegate>delegate;
@end
