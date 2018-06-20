//
//  MyCenterViewController1.m
//  ZhoubaitongO2O
//
//  Created by Harlan on 2018/6/15.
//  Copyright © 2018年 xfg. All rights reserved.
//

#import "MyCenterViewController1.h"
#import "ZMNavigationBar.h"
#import "ZMButton.h"
#import "LogInViewController.h"

#import "SetViewController.h"
#import "MessageCenterViewController.h"

#import "PreferentialViewController.h"
#import "MyCollectVC.h"
#import "AbountUsViewController.h"
#import "AccountManagementViewController.h"

#import "HWScanViewController.h"


@interface MyCenterViewController1 ()
@property (nonatomic, strong)  UINavigationBar *bar;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation MyCenterViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self.view addSubview:self.bar];
    [self setUI];
    self.contentView.layer.shadowColor =  [UIColor blackColor].CGColor;
    self.contentView.layer.shadowOpacity = 0.6f;
    self.contentView.layer.shadowOffset = CGSizeMake(0,3);
    self.contentView.layer.cornerRadius = 20;
    [self.contentView.layer masksToBounds];
    
}

- (UINavigationBar *)bar {
    if (_bar == nil) {
        _bar = [[ZMNavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KStatusBarAndNavigationBarHeight)];
        UINavigationItem *item = [[UINavigationItem alloc] init];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"mine_nav_icon_setup"] forState:UIControlStateNormal];
        [btn sizeToFit];
        [btn addTarget:self action:@selector(tap1) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:btn];
        item.leftBarButtonItem = item1;
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 setImage:[UIImage imageNamed:@"mine_nav_icon_news"] forState:UIControlStateNormal];
        [btn1 sizeToFit];
        [btn1 addTarget:self action:@selector(tap2) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:btn1];
        item.rightBarButtonItem = item2;
        _bar.items = @[item];

    }
    return _bar;
}
//聊天按钮点击
-(void)tap2 {
    MessageCenterViewController *vc = [[MessageCenterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//设置按钮点击
-(void)tap1 {
    [self.navigationController pushViewController: [[SetViewController alloc] init] animated:YES];
}
// 设置底部6个按钮
-(void)setUI {
    NSArray *iconArray = @[@"mine_personal_icon_normal",@"mine_coupon_icon_normal",@"mine_collection_icon_normal",@"mine_share_icon_normal",@"mine_service_icon_normal",@"mine_about_icon_normal"];
    NSArray *name = @[@"个人资料",@"优惠券",@"我的收藏",@"分享有礼",@"客服中心",@"关于我们"];
    for (int i = 0; i < iconArray.count; i++) {
        ZMButton *btn = [ZMButton buttonWithType:UIButtonTypeCustom];
        int y = 776  / 2 * kScreenHeightRatio;
        int marginY = 74 / 2;
        int width = 56;
        int height = 55;
        int marginX = (SCREEN_WIDTH - 3 * width ) / 4;
        btn.frame = CGRectMake(marginX + i % 3 * (marginX +width), y + i / 3 * (marginY + height), width, height);
        btn.tag = i;
        [btn setTitleColor:kAppGrayColor1 forState:UIControlStateNormal];
        [btn setTitle:name[i] forState:UIControlStateNormal];
         btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        [btn addTarget:self action:@selector(clickIcon:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:iconArray[i]] forState:UIControlStateNormal];
        [self.view addSubview:btn];
         
    }
}
- (IBAction)clickLogInBtn:(UIButton *)sender {
  
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[LogInViewController new] animated:YES completion:nil];
}
- (IBAction)clickPayMoney:(UIButton *)sender {
}

//扫码
- (IBAction)QRCodeScan:(id)sender {
    HWScanViewController *vc = [[HWScanViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//设置按钮点击
-(void)clickIcon:(UIButton *)btn {
    if (btn.tag == 1){ //优惠券控制器
        if (kOlderVersion<=2) {
            FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
            NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_youhui",
                                  API_LOTTERYOUT_URL];
            jumpModel.url =urlString;
            jumpModel.type = 0;
            jumpModel.isHideNavBar = YES;
            jumpModel.isHideTabBar = YES;
            [FWO2OJump didSelect:jumpModel];
        }else{
            [[AppDelegate sharedAppDelegate]pushViewController:[PreferentialViewController new]];
        }
    } else if (btn.tag == 0){ //个人资料控制器
//        if ([_model.user_login_status isEqualToString:@"1"]) {
            [self.navigationController pushViewController:[AccountManagementViewController new] animated:YES];
//        }else
//        {
//            [self.navigationController pushViewController:[O2OAccountLoginVC new] animated:YES];
//        }
    } else if (btn.tag == 2) { //我的收藏
        if (kOlderVersion<=2) {
            FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
            NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_collect",
                                  API_LOTTERYOUT_URL];
            jumpModel.url =urlString;
            jumpModel.type = 0;
            jumpModel.isHideNavBar = YES;
            jumpModel.isHideTabBar = YES;
            [FWO2OJump didSelect:jumpModel];
            
        }else {
            [[AppDelegate sharedAppDelegate] pushViewController:[[MyCollectVC alloc]initWithNibName:@"MyCollectVC" bundle:nil]];
        }
        
    } else if (btn.tag == 3) {//分享有礼
        FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
        NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_share",
                              API_LOTTERYOUT_URL];
        jumpModel.url =urlString;
        jumpModel.type = 0;
        jumpModel.isHideNavBar = YES;
        jumpModel.isHideTabBar = YES;
        [FWO2OJump didSelect:jumpModel];
        
    } else if (btn.tag == 4) {//客服中心
        
    } else if (btn.tag == 5) {//关于我们
        AbountUsViewController *vc =[AbountUsViewController new];
        UINavigationController *my =[[UINavigationController alloc] initWithRootViewController:vc];
//        vc.htmlContent =_rowModel.APP_ABOUT_US;
        [self presentViewController:my animated:YES completion:nil];
    }
}
@end
