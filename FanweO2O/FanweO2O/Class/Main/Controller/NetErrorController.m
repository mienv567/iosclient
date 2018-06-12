//
//  NetErrorController.m
//  ZCTest
//
//  Created by mac on 16/3/4.
//  Copyright © 2016年 guoms. All rights reserved.
//

#import "NetErrorController.h"
#import "UIView+Extension.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "GlobalVariables.h"
#import "MBProgressHUD+MJ.h"

@interface NetErrorController ()<UIWebViewDelegate>

@property (nonatomic, strong) GlobalVariables *fanweApp;
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIImageView *bottomImageView;
@property (nonatomic, strong) UIButton *reloadBtn;

@end

@implementation NetErrorController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MBProgressHUD hideHUD];
    
    self.title = @"网络错误";
    
    self.fanweApp = [GlobalVariables sharedInstance];
    
    if ([_fanweApp.appModel.statusbar_color length]>0) {
        NSMutableString *statusbar_color = [NSMutableString stringWithString:_fanweApp.appModel.statusbar_color];
        if ([statusbar_color hasPrefix:@"#"]) {
            [statusbar_color deleteCharactersInRange:NSMakeRange(0,1)];
        }
        
        unsigned int hexValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:statusbar_color];
        [scanner setScanLocation:0]; // depends on your exact string format you may have to use location 1
        [scanner scanHexInt:&hexValue];
        
        self.view.backgroundColor=RGBOF(hexValue);
    }else{
        self.view.backgroundColor=RGB(85, 172, 239);
    }
    
    self.backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kScreenW, kScreenH-20)];
    self.backGroundView.backgroundColor = kBackGroundColor;
    [self.view addSubview:self.backGroundView];
    
    UIImageView *wifiImg = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenW-83)/2, ((CGRectGetHeight(self.backGroundView.frame)*0.75-83))/2, 83, 83)];
    [wifiImg setImage:[UIImage imageNamed:@"no_network_4.png"]];
    [self.backGroundView addSubview:wifiImg];
    
    self.tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(wifiImg.frame)+20, kScreenW, 21)];
    self.tipLabel.backgroundColor = kBackGroundColor;
    self.tipLabel.font = [UIFont systemFontOfSize:14.0];
    self.tipLabel.textColor = [UIColor lightGrayColor];
    self.tipLabel.text = @"亲，您的网络状况不大好哦！";
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.backGroundView addSubview:self.tipLabel];
    
    self.reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.reloadBtn.frame = CGRectMake((kScreenW-80)/2, CGRectGetMaxY(self.tipLabel.frame)+20, 80, 30);
    self.reloadBtn.backgroundColor = [UIColor whiteColor];
    self.reloadBtn.layer.cornerRadius = 3;
    self.reloadBtn.layer.borderColor = [kAppSpaceColor CGColor];
    [self.reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
    [self.reloadBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.reloadBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.reloadBtn addTarget:self action:@selector(loadViewAgain) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundView addSubview:self.reloadBtn];
    
    self.topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, kScreenW, 38)];
    [self.topImageView setImage:[UIImage imageNamed:@"tab_top.png"]];
    [self.view addSubview:self.topImageView];
    self.topImageView.hidden = YES;
    
    self.bottomImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kScreenH-45, kScreenW, 45)];
    [self.bottomImageView setImage:[UIImage imageNamed:@"tab_bottom.png"]];
    [self.view addSubview:self.bottomImageView];
    self.bottomImageView.hidden = YES;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)loadViewAgain{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadWebView" object:nil];
    
    [self.navigationController.view removeFromSuperview];
    [self.navigationController removeFromParentViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
