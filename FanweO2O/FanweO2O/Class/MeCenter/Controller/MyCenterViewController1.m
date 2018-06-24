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
#import "MoneyViewController.h"

#import "HWScanViewController.h"
#import "UIActionSheet+camera.h"

@interface MyCenterViewController1 ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
        NetHttpsManager *_httpManager;
        GlobalVariables *_FanweApp;
        NSInteger lesstime;
}
@property (nonatomic, strong)  UINavigationBar *bar;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) UIImage *image;//头像
@property (nonatomic, strong) NetHttpsManager   *httpsManager;      // 网络请求封装

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoChange:) name:@"user_avatar" object:nil];
}
- (void)photoChange:(NSNotification *)notification{
   
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:@"http://o2o.365csh.com/public/avatar/noavatar.gif"] placeholderImage:[UIImage imageNamed:@"mine_headphoto_def"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    
        CGFloat w = 90;
        CGFloat h = 90;
        CGRect ctxRect = CGRectMake(0, 0, w, h);
        if (image == nil) return ;
        // 1.开启图形上下文
        // scale:比例因子 像素与点比例
        UIGraphicsBeginImageContextWithOptions(ctxRect.size,NO, 0);
        // 2.描述圆形裁剪区域
        UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, w, h)];
        // 3.设置裁剪区域
        [clipPath addClip];
        
        // 4.画图片
        [image drawAtPoint:CGPointZero];
        
        // 5.获取图片
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        // 6.关闭上下文
        UIGraphicsEndImageContext();
        self.photoImageView.image = image;
    }];
  
  
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

//头像点击
-(void)photoClick {
    if(!kis_login){
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[LogInViewController new] animated:YES completion:nil];
    }else {
        //调用相机
        UIActionSheet *cameraActionSheet = [UIActionSheet showCameraActionSheet];
        cameraActionSheet.targer = self;
        [cameraActionSheet showInView:self.view];
     }
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
    HWScanViewController *vc = [[HWScanViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)moneyClick:(id)sender {
    if (!kis_login) {
        LogInViewController *vc = [[LogInViewController alloc] init];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
    } else {
        MoneyViewController *vc = [[MoneyViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//设置按钮点击
-(void)clickIcon:(UIButton *)btn {
    if (!kis_login) {
        LogInViewController *vc = [[LogInViewController alloc] init];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
        return;
    }
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
        
    } else if (btn.tag == 5) {//关于我们
        AbountUsViewController *vc =[AbountUsViewController new];
        UINavigationController *my =[[UINavigationController alloc] initWithRootViewController:vc];
//        vc.htmlContent =_rowModel.APP_ABOUT_US;
        [self presentViewController:my animated:YES completion:nil];
    }
}
    
    
#pragma mark - UIImagePickerController Delegate
    //当选择一张图片后进入这里
    -(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
    {
        
        NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
        
        //当选择的类型是图片
        if ([type isEqualToString:@"public.image"])
        {
            //先把图片转成NSData
            _image = [info objectForKey:UIImagePickerControllerEditedImage];
            
            //压缩图片
            NSData *imageNewData = UIImageJPEGRepresentation(_image, 0.5);
            //上传到阿里云
            [self requestCommitImageData:imageNewData];
            
            //关闭相册界面
            [picker dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
/** 取消相机 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

    
#pragma mark - Request
/** 上传头像 */
-  (void)  requestCommitImageData:(NSData *)imageData{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    
    [parmDict setObject:@"uc_account" forKey:@"ctl"];
    [parmDict setObject:@"upload_avatar" forKey:@"act"];

    [self.httpsManager imageResponse:parmDict imageData:imageData SuccessBlock:^(NSDictionary *responseJson) {

    } FailureBlock:^(NSError *error) {
        NSLog(@"%@",error.description);
          NSLog(@"%@上传失败",error.description);
    }];
}

@end
