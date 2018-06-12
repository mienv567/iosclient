//
//  MyViewController.m
//  FanweO2O
//
//  Created by ycp on 16/11/23.
//  Copyright © 2016年 fanwe. All rights reserved.
//

#import "MyViewController.h"
#import "GlobalVariables.h"
#import "O2OAccountLoginVC.h"
#import "WXApi.h"
#import "MyCenterTopTableViewCell.h"
#import "MySectionTableViewCell.h"
#import "MyThirdSectionTableViewCell.h"
#import "MyFourTableViewCell.h"
#import "SetViewController.h"
@interface MyViewController ()<WXApiDelegate>
{
    UITableView *_myTableView;
  
}
@end

@implementation MyViewController


+(instancetype)webControlerWithUrlString:(NSString *)urlStr andNavTitle:(NSString *)navTitle isShowIndicator:(BOOL)isShowIndicator isHideNavBar:(BOOL)isHideNavBar isHideTabBar:(BOOL)isHideTabBar
{
    MyViewController *control=[[MyViewController alloc]init];
    control.urlString = urlStr;
    control.isHideNavBar = isHideNavBar;
    control.isShowBack = YES;
    control.navTitle = navTitle;
    control.isShowIndicator = isShowIndicator;
    control.isHideTabBar = isHideTabBar;
    return control;
}
 
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.webView.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;

    if (self.isImageLoad == YES) {
        self.isImageLoad = NO;
        return;
    }else
    {
        if (!self.isFirstLoad) {
//            if (!self.webView.loading) {
//                [self loadMyView];
//            }
            NSString *str =[NSString stringWithFormat:@"js_ajax_load()"];
            [self.webView evaluateJavaScript:str completionHandler:nil];
        }
    }
    if (self.webView.title ==nil) {
        [self.webView reload];
    }
    
    self.webView.scrollView.bounces = NO;
}


- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    //self.tabBarController.tabBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //self.navigationController.navigationBar.hidden = NO;
    HideIndicatorInView(self.view);
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
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(20);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWebView) name:Fw_O2O_ACCOUNT_LOGIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:FW_O2O_ACCOUNT_LOGOUT_SUCCESS object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWebView) name:FW_O2O_MYWEBVIEW_REFRESH_MSG object:nil];
    

   
}

#pragma mark 刷新网页

- (void)refreshWebView {
    
    [self loadMyView];
    
}

- (void)logout {
    
    NSMutableDictionary *Parameters = [NSMutableDictionary new];
    [Parameters setObject:@"loginout" forKey:@"act"];
    [Parameters setObject:@"user" forKey:@"ctl"];
    ShowIndicatorTextInView(self.view,@"");
    [_httpsManager POSTWithParameters:Parameters SuccessBlock:^(NSDictionary *responseJson) {
        HideIndicatorInView(self.view);
        if ([responseJson[@"status"] integerValue] == 1) {
            self.fanweApp.user_id = @"";
            self.fanweApp.user_email = @"";
            self.fanweApp.user_name = @"";
            self.fanweApp.user_mobile = @"";
            self.fanweApp.user_pwd = @"";
            self.fanweApp.session_id = @"";
            [self loadMyView];
        }else {
            [[HUDHelper sharedInstance] tipMessage:responseJson[@"info"]];
        }
        
    } FailureBlock:^(NSError *error) {
        HideIndicatorInView(self.view);
    }];

}

- (NSString *)seturlString {
    NSString *urlString = @"";
    if ([self.fanweApp.session_id length] == 0) {
        

        
        urlString = [NSString stringWithFormat:@"%@?ctl=%@%@",
                     API_LOTTERYOUT_URL,
                     @"user_center",
                     WEB_BASE_INFO
                     ];
        
    }else {
        

        
        urlString = [NSString stringWithFormat:@"%@?ctl=%@&sess_id=%@%@",
                     API_LOTTERYOUT_URL,
                     @"user_center",
                     self.fanweApp.session_id,
                     WEB_BASE_INFO
                     ];
    }
    
    return urlString;
}

- (void)loadMyView {
    
    ShowIndicatorTextInView(self.view,@"");
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[self seturlString]]];
    [request setHTTPMethod: @"POST"];
    request.timeoutInterval = kWebViewTimeoutInterval; // 设置请求超时
    [request setHTTPBody: [[self seturlString] dataUsingEncoding: NSUTF8StringEncoding]];
    [self.webView loadRequest:request];
    

    
}


#pragma mark- JavaScript调用
- (void)myUserContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
    
    
    if ([message.name isEqualToString:@"third_party_login_sdk"]) {
        
        [[UMSocialManager defaultManager ]getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
            
            UMSocialUserInfoResponse *resp =result;
            
            NSLog(@" %@",resp);
            NSLog(@" uid: %@", resp.uid);
            NSLog(@" openid: %@", resp.openid);
            NSLog(@" accessToken: %@", resp.accessToken);
            NSLog(@" refreshToken: %@", resp.refreshToken);
            NSLog(@" expiration: %@", resp.expiration);
            
            // 用户数据
            NSLog(@" name: %@", resp.name);
            NSLog(@" iconurl: %@", resp.iconurl);
            NSLog(@" gender: %@", resp.gender);
            
            // 第三方平台SDK原始数据
            NSLog(@" originalResponse: %@", resp.originalResponse);
            
        }];
    }
}
- (void)hideMyHud{
    HideIndicatorInView(self.view);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
