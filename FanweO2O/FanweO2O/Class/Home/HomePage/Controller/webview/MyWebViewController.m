//
//  MyWebViewController.m
//  fanwe_p2p
//
//  Created by mac on 14-8-4.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "MyWebViewController.h"
#import "NJKWebViewProgress.h"
//#import "GoodsDetailController.h"
//#import "MerchantDetailsController.h"
//#import "EventDetailController.h"
//#import "YouhuiDetailController.h"
//#import "LoginController.h"
//#import "AdJump.h"
#import "UIBarButtonItem+ms.h"

@interface MyWebViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>{
    UIButton *backButton;
    UIProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    UIButton *_bacdBtn;
    UIButton *_closeBtn;
}
@end

@implementation MyWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //    _myWebView.scalesPageToFit = YES; //手动放大缩小
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 65, 20)];
    leftView.backgroundColor = [UIColor clearColor];
    
    //右菜单 返回按钮
    _bacdBtn = [[UIButton alloc]initWithFrame:CGRectMake(-5, -5, 28, 28)];
    [_bacdBtn setImage:[UIImage imageNamed:@"ico_back.png"] forState:UIControlStateNormal];
    [_bacdBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:_bacdBtn];
    
    //右菜单 关闭按钮
    _closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(35, 0, 30, 20)];
    [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    _closeBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:_closeBtn];
    _closeBtn.hidden = YES;
    
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    
    if (self.url != nil){
        if ([self.url length] > 10) {
            _progressProxy = [[NJKWebViewProgress alloc] init];
            _myWebView.delegate = _progressProxy;
            _progressProxy.webViewProxyDelegate = self;
            _progressProxy.progressDelegate = self;
            
            _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
            _progressView.center = CGPointMake(self.navigationController.navigationBar.bounds.size.width / 2, self.navigationController.navigationBar.bounds.size.height-1);
            [self.navigationController.navigationBar addSubview:_progressView];
            
            [_myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        }
    }else{
        _myWebView.delegate = self;
        [_myWebView loadHTMLString:self.content baseURL:nil];
    }
    
    //self.navigationItem.title = self.titleStr;
}

- (void)backAction{
    if (_myWebView.canGoBack) {
        [_myWebView goBack];
        _closeBtn.hidden = NO;
    }else{
        [self closeAction];
    }
}

- (void)closeAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
}

#pragma mark 加载完毕
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //隐藏网络请求加载图标
    [UIApplication sharedApplication].networkActivityIndicatorVisible=false;
    
    //加载js文件
    NSString *path=[[NSBundle mainBundle] pathForResource:@"fun.js" ofType:nil];
    NSString *jsStr=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //加载js文件到页面
    [_myWebView stringByEvaluatingJavaScriptFromString:jsStr];
}

#pragma mark - WebView 代理方法
#pragma mark 页面加载前(此方法返回false则页面不再请求)
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if (_myWebView.canGoBack) {
        _closeBtn.hidden = NO;
    }

    
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@".."];
    NSString *fils = (NSString *)[components objectAtIndex:0];
    if (fils.length>14) {
        NSString *sssf = [fils substringWithRange:NSMakeRange(fils.length-14, 14)];
        if ([components count] > 1 && [sssf  isEqualToString:@"App.app_detail"]) {
            
            NSString *tmpStr = [components objectAtIndex:1];
            NSArray *myKeyArray = [tmpStr componentsSeparatedByString:@":"];
            NSString *myDetailType = [myKeyArray objectAtIndex:0];
            NSString *myDetailId = [myKeyArray objectAtIndex:1];
            
//            [self goDetail:myDetailType detailId:myDetailId];
            
            return NO;
        }else if ([components count] > 0 && [sssf  isEqualToString:@"user&act=login"]) {
            

            
            return NO;
        }
    }
    return true;
}

/*
- (void)goDetail:(NSString *)detailType detailId:(NSString *)detailId{
    
    Advs *advs = [[Advs alloc]init];
    advs.type = [detailType intValue];
    advs.data_id = [detailId intValue];
    advs.cate_id = [detailId intValue];
    [self didSelect:advs];
    
}

-(void)didSelect:(Advs *) advs{
    
    if ([AdJump didSelect:advs]) {
        [self.navigationController pushViewController:[AdJump didSelect:advs] animated:YES];
    }
    
}
*/
#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    if (progress == 0.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        _progressView.progress = 0;
        [UIView animateWithDuration:0.27 animations:^{
            _progressView.alpha = 1.0;
        }];
    }
    if (progress == 1.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [UIView animateWithDuration:0.27 delay:progress - _progressView.progress options:0 animations:^{
            _progressView.alpha = 0.0;
        } completion:nil];
    }
    
    [_progressView setProgress:progress animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
