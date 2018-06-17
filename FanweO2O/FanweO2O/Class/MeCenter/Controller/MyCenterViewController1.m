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

@interface MyCenterViewController1 ()
@property (nonatomic, strong)  UINavigationBar *bar;

@end

@implementation MyCenterViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
      self.navigationController.navigationBar.opaque  = 0;
    self.navigationController.navigationBar.hidden    = YES;
    [self.view addSubview:self.bar];
    [self setUI];
    
    
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

}
//设置按钮点击
-(void)tap1 {

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

//设置按钮点击
-(void)clickIcon:(UIButton *)btn {
  
}
@end
