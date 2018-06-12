//
//  AdvsWebViewController.m
//  FanweO2O
//
//  Created by ycp on 16/11/30.
//  Copyright © 2016年 fanwe. All rights reserved.
//

#import "AdvsWebViewController.h"

@interface AdvsWebViewController ()

@end

@implementation AdvsWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden =NO;
    self.title=@"网页";
    UIWebView *web =[[UIWebView alloc] initWithFrame:self.view.bounds];
    NSURL *url =[NSURL URLWithString:@"https://www.baidu.com"];
    NSURLRequest *req =[NSURLRequest requestWithURL:url];
    [web loadRequest:req];
    [self.view addSubview:web];
    
    UIBarButtonItem *item =[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem =item;
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
