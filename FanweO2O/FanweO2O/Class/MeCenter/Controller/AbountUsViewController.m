//
//  AbountUsViewController.m
//  FanweO2O
//
//  Created by ycp on 17/2/14.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "AbountUsViewController.h"

@interface AbountUsViewController ()

@end

@implementation AbountUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"关于我们";
//    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 64)];
//    [self.view addSubview:view];
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
//    button.backgroundColor =[UIColor yellowColor];
    button.frame =CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(goBackHome) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"o2o_dismiss_icon"] forState:UIControlStateNormal];
    UIBarButtonItem *item =[[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:item];

    [self addWebView];
    
    
}
- (void)addWebView
{
    _webView = [[UIWebView alloc] initWithFrame: self.view.frame];
    _webView.dataDetectorTypes = UIDataDetectorTypeNone;
    [self.view addSubview:_webView];
    NSString *strUrl = [_htmlContent stringByReplacingOccurrencesOfString:@"src=\"." withString:@"src=\"https://o2owap.fanwe.net"];
    
     [_webView loadHTMLString:strUrl baseURL:nil];
}
- (void)goBackHome
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
