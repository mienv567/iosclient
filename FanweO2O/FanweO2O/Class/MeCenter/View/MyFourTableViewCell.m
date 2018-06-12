//
//  MyFourTableViewCell.m
//  FanweO2O
//
//  Created by ycp on 17/1/9.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MyFourTableViewCell.h"


@interface MyFourTableViewCell ()<ButtonCustomDelegate>

@end
@implementation MyFourTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _fanweApp =[GlobalVariables sharedInstance];
        UILabel * labelName =[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 39)];
        labelName.font =KAppTextFont13;
        labelName.text =@"分销管理";
        labelName.textColor =KAppMainTextBackColor;
        [self.contentView addSubview:labelName];
        self.allOrderButton =[UIButton buttonWithType:UIButtonTypeCustom];
        self.allOrderButton.frame =CGRectMake(kScreenW-106, 0, 96, 39);
        [self.allOrderButton setTitle:@"开通分销资格" forState:UIControlStateNormal];
        [self.allOrderButton setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
        self.allOrderButton.titleLabel.font =KAppTextFont13;
        [self.allOrderButton setTitleColor:kAppGrayColor3 forState:UIControlStateNormal];
        [self.allOrderButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        [self.allOrderButton setImageEdgeInsets:UIEdgeInsetsMake(0, 80, 0, 0)];
        [self.contentView addSubview:_allOrderButton];
        UIButton *distributionButton =[UIButton buttonWithType:UIButtonTypeCustom];
        distributionButton.frame =CGRectMake(0, 0, kScreenW, 40);
        distributionButton.backgroundColor =[UIColor clearColor];
        [distributionButton addTarget:self action:@selector(distributionButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:distributionButton];
        UIView *view =[[UIView alloc] initWithFrame:CGRectMake(10, 39, kScreenW-10, 1)];
        view.backgroundColor =kWhiteGatyGroundColor;
        [self.contentView addSubview:view];
//
//        NSArray *array =[NSArray arrayWithObjects:@"分销管理",@"市场",@"提现",@"好友", nil];
//        NSArray *imageArray =[NSArray arrayWithObjects:@"my_distributionManagement",@"my_market",@"my_withdrawal",@"my_ friends", nil];
//        for (int i =0; i<4; i ++) {
//            CGFloat space =(kScreenW-20 -75*4)/3;
//            ButtonCustom *btn =[[ButtonCustom alloc] initWithFrame:CGRectMake(10+i*(space+75), CGRectGetMaxY(view.frame), 75, 61) imageIcon:imageArray[i] titleText:array[i] angelNumber:nil];
//            
//            [self.contentView addSubview:btn];
//            
//        }
    }
    return self;
}
- (void)setModel:(MyCenterModel *)model
{
    _model =model;
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[ButtonCustom class]]) {
            [view removeFromSuperview];
        }
    }
   
    
    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(10, 39, kScreenW-10, 1)];
    view.backgroundColor =kWhiteGatyGroundColor;
    [self.contentView addSubview:view];

    NSArray *array =[NSArray arrayWithObjects:@"分销管理",@"市场",@"提现",@"好友", nil];
    NSArray *imageArray =[NSArray arrayWithObjects:@"my_distributionManagement",@"my_market",@"my_withdrawal",@"my_ friends", nil];
    for (int i =0; i<4; i ++) {
        
        CGFloat space =(kScreenW-20 -75*4)/3;
        _btn =[[ButtonCustom alloc] initWithFrame:CGRectMake(10+i*(space+75), CGRectGetMaxY(view.frame), 75, 61) imageIcon:imageArray[i] titleText:array[i] angelNumber:nil];
        _btn.delegate =self;
        if ([model.is_user_fx isEqualToString:@"1"]) {
            _btn.hidden =NO;
        }else
        {
            _btn.hidden =YES;
        }
        _btn.Tag =i+6666;
        _btn.delegate =self;
        [self.contentView addSubview:_btn];
        
    }
    if ([model.is_user_fx isEqualToString:@"1"]) {

        self.allOrderButton.hidden =YES;

    }else
    {
        self.allOrderButton.hidden =NO;

    }
  
    
}
- (void)distributionButtonClick
{
    if ([_model.user_login_status isEqualToString:@"0"]) {
        if (_delegate && [_delegate respondsToSelector:@selector(loginView2)]) {
            [_delegate loginView2];
        }
       
    }else
    {
        if ([_model.is_user_fx isEqualToString:@"1"]) {
            return;
        }else{
            
            if ([_model.user_mobile_empty isEqualToString:@"0"]) {
                

                
                FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
                NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_fx&act=vip_buy&session_id=%@",
                                      API_LOTTERYOUT_URL,_fanweApp.session_id];
                jumpModel.url =urlString;
                jumpModel.type = 0;
                jumpModel.isHideNavBar = YES;
                jumpModel.isHideTabBar = YES;
                [FWO2OJump didSelect:jumpModel];
            }else
            {
                if (_delegate && [_delegate respondsToSelector:@selector(newBingPhone)]) {
                    [_delegate newBingPhone];
                }
                
            }
            
        }
    }
}
- (void)buttonCustonToNext:(NSInteger)number
{
    switch (number-6666) {
        case 0:
        {
            

            
            FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
            NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_fx",
                                  API_LOTTERYOUT_URL];
            jumpModel.url =urlString;
            jumpModel.type = 0;
            jumpModel.isHideNavBar = YES;
            jumpModel.isHideTabBar = YES;
            [FWO2OJump didSelect:jumpModel];
        }
            break;
        case 1:
        {
            

            
            FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
            NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_fx&act=deal_fx",
                                  API_LOTTERYOUT_URL];
            jumpModel.url =urlString;
            jumpModel.type = 0;
            jumpModel.isHideNavBar = YES;
            jumpModel.isHideTabBar = YES;
            [FWO2OJump didSelect:jumpModel];
        }
            break;
        case 2:
        {

            
            FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
            NSString *urlString = [NSString stringWithFormat:@"%@?ctl=uc_fxwithdraw",
                                  API_LOTTERYOUT_URL];
            jumpModel.url =urlString;
            jumpModel.type = 0;
            jumpModel.isHideNavBar = YES;
            jumpModel.isHideTabBar = YES;
            [FWO2OJump didSelect:jumpModel];
        }
            break;
        case 3:
        {
            

            
            FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
            NSString *urlString = [NSString stringWithFormat:@"%@?ctl=uc_fxinvite",
                                  API_LOTTERYOUT_URL];
            jumpModel.url =urlString;
            jumpModel.type = 0;
            jumpModel.isHideNavBar = YES;
            jumpModel.isHideTabBar = YES;
            [FWO2OJump didSelect:jumpModel];
        }
            break;
            
        default:
            break;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
