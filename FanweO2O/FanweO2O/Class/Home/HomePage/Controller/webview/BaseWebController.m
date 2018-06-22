//
//  BaseWebController.m
//  FanweApp
//
//  Created by mac on 16/4/12.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "BaseWebController.h"
#import "ShoppingViewController.h"
#import "MJExtension.h"
#import "UIView+Extension.h"
#import "AFNetworkReachabilityManager.h"
#import "BaseNavigationController.h"
#import "RNCachingURLProtocol.h"
#import "PayModel.h"
#import "CLLockVC.h"
#import "shareModel.h"
#import "GlobalVariables.h"
#import "NetHttpsManager.h"
#import "UIDevice+IdentifierAddition.h"
#import "SDWebImageManager.h"
#import "NetErrorController.h"
#import "UMSocialWechatHandler.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ExtendNSDictionary.h"
#import "UMSocialWechatHandler.h"
#import "MyTool.h"
#import "MainTabBarController.h"
#import "SVProgressHUD.h"
#import "FanweMessage.h"
#import "UIBarButtonItem+Extension.h"
#import "O2OAccountLoginVC.h"
#import "cutPictureView.h"
#import "JSONKit.h"
#import "FWUMengShareManager.h"
#import "FWO2OJumpModel.h"
#import "FWO2OJump.h"
#import  <UShareUI/UShareUI.h>
#import "DiscoveryViewController.h"
#import "XNGoodsInfoModel.h"
#import "NTalkerChatViewController.h"
#import "UPPayPlugin.h"
#import "XNSDKCore.h"
#import "XNUserBasicInfo.h"
#import "MessageCenterViewController.h"

#import <AlipaySDK/AlipaySDK.h>
#import "Aliapp.h"
#import "Mwxpay.h"
#import "WXApi.h"
#import "UPpay.h"

#define CAMERA 0
#define ALBUM 1
#define kImgSize 8000 //头像大小
#define kImgFrameDec 50

#define kResult @"支付结果：%@"
#define kMode_Development @"01" //银联 开发环境
#define kMode_Production @"00" //银联 生产环境

@interface BaseWebController ()<UPPayPluginDelegate>{
    
    int             _loadTimeCount;     //计算webview加载页面的时间
    CGFloat _headImgWH;
    NSData *_headImgData;
   
}



@property (strong, nonatomic) UIProgressView *progressView;

@end

@implementation BaseWebController

+ (void)initialize {
    
    NSString *sdk_guid = [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
    
    GlobalVariables *fanweApp = [GlobalVariables sharedInstance];
    NSString *userAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *customUserAgent = [userAgent stringByAppendingFormat:[NSString stringWithFormat:@" fanwe_app_sdk sdk_type/ios sdk_version_name/%@ sdk_version/%@ sdk_guid/%@ screen_width/%@ screen_height/%@",VersionNum,VersionTime,sdk_guid,[NSString stringWithFormat:@"%f",kScaleW],[NSString stringWithFormat:@"%f",kScaleH]],nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":customUserAgent}];
    
}

+(instancetype)webControlerWithUrlString:(NSString *)urlStr andNavTitle:(NSString *)navTitle isShowIndicator:(BOOL)isShowIndicator isHideNavBar:(BOOL)isHideNavBar{
    
    BaseWebController *control=[[BaseWebController alloc]init];
    control.urlString = urlStr;
    control.isHideNavBar = isHideNavBar;
    control.isShowBack = YES;
    control.navTitle = navTitle;
    control.isShowIndicator = isShowIndicator;
    return control;
}

+(instancetype)webControlerWithUrlString:(NSString *)urlStr andNavTitle:(NSString *)navTitle isShowIndicator:(BOOL)isShowIndicator isHideNavBar:(BOOL)isHideNavBar isHideTabBar:(BOOL)isHideTabBar
{
    BaseWebController *control=[[BaseWebController alloc]init];
    control.urlString = urlStr;
    control.isHideNavBar = isHideNavBar;
    control.isShowBack = YES;
    control.navTitle = navTitle;
    control.isShowIndicator = isShowIndicator;
    control.isHideTabBar = isHideTabBar;
    return control;
}

+(instancetype)webControlerWithUrlString:(NSString *)url andIsShowLaunchImgView:(BOOL)isShowLaunchImgView{
    
    BaseWebController *control=[[BaseWebController alloc]init];
    control.urlString = url;
    control.isShowLaunchImgView = isShowLaunchImgView;
    return control;
    
}

+(instancetype)webControlerWithWebView:(WKWebView *)webView{
    BaseWebController *control=[[BaseWebController alloc]init];
    control.webView=webView;
    return control;
}

- (BOOL)prefersStatusBarHidden{
    if (_fanweApp.appModel.statusbar_hide == 1) {
        return YES;
    }else{
        return NO;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    if (_isBackReload)
    {
        [self.webView reload];
         [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    if (_isHideNavBar) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    
    if (_isShowLaunchImgView && _isFirstLoad) {
        _isShowLaunchImgView = NO;
        _launchImgView.hidden = NO;
    }else{
        _launchImgView.hidden = YES;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_isHideNavBar || _isRegist) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.navTitle;
    
    _isFirstLoad = YES;
    
    //_launchImgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //[_launchImgView setImage:[UIImage imageNamed:@"wel"]];
    //[self.view addSubview:_launchImgView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadWebView) name:@"reloadWebView" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(configApns) name:@"getDeviceTokenComplete" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wepayResult:) name:FW_O2O_WX_PAY_RESULT_MSG object:nil];


    
    if ([self.urlString rangeOfString:API_LOTTERYOUT_URL].location == NSNotFound) {
        self.isHideNavBar = NO;
    }
    
    if (_isShowBack)
    {
        self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(comeBack) image:@"ic_me_up" highImage:@"ic_me_up"];
    }
    if (_isFront) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    
    //初始化MBProgressHUD
    //_HUD = [[MBProgressHUD alloc] initWithView:self.view];
    //[self.view addSubview:_HUD];
    //[_HUD show:YES];
    
    [NSURLProtocol registerClass:[RNCachingURLProtocol class]];
    
    if ([_fanweApp.appModel.statusbar_color length]>0)
    {
        NSMutableString *statusbar_color = [NSMutableString stringWithString:_fanweApp.appModel.statusbar_color];
        if ([statusbar_color hasPrefix:@"#"]) {
            [statusbar_color deleteCharactersInRange:NSMakeRange(0,1)];
        }
        
        unsigned int hexValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:statusbar_color];
        [scanner setScanLocation:0]; // depends on your exact string format you may have to use location 1
        [scanner scanHexInt:&hexValue];
        self.view.backgroundColor = RGBOF(hexValue);
    }else{
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    //获取cookie
    NSString *cookieStr = @"document.cookie = ";
    NSString *cookieStr2 = @"";
    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:kMyCookies];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            if (![cookie.name isEqualToString:@""] && ![cookie.value isEqualToString:@""] ) {
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
                cookieStr = [cookieStr stringByAppendingString:[NSString stringWithFormat:@"'%@=%@';", [cookie name],[cookie value]]];
                cookieStr2 = [cookieStr2 stringByAppendingString:[NSString stringWithFormat:@"%@=%@;", [cookie name],[cookie value]]];
                //_fanweApp.session_id = [cookie value];

            }
        }
    }
    
    //1创建webView
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]
                                             init];
    
    WKUserContentController *controller = [[WKUserContentController alloc]
                                           init];
    
    [controller addScriptMessageHandler:self name:@"getClipBoardText"];
    [controller addScriptMessageHandler:self name:@"sdk_share"];
    [controller addScriptMessageHandler:self name:@"CutPhoto"];
    [controller addScriptMessageHandler:self name:@"open_type"];
    [controller addScriptMessageHandler:self name:@"pay_sdk"];
    [controller addScriptMessageHandler:self name:@"login_success"];
    [controller addScriptMessageHandler:self name:@"logout"];
    [controller addScriptMessageHandler:self name:@"apns"];
    [controller addScriptMessageHandler:self name:@"position"];
    [controller addScriptMessageHandler:self name:@"position2"];
    [controller addScriptMessageHandler:self name:@"qr_code_scan"];
    [controller addScriptMessageHandler:self name:@"restart"];
    [controller addScriptMessageHandler:self name:@"login_sdk"];
    [controller addScriptMessageHandler:self name:@"is_exist_installed"];
    [controller addScriptMessageHandler:self name:@"create_live"];
    [controller addScriptMessageHandler:self name:@"join_live"];
    [controller addScriptMessageHandler:self name:@"updateCookies"];
    [controller addScriptMessageHandler:self name:@"start_app_page"];
    
    [controller addScriptMessageHandler:self name:@"app_detail"];
    [controller addScriptMessageHandler:self name:@"app_refresh"];
    [controller addScriptMessageHandler:self name:@"third_party_login_sdk"];
    
    
    [controller addScriptMessageHandler:self name:@"page_finsh"];       //回退
    [controller addScriptMessageHandler:self name:@"getuserinfo"];      //获取用户信息
    [controller addScriptMessageHandler:self name:@"js_getuserinfo"];   //获取用户信息
    [controller addScriptMessageHandler:self name:@"save_image"];
    [controller addScriptMessageHandler:self name:@"xnOpenSdk"];
    
    
//    WKUserScript * cookieScript;
//    if ([cookiesdata length])
//    {
//        cookieScript = [[WKUserScript alloc]
//                        initWithSource: cookieStr
//                        injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
//    }else{
//        cookieScript = [[WKUserScript alloc] initWithSource:@"window.webkit.messageHandlers.updateCookies.postMessage(document.cookie);"
//                                              injectionTime:WKUserScriptInjectionTimeAtDocumentStart
//                                           forMainFrameOnly:NO];
//    }
//    [controller addUserScript:cookieScript];
    configuration.userContentController = controller;
    
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:configuration];
   
    
    if (_isHideNavBar) {
        if (_isShowBack || _fanweApp.appModel.statusbar_hide == 1) {
            self.webView.y = 0;
        }else{
            self.webView.y = 20;
            self.webView.height = self.webView.height-20;
        }
    }else{
        self.webView.height = kScreenH-kStatusBarHeight-kNavigationBarHeight;
    }
    
    if (_isHideTabBar && _isHideNavBar)
    {
        self.webView.y=20;
        //self.view.height = kScreenH-kStatusBarHeight;
        self.webView.height = kScreenH-kStatusBarHeight;
        
    }else{
        if(_isHideTabBar)
        {
            self.webView.height = kScreenH-kStatusBarHeight-kNavigationBarHeight;
        }
        if(_isHideNavBar)
        {
            self.webView.height = kScreenH-kStatusBarHeight-kTabBarHeight;
        }
    }
    

    
    [self.view addSubview:self.webView];
    UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 44, SCREEN_HEIGHT / 2 - 50, 88, 100)];
    imgv.image = [UIImage imageNamed:@"loading_img"];
    imgv.contentMode= UIViewContentModeScaleAspectFit;
    UILabel *loadL = [[UILabel alloc]initWithFrame:CGRectMake(21, 100, 88, 10)];
    loadL.text =@"加载中...";
    loadL.font =[UIFont systemFontOfSize:15];
    [imgv addSubview:loadL];
    [self.view addSubview:imgv];
    
    self.loadingImgView = imgv;
    
//    self.webView.scrollView.bounces=NO;
    self.webView.scrollView.showsHorizontalScrollIndicator=NO;
    self.webView.scrollView.showsVerticalScrollIndicator=NO;
    self.webView.navigationDelegate=self;
     self.webView.UIDelegate = self;
    //加载主页
    [self loadMyView];
    
    [self.webView reload];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    
    // 进度条
    UIProgressView *progressView = [[UIProgressView alloc] init];
    progressView.tintColor = [UIColor colorWithRed:250/255.0f green:100/255.0f blue:100/255.0f alpha:1];
    progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        if (_isHideNavBar) {
            make.top.equalTo(self.view.mas_top).with.offset(20);
        }else {
            make.top.equalTo(self.view.mas_top).with.offset(0);
        }
        
    }];
    
    self.progressView = progressView;
    
    
    UIImageView *imageView = [UIImageView imageViewWithImage:[UIImage imageNamed:@"o2o_html_icon"]];
    imageView.tag = 12345;
    //[self.view addSubview:imageView];
    //[self.view bringSubviewToFront:imageView];
    
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).with.offset(0);
//        make.right.equalTo(self.view.mas_right).with.offset(0);
//        make.top.equalTo(self.view.mas_top).with.offset(0);
//        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
//    }];
    
    [self.view bringSubviewToFront:self.progressView];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{

    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        self.loadingImgView.hidden = newprogress != 0 ? YES : NO;
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
            UIImageView *image = [self.view viewWithTag:12345];
            if (image) {
                [image removeFromSuperview];
            }
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
  /*
            if (newprogress > 0.9 ) {
                UIImageView *image = [self.view viewWithTag:12345];
                if (image) {
                    [image removeFromSuperview];
                }
            }
            NSLog(@"newprogress = %lf",newprogress);
   */         
        }
        if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
            
            return;
        }
        if ([change[@"new"] floatValue] == 1) {
           
            HideIndicatorInView(self.view);
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
#pragma mark 加载主页
- (void)loadMyView{
    //ShowIndicatorTextInView(self.view,@"");

    if ([self.urlString rangeOfString:API_LOTTERYOUT_URL].location != NSNotFound) {
        if ([self.fanweApp.session_id length] == 0) {
            self.urlString = [NSString stringWithFormat:@"%@%@",self.urlString,WEB_BASE_INFO];
        }else {
            self.urlString = [NSString stringWithFormat:@"%@&sess_id=%@%@",self.urlString,self.fanweApp.session_id,WEB_BASE_INFO];
        }
        
    }
    
    NSString *date = [self.urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:date]];
    [request setHTTPMethod: @"GET"];
    request.timeoutInterval = kWebViewTimeoutInterval; // 设置请求超时
    [self.webView loadRequest:request];
}

#pragma mark 加载错误页面
- (void)reloadWebView{
    
    _isLoadError = NO;
    
    [self loadMyView];
}

#pragma mark 后台进入前台刷新
-(void)onForeground
{
    [self.webView reload];
}

#pragma mark js请求oc
- (void)evaluateMyJavaScript:(WKWebView *)webView{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"fun.js" ofType:nil];
    NSString *jsStr=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [webView evaluateJavaScript:jsStr completionHandler:nil];
}

#pragma mark- webview生命周期相关函数
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
    [self evaluateMyJavaScript:webView];
    
    NSString *curUrl = [webView.URL absoluteString];
    NSLog(@"加载URL==%@",webView.URL);
    NSMutableString *curMstr = [NSMutableString stringWithString:curUrl];
    NSRange curSubstr = [curMstr rangeOfString:@"show_prog=1"]; //字符串查找,可以判断字符串中是否有
    if (curSubstr.location != NSNotFound || [curUrl hasSuffix:@"show_prog=1"] || _isShowIndicator) {
        [_HUD show:YES];
    }
    
    //判断是否拨打电话
    if ([curUrl hasPrefix:@"tel:"])
    {
        
        NSMutableString *mstr = [NSMutableString stringWithString:curUrl];
        //查找并删除
        NSRange substr = [mstr rangeOfString:@"tel:"]; //字符串查找,可以判断字符串中是否有
        if (substr.location != NSNotFound) {
            [mstr deleteCharactersInRange:substr];
        }
        NSString *telUrl = [NSString stringWithFormat:@"telprompt:%@",mstr];
        NSURL *url = [[NSURL alloc] initWithString:telUrl];
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark 加载出错
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"%s",__func__);
    
    if([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus<1 && !_isLoadError && !_isFirstLoad)
    {
        _isFirstLoad = NO;
        [FanweMessage alert:@"亲，您的网络状况不大好哦！"];
    }else
    {
        [self performSelector:@selector(loadErrorView) withObject:nil afterDelay:2];
    }
    [NSURLProtocol unregisterClass:[RNCachingURLProtocol class]];
} 

- (void)loadErrorView{
    //[_HUD setHidden:YES];
    
    SDWebImageManager *mgr=[SDWebImageManager sharedManager];
    [mgr.imageCache clearMemory];
    [mgr.imageCache clearDiskOnCompletion:nil];
    //[mgr.imageCache cleanDisk];
    
    _isLoadError = YES;
    
    NetErrorController *tmpController = [[NetErrorController alloc]init];
    
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:tmpController];
    
    [self addChildViewController:nav];
    nav.view.frame=self.view.bounds;
    nav.view.x=self.view.width;
    [self.view addSubview:nav.view];
    [UIView animateWithDuration:0.5 animations:^{
        nav.view.x=0;
    }];
}

#pragma mark 加载完毕
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    _loadTimeCount = 0;
    
    _launchImgView.hidden = YES;
    NSLog(@"%s",__func__);
    
    _isFirstLoad = NO;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=false;
    
    [self evaluateMyJavaScript:webView];
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:nil];
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    
    if (!_navTitle || [_navTitle isEqualToString:@""]) {
        self.navigationItem.title = webView.title;
    }
    
    [self hideMyHud];
    
    [NSURLProtocol unregisterClass:[RNCachingURLProtocol class]];
    
    //[self saveCookie:webView];
    
}
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    [self.webView reload];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    //[self myUserContentController:userContentController didReceiveScriptMessage:message];
    if ([message.name isEqualToString:@"page_finsh"])         // 回退
    {
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if ([message.name isEqualToString:@"login_sdk"]) {
        
        _fanweApp.is_login = NO;
        O2OAccountLoginVC *vc = [[O2OAccountLoginVC alloc] initWithNibName:@"O2OAccountLoginVC" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([message.name isEqualToString:@"logout"]) {
        
        _fanweApp.is_login = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:FW_O2O_ACCOUNT_LOGOUT_SUCCESS
                                                            object:nil
                                                          userInfo:nil];
    }else if ([message.name isEqualToString:@"app_detail"]) {
        NSArray *components = [message.body componentsSeparatedByString:@".."];
        NSString *fils = (NSString *)[components objectAtIndex:0];
        NSString *sssf = [fils substringWithRange:NSMakeRange(fils.length-14, 14)];
        
        if ([components count] > 1 && [sssf  isEqualToString:@"App.app_detail"]) {
            NSString *tmpStr = [components objectAtIndex:1];
            
            NSArray *myKeyArray = [tmpStr componentsSeparatedByString:@":"];
            NSString *myDetailType = [myKeyArray objectAtIndex:0];
            NSString *myDetailId = [myKeyArray objectAtIndex:1];
            
            if ([myDetailType intValue] == 1) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
                
                self.tabBarController.selectedIndex = 0;
                
            }else if([myDetailType intValue] == 105){
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [self.navigationController pushViewController:[DiscoveryViewController new] animated:YES];
                });
                
//                self.tabBarController.selectedIndex = 1;
            }else if([myDetailType intValue] == 106){
                
                ShoppingViewController *shop = [ShoppingViewController webControlerWithUrlString:nil andNavTitle:nil isShowIndicator:NO isHideNavBar:YES isHideTabBar:NO];
                [[AppDelegate sharedAppDelegate] pushViewController:shop];
                /*
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });*/
                //[self.navigationController popToRootViewControllerAnimated:YES];
                //self.tabBarController.selectedIndex = 2;
                
            }else if([myDetailType intValue] == 107){
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
                //[self.navigationController popToRootViewControllerAnimated:YES];
                self.tabBarController.selectedIndex = 3;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:FW_O2O_MYWEBVIEW_REFRESH_MSG
                                                                    object:nil
                                                                  userInfo:nil];
            }else if ([myDetailType intValue] ==108)
            {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController pushViewController:[MessageCenterViewController new] animated:YES];
                });
            }
            
            else if([myDetailType intValue] == 308){
                
                
                FWO2OJumpModel *jump = [FWO2OJumpModel new];
                jump.type = 308;
                
                if (myKeyArray.count >= 3) {
                    jump.data_id = [myKeyArray objectAtIndex:2];
                }
                
                
                [FWO2OJump didSelect:jump];

                
                //NSLog(@"%@",dic);
                //[[HUDHelper sharedInstance] tipMessage:@"调用订单详情"];
            }
            else
            {
                
                FWO2OJumpModel *jump = [FWO2OJumpModel new];
                jump.type = [myDetailType intValue];
                
                
                if (myKeyArray.count >= 3) {
                    jump.data_id = [myKeyArray objectAtIndex:2];
                }
                jump.isHideTabBar = YES;

                jump.isHideNavBar = YES;
                [FWO2OJump didSelect:jump];
            }
            
        }
        
    }else if ([message.name isEqualToString:@"app_refresh"]) {
        
        [self loadMyView];

    }else if ([message.name isEqualToString:@"sdk_share"]){
        
        [self sdk_shareWithDic:[self backDic:message.body]];
        
    }else if ([message.name isEqualToString:@"third_party_login_sdk"]) {
        
        [self myUserContentController:userContentController didReceiveScriptMessage:message];
        
    }else if ([message.name isEqualToString:@"save_image"]) {
        
        [self saveImageToPhotos:message.body];
        //[self saveImage:[UIImage ] WithName:<#(NSString *)#>]
        
    }else if([message.name isEqualToString:@"CutPhoto"]) {
        
        [self CutPhotoWithDic:[self backDic:message.body]];
        
    }else if ([message.name isEqualToString:@"position"]) {
        //传经纬度给服务端，没有则传0，0；
//        NSString *string =[NSString stringWithFormat:@"js_position('%f','%f')",_fanweApp.latitude,_fanweApp.longitude];
        
        
        NSString *string = [NSString stringWithFormat:@"js_position('%f','%f')",_fanweApp.latitude,_fanweApp.longitude];
        [self.webView evaluateJavaScript:string completionHandler:nil];
        
    }else if ([message.name isEqualToString:@"open_type"]) {
        //支付
        //NSDictionary *dic = message.body;
        //NSLog(@"%@",dic);
        NSDictionary *dic = [self backDic:message.body];
        NSInteger open_type = [dic toInt:@"open_url_type"];
        if (open_type == 0 ) {
            //打开内部链接
            NSString *url = [dic toString:@"url"];
            
            if (url.length > 0) {
                FWO2OJumpModel *jump = [FWO2OJumpModel new];
                jump.type = 0;
                jump.isHideTabBar = YES;
                jump.url = url;
                jump.name = [dic toString:@"title"];
                jump.isHideNavBar = NO;
                [FWO2OJump didSelect:jump];
            }
            
        }else {
            //打开外部链接
            NSString *url = [dic toString:@"url"];
            if (url.length > 0) {
                url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *urlss = [NSURL URLWithString:url];
                
                [[UIApplication sharedApplication] openURL:urlss];
            }
            
        }
        
    }else if ([message.name isEqualToString:@"pay_sdk"]) {
        
        //[[HUDHelper sharedInstance] tipMessage:@"调用支付"];
        NSDictionary *dic = [self backDic:message.body];
        [self payWithDict:dic];
        NSLog(@"%@",dic);
        
    }else if ([message.name isEqualToString:@"xnOpenSdk"]) {
        
        NSDictionary *dic = [self backDic:message.body];
        //[[HUDHelper sharedInstance] tipMessage:message.body delay:5];
        [self xnOpenSdk:dic];
    }
}

#pragma mark sdk支付
- (void)payWithDict:(NSDictionary *)dict{
    
    NSString *pay_sdk_type = [dict toString:@"pay_sdk_type"];
    NSDictionary *config = [dict objectForKey:@"config"];
    
    if ([pay_sdk_type isEqualToString:@"alipay"]) { //支付宝sdk支付
        
        Aliapp *aliapp = [Aliapp mj_objectWithKeyValues:config];
        [self payWithAliapp:aliapp];
    }else if([pay_sdk_type isEqualToString:@"baofoo"]){ //宝付sdk支付
        PayModel *payModel=[PayModel mj_objectWithKeyValues:config];
        [self payWithBaoFoo:payModel];
    }else if([pay_sdk_type isEqualToString:@"wxpay"]){ //微信sdk支付
        Mwxpay *wwxpay=[Mwxpay mj_objectWithKeyValues:config];
        [self payWithWxpay:wwxpay];
    }else if([pay_sdk_type isEqualToString:@"uppay"]){ //银联sdk支付
        UPpay *uPpay=[UPpay mj_objectWithKeyValues:config];
        [self payWithUPpay:uPpay];
    }
    
}

#pragma mark 各个sdk支付方式支付结果后调用js
- (void)js_pay_sdk:(NSInteger)resultStatus{
    NSString *jsStr=[NSString stringWithFormat:@"js_pay_sdk('%ld')",(long)resultStatus];
    [self.webView evaluateJavaScript:jsStr completionHandler:nil];
}

#pragma mark 支付宝sdk支付
-(void) payWithAliapp:(Aliapp *) aliapp{
    
    //    if (aliapp.order_spec == nil || [aliapp.order_spec isEqualToString:@""]) {
    //        [self js_pay_sdk:6];
    //        [FanweMessage alert:@"order_spec为空"];
    //        return;
    //    }else if (aliapp.sign == nil || [aliapp.sign isEqualToString:@""]) {
    //        [self js_pay_sdk:6];
    //        [FanweMessage alert:@"sign为空"];
    //        return;
    //    }
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types

    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                             aliapp.order_spec, aliapp.sign, @"RSA"];
    
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:AlipayScheme callback:^(NSDictionary *resultDic) {
        //9000	订单支付成功
        //8000	正在处理中
        //4000	订单支付失败
        //6001	用户中途取消
        //6002	网络连接出错
        NSLog(@"reslut = %@",resultDic);
        NSInteger myResultStatus;
        NSInteger resultStatus = [resultDic toInt:@"resultStatus"];
        if (resultStatus == 9000) {
            myResultStatus = 1;
        }else if (resultStatus == 8000){
            myResultStatus = 2;
        }else if (resultStatus == 4000){
            myResultStatus = 3;
        }else if (resultStatus == 6001){
            myResultStatus = 4;
        }else if (resultStatus == 6002){
            myResultStatus = 5;
        }
        [self js_pay_sdk:myResultStatus];
    }];
}

#pragma mark 宝付sdk支付
-(void) payWithBaoFoo:(PayModel *)payModel{
    
    //    if (payModel.config.tradeNo != nil) {
    //        [self.HUD show:YES];
    //        BaoFooPayController *web = [[BaoFooPayController alloc] init];
    //        web.delegate = self;
    //        web.PAY_TOKEN = payModel.config.tradeNo;
    //        if([payModel.config.is_debug intValue]== 1){
    //            web.PAY_BUSINESS = @"fals";
    //        }else{
    //            web.PAY_BUSINESS = @"true";
    //        }
    //        [self presentViewController:web animated:YES completion:^{
    //            [self.HUD setHidden:YES];
    //        }];
    //    }
    
}

#pragma mark 微信支付
-(void) payWithWxpay:(Mwxpay *) mwxpay{
    
    if (mwxpay.appid == nil || [mwxpay.appid isEqualToString:@""]) {
        [self js_pay_sdk:6];
        [FanweMessage alert:@"appid为空"];
        return;
    }else if (mwxpay.partnerid == nil || [mwxpay.partnerid isEqualToString:@""]) {
        [self js_pay_sdk:6];
        [FanweMessage alert:@"partnerid为空"];
        return;
    }else if (mwxpay.prepayid == nil || [mwxpay.prepayid isEqualToString:@""]) {
        [self js_pay_sdk:6];
        [FanweMessage alert:@"prepayid为空"];
        return;
    }else if (mwxpay.noncestr == nil || [mwxpay.noncestr isEqualToString:@""]) {
        [self js_pay_sdk:6];
        [FanweMessage alert:@"noncestr为空"];
        return;
    }else if (mwxpay.timestamp == nil || [mwxpay.timestamp isEqualToString:@""]) {
        [self js_pay_sdk:6];
        [FanweMessage alert:@"timestamp为空"];
        return;
    }else if (mwxpay.packagevalue == nil || [mwxpay.packagevalue isEqualToString:@""]) {
        [self js_pay_sdk:6];
        [FanweMessage alert:@"packagevalue为空"];
        return;
    }else if (mwxpay.sign == nil || [mwxpay.sign isEqualToString:@""]) {
        [self js_pay_sdk:6];
        [FanweMessage alert:@"sign为空"];
        return;
    }
    
    PayReq* req = [[PayReq alloc] init];
    req.openID = mwxpay.appid;
    req.partnerId = mwxpay.partnerid;
    req.prepayId = mwxpay.prepayid;
    req.nonceStr = mwxpay.noncestr;
    req.timeStamp = [mwxpay.timestamp intValue];
    req.package = mwxpay.packagevalue;
    req.sign = mwxpay.sign;
    [WXApi sendReq:req];
    
}

#pragma mark 银联支付
-(void) payWithUPpay:(UPpay *) uPpay{
    
    if (uPpay.tn == nil || [uPpay.tn isEqualToString:@""]) {
        [self js_pay_sdk:6];
        [FanweMessage alert:@"tn为空"];
        return;
    }
    
    if (uPpay.tn != nil && uPpay.tn.length > 0)
    {
        [UPPayPlugin startPay:uPpay.tn mode:kMode_Development viewController:self delegate:self];
    }
    
}

#pragma mark UPPayPluginResult
- (void)UPPayPluginResult:(NSString *)result
{
    NSInteger myResultStatus;
    if ([result isEqualToString:@"success"]) {
        myResultStatus = 1;
    }else if ([result isEqualToString:@"fail"]) {
        myResultStatus = 3;
    }else if ([result isEqualToString:@"cancel"]) {
        myResultStatus = 4;
    }
    [self js_pay_sdk:myResultStatus];
    
    NSString* msg = [NSString stringWithFormat:kResult, result];
    
    [FanweMessage alert:msg];
}





-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==CAMERA) {
        [self openCamera];
    }else if(buttonIndex==ALBUM){
        [self openAlbum];
    }
   
}
#pragma mark 裁剪图片
-(void)CutPhotoWithDic:(NSDictionary *)dict
{
    shareModel *model=[shareModel mj_objectWithKeyValues:dict];
    [self showControllerWithModel:model];

}

-(void)showControllerWithModel:(shareModel *)model{
    
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"相册", nil];
    
    [sheet showInView:self.view];
    
    CGSize size;
    if ([model.w intValue]>300) {
        size=CGSizeMake([model.w intValue]*0.6, [model.h intValue]*0.6);
    }else if([model.w intValue]>170){
        size=CGSizeMake([model.w intValue], [model.h intValue]);
    }else if([model.w intValue]>110){
        size=CGSizeMake([model.w intValue]*1.5, [model.h intValue]*1.5);
    }else{
        size=CGSizeMake([model.w intValue]*2, [model.h intValue]*2);
    }
    _size=size;
    
}

#pragma mark 裁剪图片回调js
-(void)imageDidCut:(UIImage *)image{
    
    NSData *data=UIImageJPEGRepresentation(image, 1.0);
    NSString *base64Data=[data base64EncodedStringWithOptions:0];
    NSString *jsStr=[NSString stringWithFormat:@"CutCallBack(\"data:image/jpg;base64,%@\")",base64Data];
    [self.webView evaluateJavaScript:jsStr completionHandler:nil];
}

#pragma mark 获取剪切板回调js
-(void)copyString{
    
    UIPasteboard *pastedBoard=[UIPasteboard  generalPasteboard];
    NSString *jsStr=[NSString stringWithFormat:@"get_clip_board(\"%@\")",pastedBoard.string];
    
    [self.webView evaluateJavaScript:jsStr completionHandler:^(NSString *result, NSError *error)
     {
         NSLog(@"Error %@",error);
         NSLog(@"Result %@",result);
     }];
}

#pragma mark 调用相机
-(void)openCamera{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        return;
    
    UIImagePickerController * ImagePicker=[[UIImagePickerController alloc]init];
    ImagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
    ImagePicker.delegate=self;
    
    [self presentViewController:ImagePicker animated:YES completion:nil];
}

#pragma mark 打开图片
-(void)openAlbum{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        return;
    
    UIImagePickerController * ImagePicker=[[UIImagePickerController alloc]init];
    ImagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    ImagePicker.delegate=self;
    [self presentViewController:ImagePicker animated:YES completion:nil];
}

//上传头像
- (void)uploadAvatar:(NSData*)data{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    
    [parmDict setObject:@"uc_account" forKey:@"ctl"];
    [parmDict setObject:@"upload_avatar" forKey:@"act"];
    
//    [self.httpsManager startAsynImageResponse:parmDict];
//    [[NetHttpsManager manager] imageResponse:parmDict imageData:data SuccessBlock:^(NSDictionary *responseJson) {
//        NSLog(@"%@",responseJson);
//        
//    } FailureBlock:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
    self.isImageLoad = YES;
    [self.httpsManager imageResponse:parmDict imageData:data SuccessBlock:^(NSDictionary *responseJson) {
//        NSData *jsonData =[NSJSONSerialization dataWithJSONObject:responseJson options:NSJSONWritingPrettyPrinted error:nil];
//      NSString *str =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *str =responseJson[@"big_url"];
    NSString *jsStr=[NSString stringWithFormat:@"CutCallBack('%@')",str];
        [self.webView evaluateJavaScript:jsStr completionHandler:nil];
    } FailureBlock:^(NSError *error) {
        
    }];
    
}
#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    //通过UIImagePickerControllerOriginalImage获取图片
//    UIImage *image=info[@"UIImagePickerControllerOriginalImage"];
//        cutPictureView *cutPicture=[cutPictureView cutPicture];
//        cutPicture.control=self;
//        cutPicture.size=_size;
//        cutPicture.image=image;
//        cutPicture.delegate = self;
//        [self.view addSubview:cutPicture];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (!image){
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
//    //压缩图片宽高
//    CGSize imagesize = image.size;
//    imagesize.height = _headImgWH;
//    imagesize.width = _headImgWH;
//    UIImage *theImage = [self imageWithImageSimple:image scaledToSize:imagesize];
    //压缩图片质量
    _headImgData = UIImageJPEGRepresentation(image,0.00001);
  
    //循环压缩
//    while ([_headImgData length]>kImgSize && _headImgWH>kImgFrameDec) {
//        [self cyclicCompression:image];
//    }
//    UIImage *uploadImage = [UIImage imageWithData:_headImgData];
    
//    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:_HUD];
//    _HUD.labelText = @"上传头像中...";
//    _HUD.delegate = self;
//    [_HUD show:YES];
    
//    [self saveImage:uploadImage WithName:@"image_head.jpg"];
    [self performSelector:@selector(uploadAvatar:) withObject:_headImgData ];

}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
        UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
         [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
         UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
         UIGraphicsEndImageContext();
         NSLog(@"%@",NSStringFromCGSize(scaledImage.size));
         return scaledImage;
}

- (void)cyclicCompression:(UIImage *)image{
    _headImgWH -= kImgFrameDec;
    CGSize imagesize = image.size;
    imagesize.height = _headImgWH;
    imagesize.width = _headImgWH;
    UIImage *theImage = [self imageWithImageSimple:image scaledToSize:imagesize];
    _headImgData = UIImageJPEGRepresentation(theImage,0.00001);
}

//压缩图片尺寸
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

//#pragma mark 保存图片到document
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
//    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 分享
-(void)sdk_shareWithDic:(NSDictionary *)dict{
    shareModel *model=[shareModel mj_objectWithKeyValues:dict];
    //    [self shareWithModel:model];
    [[FWUMengShareManager sharedInstance] showShareViewInControllr:self shareModel:model succ:nil failed:nil];
//    [self openShare:model];
}

//-(void)shareWithModel:(shareModel *)model{
//
//    _myShareModel = model;
//
//    self.share_key=model.share_key;
//
//    NSString *share_content;
//    if (![model.share_content isEqualToString:@""]) {
//        share_content = model.share_content;
//    }else{
//        share_content = model.share_title;
//    }

//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:[_fanweApp getConfigValueFromKey:@"umeng_key"]
//                                      shareText:share_content
//                                     shareImage:model.share_imageUrl
//                                shareToSnsNames:_umengSnsArray
//                                       delegate:self];
//}

//- (void)openShare:(shareModel *)model
//{
//    
//    
//    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_Qzone)]];
//    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//        _myShareModel =model;
//        self.share_key =model.share_key;
//        [self shareTextToPlatformType:platformType shareModel:_myShareModel];
//        
//    }];
//}

//- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType shareModel:(shareModel *)model
//{
//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    
//    UMShareWebpageObject *shareObject =[UMShareWebpageObject shareObjectWithTitle:model.share_title descr:model.share_content thumImage:model.share_imageUrl];
//    shareObject.webpageUrl =model.share_url;
//    messageObject.shareObject =shareObject;
//    
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//        if (error) {
//            NSLog(@"************Share fail with error %@*********",error);
//        }else{
//            NSLog(@"response data is %@",data);
////            NSString *jsStr=[NSString stringWithFormat:@"share_compleate(\"%d\")",[self.share_key intValue]];
////            [self.webView evaluateJavaScript:jsStr completionHandler:nil];
//        }
//    }];
//}
- (void)myUserContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
}

#pragma mark 解析json
- (NSDictionary *)backDic:(NSString *)jsonStr{
    
    NSError *error;
    NSData *data=[jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    if (data==nil) {
        NSLog(@"解析失败");
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        return dic;
    }
    return nil;
}

#pragma mark 获取usersig并登录IM
- (void)saveCookie:(WKWebView *)webView{
    //    //获取cookie
    //    NSArray *cookies2 = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    //    for (NSHTTPCookie *tempCookie in cookies2) {
    //        //打印获得的cookie
    //        NSLog(@"=====获取全部 COOKIE：COOKIE{name: %@, value: %@}", [tempCookie name], [tempCookie value]);
    //    }
    //
    NSHTTPCookie *sessinCookie;
    NSHTTPCookieStorage *sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [sharedHTTPCookieStorage cookiesForURL:webView.URL];
    NSEnumerator *enumerator = [cookies objectEnumerator];
    NSHTTPCookie *cookie;
    while (cookie = [enumerator nextObject]) {
        if (![cookie.name isEqualToString:@""] && ![cookie.value isEqualToString:@""] ) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            if ([cookie.name isEqualToString:@"PHPSESSID2"]) {
                sessinCookie = cookie;
            }
        }
    }
    //当请求成共后调用如下代码, 保存Cookie
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kMyCookies];
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"%s",__func__);
//    if ( webView.backForwardList.backList.count>0) {
//        self.tabBarController.tabBar.hidden =YES;
//        webView.height +=kTabBarHeight;
//    }
    
    [self evaluateMyJavaScript:webView];
    
    if (_isFirstLoad)
    {
        [self performSelector:@selector(hideMyHud) withObject:nil afterDelay:5];
    }else{
        [self performSelector:@selector(hideMyHud) withObject:nil afterDelay:1.5];
    }
    _isFirstLoad = NO;
   
    //[self saveCookie:webView];
    
}

#pragma mrak
- (void)hideMyHud{
    //[_HUD setHidden: YES];
}

#pragma mark Decides whether to allow or cancel a navigation.
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    
    NSString *strRequest = [navigationAction.request.URL.absoluteString    stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"%@",strRequest);
    decisionHandler(WKNavigationActionPolicyAllow);
    
    
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
     decisionHandler(WKNavigationResponsePolicyAllow);
}

-(void)comeBack{
    
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)goBack{
    
    NSString*jsToGetHTMLSource =@"deal_left_app_msg()";
    [self.webView evaluateJavaScript:jsToGetHTMLSource completionHandler:nil];
    
}

#pragma mark 友盟推送
- (void)configApns{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"user" forKey:@"ctl"];
    [mDict setObject:@"apns" forKey:@"act"];
    if (_fanweApp.deviceToken && [_fanweApp.deviceToken isKindOfClass:[NSString class]]) {
        if (_fanweApp.deviceToken.length) {
            [mDict setObject:_fanweApp.deviceToken forKey:@"apns_code"];
        }
    }
    
    [_httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
        NSLog(@"===:%@",responseJson);
        
    } FailureBlock:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
}

- (void)saveImageToPhotos:(NSString *)urlString
{
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:urlString]];
    UIImage *image = [UIImage imageWithData:data]; // 取得图片
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
// 指定回调方法

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    
    NSString *msg = nil ;
    
    if(error != NULL){
        
        msg = @"保存图片失败" ;
        
    }else{
        
        msg = @"保存图片成功" ;
    
    }

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                          
                                                    message:msg
                          
                                                   delegate:self
                          
                                          cancelButtonTitle:@"确定"
                          
                                          otherButtonTitles:nil];
    [alert show];
    
}
- (void)dealloc{
    [(WKWebView *)self.view removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark 小能客服

- (void)xnOpenSdk:(NSDictionary *)dic {
    
    if ([[XNUserBasicInfo sharedInfo].shortUid length] == 0)
    {
        if (_fanweApp.user_id && _fanweApp.user_name)
        {
            NSString *userLevel = @"0";       // 用户级别。 普通用户“0”，VIP用户传“1”到“5”。（“0”为默认值）    【必填】
            [[XNSDKCore sharedInstance] loginWithUserid:_fanweApp.user_id  andUsername: _fanweApp.user_name andUserLevel: userLevel];
        }
    }
    
    XNGoodsInfoModel *info = [[XNGoodsInfoModel alloc] init];
    info.appGoods_type = @"1";
    info.clientGoods_type = @"1";
    info.goods_id = [dic toString:@"goods_id"];
    info.goods_URL = [dic toString:@"goods_URL"];
    
    NTalkerChatViewController *ctrl = [[NTalkerChatViewController alloc] init];
    ctrl.productInfo = info;
    ctrl.settingid = [dic toString:@"settingid"];
    ctrl.pageURLString  = [dic toString:@"goods_URL"];
    ctrl.pageTitle  = [dic toString:@"goodsTitle"];
    
    [[AppDelegate sharedAppDelegate] pushViewController:ctrl];
}

#pragma mark 微信支付回调

- (void)wepayResult:(NSNotification *)notification {
    
    NSString *object = notification.object;
    
    if ([object isEqualToString:@"success"]) {
        [self js_pay_sdk:1];
    }else {
        [self js_pay_sdk:4];
    }
}

@end
