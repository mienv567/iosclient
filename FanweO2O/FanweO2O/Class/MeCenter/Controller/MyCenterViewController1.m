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
#import "InteractiveWebController.h"
#import "SetModel.h"
#import "StoreWebViewController.h"

@interface MyCenterViewController1 ()
{
        NetHttpsManager *_httpManager;
        GlobalVariables *_FanweApp;
        NSInteger lesstime;
        SetModel *_rowModel;

}
@property (nonatomic, strong)  UINavigationBar *bar;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) UIImage *image;//头像
@property (nonatomic, strong) NetHttpsManager   *httpsManager;      // 网络请求封装
@property (weak, nonatomic) IBOutlet UILabel *monyLable;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *vipLable;
@property (weak, nonatomic) IBOutlet UIImageView *vipImage;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

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
    self.photoImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick)];
    [self.photoImageView addGestureRecognizer:tap];
    self.httpsManager = [NetHttpsManager manager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logChange:) name:@"logChange" object:nil];

    _FanweApp = [GlobalVariables sharedInstance];
    
    if(_FanweApp.is_login)
    {
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:@"ht"] placeholderImage:[UIImage imageNamed:@"mine_headphoto_def"] options:0 completed:nil];
        
        NSString *money = _FanweApp.user_money;
        self.monyLable.text =[NSString stringWithFormat:@"%0.2f元", [money floatValue]];
        self.monyLable.textColor =  RGB(212,163,88);
        self.vipImage.hidden = NO;
        self.vipLable.hidden = NO;
        self.loginBtn.hidden = YES;
        self.nameLable.hidden = NO;
        //    self.vipLable.text = [NSString stringWithFormat:@"%@",];
        self.nameLable.text  = _FanweApp.user_name;
        self.photoImageView.layer.borderColor = RGB(212,163,88).CGColor;
        self.photoImageView.layer.borderWidth = 2;
        
    } else {
        self.monyLable.text =[NSString stringWithFormat:@"登录后查看"];
        self.monyLable.textColor =  [UIColor whiteColor];
        self.vipImage.hidden = YES;
        self.vipLable.hidden = YES;
        self.loginBtn.hidden = NO;
        self.nameLable.hidden = YES;
        self.photoImageView.image = [UIImage imageNamed:@"mine_headphoto_def"];
    }

}

- (void)logChange:(NSNotification *)notification{
    NSString * infoDic = [notification object];
    if ([infoDic isEqualToString:@"login"]) {
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:_FanweApp.user_avatar] placeholderImage:[UIImage imageNamed:@"mine_headphoto_def"] options:0 completed:nil];

        NSString *money = _FanweApp.user_money;
        self.monyLable.text =[NSString stringWithFormat:@"%0.2f元", [money floatValue]];
        self.monyLable.textColor =  RGB(212,163,88);
        self.vipImage.hidden = NO;
        self.vipLable.hidden = NO;
        self.loginBtn.hidden = YES;
        self.nameLable.hidden = NO;
//    self.vipLable.text = [NSString stringWithFormat:@"%@",];
        self.nameLable.text  = _FanweApp.user_name;
        self.photoImageView.layer.borderColor = RGB(212,163,88).CGColor;
        self.photoImageView.layer.borderWidth = 2;
    }  else {
        self.monyLable.text =[NSString stringWithFormat:@"登录后查看"];
        self.monyLable.textColor =  [UIColor whiteColor];
        self.vipImage.hidden = YES;
        self.vipLable.hidden = YES;
        self.loginBtn.hidden = NO;
        self.nameLable.hidden = YES;
        self.photoImageView.image = [UIImage imageNamed:@"mine_headphoto_def"];
    }

  
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
    LoginVCshow
    MessageCenterViewController *vc = [[MessageCenterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//设置按钮点击
-(void)tap1 {
    LoginVCshow
    [self.navigationController pushViewController: [[SetViewController alloc] init] animated:YES];
}

//头像点击
-(void)photoClick {
    LoginVCshow
        //调用相机
    [self.navigationController pushViewController:[AccountManagementViewController new] animated:YES];
    
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
/*付款码*/
- (IBAction)clickPayMoney:(UIButton *)sender {
//    MBProgressHUD *hud = [MBProgressHUD showMessage:@"该功能正在开发中,敬请期待" ];
//    [hud hide:YES afterDelay:1];
     [[HUDHelper sharedInstance] tipMessage:@"该功能正在开发中,敬请期待~"];
}

//扫码
- (IBAction)QRCodeScan:(id)sender {
    LoginVCshow;
    if(_FanweApp.is_set_pass){
        HWScanViewController *vc = [[HWScanViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [[HUDHelper sharedInstance] tipMessage:@"请先设置支付密码~"];
        NSString *urlstring = [NSString stringWithFormat:@"https://app.yitonggo.com/wap/index.php?ctl=uc_money&act=altPass"];
        StoreWebViewController *vc = [StoreWebViewController webControlerWithUrlString:urlstring andNavTitle:nil isShowIndicator:YES isHideNavBar:YES isHideTabBar:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (IBAction)moneyClick:(id)sender {
    LoginVCshow
    NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_money&act=money_log",
                          API_LOTTERYOUT_URL];
    InteractiveWebController *tmpController = [InteractiveWebController webControlerWithUrlString:urlString andNavTitle:@"我的钱包" isShowIndicator:YES isHideNavBar:YES isHideTabBar:YES];
    [[AppDelegate sharedAppDelegate] pushViewController:tmpController];

}

//设置按钮点击
-(void)clickIcon:(UIButton *)btn {
    LoginVCshow
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
        
        [[HUDHelper sharedInstance] tipMessage:@"暂无活动,敬请期待~"];
//        FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
//        NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_share",
//                              API_LOTTERYOUT_URL];
//        jumpModel.url =urlString;
//        jumpModel.type = 0;
//        jumpModel.isHideNavBar = YES;
//        jumpModel.isHideTabBar = YES;
//        [FWO2OJump didSelect:jumpModel];
        
    } else if (btn.tag == 4) {//客服中心
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"客服电话" message:@"是否拨打客服电话:0000000" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 拨打电话
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://000000"]];

        }];
        UIAlertAction *act2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertC dismissViewControllerAnimated:true completion:nil];
        }];
        [alertC addAction:act1];
        [alertC addAction:act2];
        [self presentViewController:alertC animated:true completion:nil];
    } else if (btn.tag == 5) {//关于我们
    
        [self updateNetWork];
       
    }
}
    
- (void)updateNetWork
{
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"setting" forKey:@"ctl"];
    if (_FanweApp.session_id ==nil) {
        [dic setObject:@"" forKey:@"session_id"];
    }else{
        [dic setObject:_FanweApp.session_id forKey:@"session_id"];
    }
    ShowIndicatorTextInView(self.view,@"");
    [_httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        
        HideIndicatorInView(self.view);
        
        if ([responseJson toInt:@"status"] ==1) {
            _rowModel =[SetModel mj_objectWithKeyValues:responseJson];
            dispatch_async(dispatch_get_main_queue(), ^{
                AbountUsViewController *vc =[AbountUsViewController new];
                UINavigationController *my =[[UINavigationController alloc] initWithRootViewController:vc];
                vc.htmlContent =_rowModel.APP_ABOUT_US;
                [self presentViewController:my animated:YES completion:nil];
            });
        }
        
    } FailureBlock:^(NSError *error) {
        HideIndicatorInView(self.view);
        [[HUDHelper sharedInstance] tipMessage:kNetErrorMsg];
    }];
    
}

@end
