//
//  MyCenterTopTableViewCell.m
//  FanweO2O
//
//  Created by ycp on 17/1/4.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MyCenterTopTableViewCell.h"

@interface MyCenterTopTableViewCell ()
{
    NSString *str1;
    NSString *str2;
}

@end
@implementation MyCenterTopTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    _fanweApp = [GlobalVariables sharedInstance];
    
    self.backgroundColor =kWhiteGatyGroundColor;
    self.backgroundRedView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"my_background"]];

    self.headerImageView.backgroundColor =[UIColor colorWithRed:0.898 green:0.906 blue:0.929 alpha:1.00];
    self.headerImageView.layer.masksToBounds =YES;
    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width/2;
    self.userNameButton.titleLabel.font =KAppTextFont15;
    
    self.messageIcon.layer.cornerRadius =self.messageIcon.size.width/2;
    self.messageIcon.layer.masksToBounds =YES;
    self.messageIcon.hidden =YES;
    self.messageIcon.backgroundColor =[UIColor colorWithRed:1.000 green:0.518 blue:0.000 alpha:1.00];
   
    self.accountManagementButton.layer.masksToBounds =YES;
    self.accountManagementButton.titleLabel.font =kAppTextFont12;
    [self.accountManagementButton setTitle:@" 账户管理" forState:UIControlStateNormal];
    [self.accountManagementButton setTitleColor:[UIColor colorWithRed:0.910 green:0.729 blue:0.176 alpha:1.00] forState:UIControlStateNormal];
    [self.accountManagementButton setImage:[UIImage imageNamed:@"my_arrow"] forState:UIControlStateNormal];
    [self.accountManagementButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [self.accountManagementButton setImageEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
    self.accountManagementButton.backgroundColor =[UIColor colorWithRed:0.502 green:0.122 blue:0.161 alpha:1.00];
    self.accountManagementButton.layer.masksToBounds =YES;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.accountManagementButton.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(21/2, 0)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.accountManagementButton.bounds;
    maskLayer.path = maskPath.CGPath;
    self.accountManagementButton.layer.mask = maskLayer;

    [self.VIPname setTitle:@"    普通会员  " forState:UIControlStateNormal];
    self.VIPname.titleLabel.font =kAppTextFont12;
    [self.VIPname setBackgroundColor:[UIColor colorWithRed:0.502 green:0.122 blue:0.161 alpha:1.00]];
    self.VIPname.layer.masksToBounds =YES;
    self.VIPname.layer.cornerRadius =self.VIPname.frame.size.height/2;
    self.VIPicon.image =[UIImage imageNamed:@"my_VIPicon"];
    self.VIPicon.layer.masksToBounds =YES;
    self.VIPicon.layer.cornerRadius =self.VIPicon.frame.size.height/2;
    self.VIPicon.layer.borderWidth =1.5;
    self.VIPicon.layer.borderColor =[UIColor colorWithRed:0.502 green:0.122 blue:0.161 alpha:1.00].CGColor;
    [self.circleOfFriendsButton setImage:[UIImage imageNamed:@"my_ windmill"] forState:UIControlStateNormal];
    [self.circleOfFriendsButton setTitle:@" 朋友圈" forState:UIControlStateNormal];
    self.circleOfFriendsButton.titleLabel.font =kAppTextFont12;
    self.buttonView.layer.masksToBounds =YES;
    self.buttonView.layer.cornerRadius =self.buttonView.frame.size.height/2;
    [self.balanceButton setImage:[UIImage imageNamed:@"my_balance"] forState:UIControlStateNormal];
    self.VIPname.hidden =YES;
    self.VIPicon.hidden =YES;
    self.circleOfFriendsButton.hidden =YES;
    self.lineLabel.hidden =YES;
    
    str1 =@" 余额 0";
    str2 =@" 积分 0";
    NSMutableAttributedString *string =[[NSMutableAttributedString alloc] initWithString:str1];
    [string addAttributes:@{NSForegroundColorAttributeName:KAppMainTextBackColor,NSFontAttributeName:kAppTextFont12} range:NSMakeRange(0, 3)];
    
    [string addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.996 green:0.157 blue:0.286 alpha:1.00],NSFontAttributeName:kAppTextFont12} range:NSMakeRange(3, str1.length-3)];
    [self.balanceButton setAttributedTitle:string forState:UIControlStateNormal];
    [self.integralButton setImage:[UIImage imageNamed:@"my_ integral"] forState:UIControlStateNormal];
      NSMutableAttributedString *att =[[NSMutableAttributedString alloc] initWithString:str2];
    [att addAttributes:@{NSForegroundColorAttributeName:KAppMainTextBackColor,NSFontAttributeName:kAppTextFont12} range:NSMakeRange(0, 3)];
    
    [att addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.996 green:0.157 blue:0.286 alpha:1.00],NSFontAttributeName:kAppTextFont12} range:NSMakeRange(3, str2.length-3)];
    [self.integralButton setAttributedTitle:att forState:UIControlStateNormal];
    
}
- (void)setModel:(MyCenterModel *)model
{
    _model =model;
    
    if ([model.user_login_status isEqualToString:@"0"]) {
        [self.userNameButton setTitle:@"点击登录或注册" forState:UIControlStateNormal];
        self.VIPname.hidden =YES;
        self.VIPicon.hidden =YES;
        self.circleOfFriendsButton.hidden =YES;
        self.lineLabel.hidden =YES;
        str1 =@" 余额 0";
        str2 =@" 积分 0";
        
        [self.headerImageView setImage:[UIImage imageNamed:@"my_noLoginImage"]];
        
    }else
    {
        
        [self.userNameButton setTitle:model.user_name forState:UIControlStateNormal];
        [self.VIPname setTitle:[NSString stringWithFormat:@"   %@  ",model.user_group] forState:UIControlStateNormal];
        self.VIPname.hidden =NO;
        self.VIPicon.hidden =NO;
        self.circleOfFriendsButton.hidden =NO;
        self.lineLabel.hidden =NO;
    
        if ([model.user_money intValue] ==0) {
            str1 =@" 余额 0";
        }else
        {
            
            str1 = [NSString stringWithFormat:@" 余额 %.2f", [model.user_money floatValue]];
        }
        
        str2 =[NSString stringWithFormat:@" 积分 %@", model.user_score];
        
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.user_avatar] placeholderImage:[UIImage imageNamed:@"my_noLoginImage"]];
    }
    //富文本
    NSMutableAttributedString *string =[[NSMutableAttributedString alloc] initWithString:str1];
    [string addAttributes:@{NSForegroundColorAttributeName:KAppMainTextBackColor,NSFontAttributeName:kAppTextFont12} range:NSMakeRange(0, 3)];
    
    [string addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.996 green:0.157 blue:0.286 alpha:1.00],NSFontAttributeName:kAppTextFont12} range:NSMakeRange(3, str1.length-3)];
    [self.balanceButton setAttributedTitle:string forState:UIControlStateNormal];
    [self.integralButton setImage:[UIImage imageNamed:@"my_ integral"] forState:UIControlStateNormal];
    NSMutableAttributedString *att =[[NSMutableAttributedString alloc] initWithString:str2];
    [att addAttributes:@{NSForegroundColorAttributeName:KAppMainTextBackColor,NSFontAttributeName:kAppTextFont12} range:NSMakeRange(0, 3)];
    
    [att addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.996 green:0.157 blue:0.286 alpha:1.00],NSFontAttributeName:kAppTextFont12} range:NSMakeRange(3, str2.length-3)];
    [self.integralButton setAttributedTitle:att forState:UIControlStateNormal];

    if (![_model.not_read_msg isEqualToString:@""] && _model.not_read_msg != nil) {
        self.messageIcon.hidden =NO;
    }else
    {
        self.messageIcon.hidden =YES;
    }
    
}
//设置按钮
- (IBAction)setButton:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(set)]) {
        [_delegate set];
    }
}
//信息按钮
- (IBAction)messageButton:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(messageView)]) {
        [_delegate messageView];
    }
}
//用户名字按钮
- (IBAction)userName:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(loginOrRegister)]) {
        [_delegate loginOrRegister];
    }
}
//VIP名字按钮
- (IBAction)VIPNameButton:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(loginUp)]) {
        [_delegate loginUp];
    }
}
//朋友圈按钮
- (IBAction)circleFriendsButton:(id)sender {
    
    FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
    NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_home",
                          API_LOTTERYOUT_URL];
    jumpModel.url =urlString;
    jumpModel.type = 0;
    jumpModel.isHideNavBar = YES;
    jumpModel.isHideTabBar = YES;
    [FWO2OJump didSelect:jumpModel];
}
//管理账户按钮
- (IBAction)accountManagementButton:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(loginUp)]) {
        [_delegate loginUp];
    }
}
//余额按钮
- (IBAction)balanceButton:(id)sender {
    if (_fanweApp.is_login ==YES) {
        

        FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
        NSString *urlString = [NSString stringWithFormat:@"%@?ctl=uc_money",
                              API_LOTTERYOUT_URL];
        jumpModel.url =urlString;
        jumpModel.type = 0;
        jumpModel.isHideNavBar = YES;
        jumpModel.isHideTabBar = YES;
        [FWO2OJump didSelect:jumpModel];
    }else
    {
        if (_delegate && [_delegate respondsToSelector:@selector(loginOrRegister)]) {
            [_delegate loginOrRegister];
        }
    }
}
//积分按钮
- (IBAction)integralButton:(id)sender {
    if (_fanweApp.is_login ==YES) {
        
        
        FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
        NSString *urlString = [NSString stringWithFormat:@"%@?ctl=uc_score",
                              API_LOTTERYOUT_URL];
        jumpModel.url =urlString;
        jumpModel.type = 0;
        jumpModel.isHideNavBar = YES;
        jumpModel.isHideTabBar = YES;
        [FWO2OJump didSelect:jumpModel];
    }else
    {
        if (_delegate && [_delegate respondsToSelector:@selector(loginOrRegister)]) {
            [_delegate loginOrRegister];
        }
    }
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
