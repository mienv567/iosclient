//
//  ShoppingViewController.m
//  FanweO2O
//
//  Created by ycp on 16/11/25.
//  Copyright © 2016年 fanwe. All rights reserved.
//

#import "ShoppingViewController.h"

@interface ShoppingViewController ()

@end

@implementation ShoppingViewController


+(instancetype)webControlerWithUrlString:(NSString *)urlStr andNavTitle:(NSString *)navTitle isShowIndicator:(BOOL)isShowIndicator isHideNavBar:(BOOL)isHideNavBar isHideTabBar:(BOOL)isHideTabBar
{
    ShoppingViewController *control = [[ShoppingViewController alloc]init];
    control.urlString = urlStr;
    control.isHideNavBar = isHideNavBar;
    control.isShowBack = YES;
    control.navTitle = navTitle;
    control.isShowIndicator = isShowIndicator;
    control.isHideTabBar = isHideTabBar;
    return control;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.webView.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //ShowIndicatorTextInView(self.view,@"");
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(20);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];

   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWebView) name:Fw_O2O_ACCOUNT_LOGIN_SUCCESS object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWebView) name:FW_O2O_MYWEBVIEW_REFRESH_MSG object:nil];
    //清除缓存
    NSArray * types = @[WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeDiskCache];
    NSSet *websiteDataTypes = [NSSet setWithArray:types];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
        
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    //self.navigationController.navigationBar.hidden = NO;
    //self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.webView.hidden = NO;
    });
    
    
}

- (NSString *)seturlString {

    NSString *urlString = @"";
//    urlString = [NSString stringWithFormat:@"%@?ctl=cart&sess_id=%@%@",
//                 API_LOTTERYOUT_URL,
//                 self.fanweApp.session_id,
//                 WEB_BASE_INFO
//                 ];
    urlString = [NSString stringWithFormat:@"%@?ctl=uc_order&tuan=1",
                 API_LOTTERYOUT_URL
                 ];

    return urlString;
}


- (void)loadMyView {
    
    //ShowIndicatorTextInView(self.view,@"");
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[self seturlString]]];
    [request setHTTPMethod: @"POST"];
    request.timeoutInterval = kWebViewTimeoutInterval; // 设置请求超时
    [request setHTTPBody: [[self seturlString] dataUsingEncoding: NSUTF8StringEncoding]];
    [self.webView loadRequest:request];
    
}

/*
- (void)webViewLoad{
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self seturlString]]];
    [request setHTTPMethod:@"POST"];
    request.timeoutInterval = kWebViewTimeoutInterval;
    [self.webView loadRequest:request];

    
}

*/



- (void)hideMyHud{
    HideIndicatorInView(self.view);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 刷新网页

- (void)refreshWebView {
    
    [self loadMyView];
    
}


@end
