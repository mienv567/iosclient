//
//  InteractiveWebController.m
//  FanweApp
//
//  Created by mac on 16/4/12.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "InteractiveWebController.h"
#import "PayModel.h"
#import "CLLockVC.h"
#import "shareModel.h"
#import "O2OAccountLoginVC.h"
#import "UIDevice+IdentifierAddition.h"
#import "SDWebImageManager.h"
#import "NetErrorController.h"
//#import "MyZBarController.h"
#import "UMSocialWechatHandler.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ExtendNSDictionary.h"
#import "Aliapp.h"
#import "Mwxpay.h"
#import "WXApi.h"
#import "UPpay.h"
#import "UMSocialWechatHandler.h"
#import "MyTool.h"
//#import "LivingModel.h"
#import "MainTabBarController.h"
//#import "AuctionItemdetailsViewController.h"
//#import "accountViewController.h"
#import "SVProgressHUD.h"
#import "FanweMessage.h"
#import <UShareUI/UShareUI.h>
#define CAMERA 0
#define ALBUM 1
#define MYRandomColor RGBColor(arc4random_uniform(255),arc4random_uniform(255),arc4random_uniform(255))
#define RGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]


@implementation InteractiveWebController

- (void)viewDidLoad {
    [super viewDidLoad];
//    ShowIndicatorTextInView(self.view,@"");
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxpayback:) name:@"wxpayback" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWebView) name:Fw_O2O_ACCOUNT_LOGIN_SUCCESS object:nil];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    
}
- (void)refreshWebView {
    
    [self loadMyView];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    
    HideIndicatorInView(self.view);
}

+(instancetype)webControlerWithUrlString:(NSString *)urlStr andNavTitle:(NSString *)navTitle isShowIndicator:(BOOL)isShowIndicator isHideNavBar:(BOOL)isHideNavBar isHideTabBar:(BOOL)isHideTabBar
{
    InteractiveWebController *control = [[InteractiveWebController alloc]init];
    control.urlString = urlStr;
    control.isHideNavBar = isHideNavBar;
    control.isShowBack = YES;
    control.navTitle = navTitle;
    control.isShowIndicator = isShowIndicator;
    control.isHideTabBar = isHideTabBar;
    return control;
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

- (void)hideMyHud {
//    HideIndicatorInView(self.view);
}

#pragma mark 退出登录
/**
 *  H5 退出直播
 *  1. IM 退出
 *  2. user——default  数据清空
 *  3.清空 cookieJar
 *  4.
 */
- (void)login_logoutDict:(NSDictionary *)dict
{

}

#pragma mark 获取PHPSESSID
- (void)updateCookies:(NSString *)cookieStr{
    
    if (cookieStr && ![cookieStr isEqualToString:@""]) {
        NSArray *arr = [cookieStr componentsSeparatedByString:@"="];
        if (arr) {
            if ([arr count]>1 && [arr[0] isEqualToString:@"PHPSESSID"]) {
                NSURL *url = [NSURL URLWithString:API_BASE_URL];

                //NSURL *url = [NSURL URLWithString:API_BASE_URL];
                // 設定 cookie
                NSHTTPCookie *cookie2 = [NSHTTPCookie cookieWithProperties:
                                         [NSDictionary dictionaryWithObjectsAndKeys:
                                          [url host], NSHTTPCookieDomain,
                                          [url path], NSHTTPCookiePath,
                                          arr[0], NSHTTPCookieName,
                                          arr[1], NSHTTPCookieValue,
                                          nil]];
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie2];
            }
        }
    }
}

#pragma mark 扫码
- (void)qr_code_scanWithDic:(NSDictionary *)dict{
    
//    MyZBarController *tmpController = [[MyZBarController alloc]init];
//    tmpController.delegate = self;
//    ANNavController *nav=[[ANNavController alloc] initWithRootViewController:tmpController];
//    [self addChildViewController:nav ];
//    nav.view.frame=self.view.bounds;
//    nav.view.x=self.view.width;
//    [self.view addSubview:nav.view];
//    [UIView animateWithDuration:0.5 animations:^{
//        nav.view.x=0;
//    }];
    
}

- (void)getQRCodeResult:(NSString *)qr_result{
    
    NSString *jsStr=[NSString stringWithFormat:@"js_qr_code_scan(\"%@\")",qr_result];
    [self.webView evaluateJavaScript:jsStr completionHandler:nil];
    
}

#pragma mark 定位
- (void)positionWithDic:(NSDictionary *)dict{
    NSString *jsStr=[NSString stringWithFormat:@"js_position(\"%f\",\"%f\")",_fanweApp.latitude,_fanweApp.longitude];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id str, NSError * _Nullable error) {
        NSLog(@"%@",str);
        NSLog(@"%@",error);
    }];
}

#pragma mark 定位2
- (void)position2WithDic:(NSDictionary *)dict{
//    NSString *jsStr=[NSString stringWithFormat:@"js_position2(\"%f\",\"%f\",\'%@\')",_fanweApp.latitude,_fanweApp.longitude,_fanweApp.addressJsonStr];
//    [self.webView evaluateJavaScript:jsStr completionHandler:^(id str, NSError * _Nullable error) {
//        NSLog(@"%@",str);
//        NSLog(@"%@",error);
//    }];
}

#pragma mark 获取用户信息并通过js上传
- (void)getuserinfoWithDic:(NSDictionary *)dict{
    
//    NSLog(@"imUserId==%@,imUserName==%@,imUserIconUrl==%@",[[[IMAPlatform sharedInstance] host] imUserId],[[[IMAPlatform sharedInstance] host] imUserName],[[[IMAPlatform sharedInstance] host] imUserIconUrl]);
//    NSString *jsonStr = [NSString stringWithFormat:@"{\"user_id\":\"%@\",\"nick_name\":\"%@\",\"head_image\":\"%@\"}",[[[IMAPlatform sharedInstance] host] imUserId],[[[IMAPlatform sharedInstance] host] imUserName],[[[IMAPlatform sharedInstance] host] imUserIconUrl]];
//    NSString *jsStr = [NSString stringWithFormat:@"js_getuserinfo(\'%@\')",jsonStr];
//    NSLog(@"jsStr==%@",jsStr);
//    [self.webView evaluateJavaScript:jsStr completionHandler:^(id str, NSError * _Nullable error) {
//        NSLog(@"%@",str);
//        NSLog(@"%@",error);
//    }];
}


#pragma mark 推送
- (void)apnsDic:(NSDictionary *)dict{
    NSString *jsStr=[NSString stringWithFormat:@"js_apns(\"ios\",\"%@\")",_fanweApp.deviceToken];
    [self.webView evaluateJavaScript:jsStr completionHandler:nil];
}


#pragma mark 打开新的webview
- (void)openNewWebWithDic:(NSDictionary *)dict{
    
    if ([[dict toString:@"open_url_type"] isEqualToString:@"1"] ) {
        NSURL *url=[NSURL URLWithString:dict[@"url"]];
        [[UIApplication sharedApplication] openURL:url];
    }else{
        BaseWebController *tmpController1= [BaseWebController webControlerWithUrlString:dict[@"url"] andIsShowLaunchImgView:NO];
        tmpController1.isShowBack = YES;
        [self.navigationController pushViewController:tmpController1 animated:YES];
    }
}



#pragma mark 分享
//-(void)sdk_shareWithDic:(NSDictionary *)dict{
//    shareModel *model=[shareModel mj_objectWithKeyValues:dict];
    //    [self shareWithModel:model];
//    [self openShare:model];
//}

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
//    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_Qzone)]];
//    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//        _myShareModel =model;
//        self.share_key =model.share_key;
//        [self shareTextToPlatformType:platformType shareModel:_myShareModel];
//        
//    }];
//}
//
//- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType shareModel:(shareModel *)model
//{
//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    
//    if (![model.share_content isEqualToString:@""]) {
//        messageObject.text =model.share_content;
//    }else
//    {
//        messageObject.text =model.share_title;
//    }
//    UMShareImageObject *imageObject =[[UMShareImageObject alloc] init];
//    UMShareWebpageObject *webpageObject =[[UMShareWebpageObject alloc] init];
//    if (![model.share_imageUrl isEqualToString:@""]) {
//        [imageObject setShareImage:model.share_imageUrl];
//        messageObject.shareObject =imageObject;
//    }
//    if (![model.share_url isEqualToString:@""]) {
//        webpageObject.webpageUrl =model.share_url;
//        messageObject.shareObject =webpageObject;
//    }
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//        if (error) {
//            NSLog(@"************Share fail with error %@*********",error);
//        }else{
//            NSLog(@"response data is %@",data);
//            NSString *jsStr=[NSString stringWithFormat:@"share_compleate(\"%d\")",[self.share_key intValue]];
//            [self.webView evaluateJavaScript:jsStr completionHandler:nil];
//        }
//    }];
//}
#pragma mark 点击友盟分享面板中的某一项
//-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData{
//    
//    NSLog(@"====platformName:%@",platformName);
//    
//    if (![_myShareModel.share_content isEqualToString:@""]) {
//        socialData.shareText = _myShareModel.share_content;
//    }else{
//        socialData.shareText = _myShareModel.share_title;
//    }
//    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:_myShareModel.share_imageUrl];
//
//    if ([platformName isEqualToString:@"sina"]) { //新浪微博
//        socialData.shareText = [NSString stringWithFormat:@"%@%@",_myShareModel.share_content,_myShareModel.share_url];
//        socialData.extConfig.sinaData.urlResource.url = _myShareModel.share_url;
//        [socialData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:_myShareModel.share_imageUrl];
//    }else if ([platformName isEqualToString:@"wxsession"]) { //微信好友
//        [socialData.extConfig.wechatSessionData setWxMessageType:UMSocialWXMessageTypeWeb];
//        socialData.extConfig.wechatSessionData.title = _myShareModel.share_title;
//        socialData.extConfig.wechatSessionData.url = _myShareModel.share_url;
//    }else if ([platformName isEqualToString:@"wxtimeline"]) { //朋友圈
//        [socialData.extConfig.wechatTimelineData setWxMessageType:UMSocialWXMessageTypeWeb];
//        socialData.extConfig.wechatTimelineData.title = _myShareModel.share_title;
//        socialData.extConfig.wechatTimelineData.url = _myShareModel.share_url;
//    }else if ([platformName isEqualToString:@"qzone"]) { //QQ空间
//        socialData.extConfig.qzoneData.title = _myShareModel.share_title;
//        socialData.extConfig.qzoneData.url = _myShareModel.share_url;
//    }else if ([platformName isEqualToString:@"qq"]) { //QQ
//        socialData.extConfig.qqData.title = _myShareModel.share_title;
//        socialData.extConfig.qqData.url = _myShareModel.share_url;
//    }
//    
//}

#pragma mark 分享实现回调方法
//-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
//{
//    //根据`responseCode`得到发送结果,如果分享成功
//    if(response.responseCode == UMSResponseCodeSuccess)
//    {
//        //得到分享到的微博平台名
//        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
//        NSString *jsStr=[NSString stringWithFormat:@"share_compleate(\"%d\")",[self.share_key intValue]];
//        // [self.webView stringByEvaluatingJavaScriptFromString:jsStr];
//        [self.webView evaluateJavaScript:jsStr completionHandler:nil];
//        
//    }
//}

#pragma mark 登录成功
-(void)login_successDic:(NSDictionary *)dic{
    //[self getMyInfo];
}

#pragma mark 获取用户信息
//- (void)getMyInfo{
//    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
//    [mDict setObject:@"user" forKey:@"ctl"];
//    [mDict setObject:@"userinfo" forKey:@"act"];
//    
//    [_httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
//        
//        NSDictionary *user = [responseJson objectForKey:@"user"];
//        if (user && [user isKindOfClass:[NSDictionary class]]) {
//            
//            TIMUserProfile *selfProfile = [[TIMUserProfile alloc]init];
//            selfProfile.identifier = [user toString:@"user_id"];
//            selfProfile.nickname = [user toString:@"nick_name"];
//            selfProfile.faceURL = [user toString:@"head_image"];
//            
//            [IMAPlatform sharedInstance].host.profile = selfProfile;
//            [IMAPlatform sharedInstance].host.profile.customInfo = user;
//            [IMAPlatform sharedInstance].host.customInfoDict = [NSMutableDictionary dictionaryWithDictionary:user];
//        }else{
//            [IMAPlatform sharedInstance].host.customInfoDict = [NSMutableDictionary dictionary];
//        }
//        
//    } FailureBlock:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
//}



#pragma mark 判断是否安装了某个应用
- (void)isExistInstalledWithScheme:(NSString *)scheme{
    
    if (scheme && ![scheme isEqualToString:@""]) {
        NSURL *url = [NSURL URLWithString:scheme];
        BOOL canOpenURL = [[UIApplication sharedApplication] canOpenURL:url];
        
        NSString *jsStr;
        if (canOpenURL) {
            jsStr =[NSString stringWithFormat:@"js_is_exist_installed(\"%@\",\"%d\")",scheme,1];
        }else{
            jsStr =[NSString stringWithFormat:@"js_is_exist_installed(\"%@\",\"%d\")",scheme,0];
        }
        [self.webView evaluateJavaScript:jsStr completionHandler:nil];
    }else{
        [FanweMessage alert:@"URL Schemes 为空"];
    }
    
}

//#pragma mark 第三方sdk登录
//- (void)loginWithType:(NSString *)login_sdk_type{
//    
//    if ([login_sdk_type isEqualToString:@"qqlogin"]) { //QQ sdk登录
//        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
//
//        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//
//            //          获取微博用户名、uid、token等
//
//            if (response.responseCode == UMSResponseCodeSuccess) {
//
//                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
//
//                NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
//
//            }
//        });
//    }else if([login_sdk_type isEqualToString:@"wxlogin"]){ //微信sdk登录
//        //        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
//        //
//        //        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//        //
//        //            if (response.responseCode == UMSResponseCodeSuccess) {
//        //
//        //                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
//        //
//        //                NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
//        //
//        //
//        //                NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
//        //
//        //                [mdic setObject:@"wxlogin" forKey:@"login_sdk_type"]; //sdk类型
//        //                [mdic setObject:snsAccount.userName forKey:@"user_name"]; //用户昵称
//        //                [mdic setObject:snsAccount.iconURL forKey:@"icon_url"]; //用户头像的url
//        //                [mdic setObject:snsAccount.accessToken forKey:@"access_token"];
//        //                [mdic setObject:[NSString stringWithFormat:@"%hhd",snsAccount.isFirstOauth] forKey:@"is_first_oauth"];
//        //                [mdic setObject:snsAccount.openId forKey:@"open_id"];
//        //                NSTimeInterval timeInterval = [snsAccount.expirationDate timeIntervalSince1970];
//        //                [mdic setObject:[NSString stringWithFormat:@"%f",timeInterval] forKey:@"expiration_date"];
//        //                [mdic setObject:snsAccount.refreshToken forKey:@"refresh_token"];
//        //                [mdic setObject:snsAccount.unionId forKey:@"union_id"];
//        //
//        //                NSString *jsonStr = [MyTool dataTOjsonString:mdic];
//        //
//        //                NSString *jsStr=[NSString stringWithFormat:@"js_login_sdk(\"%@\")",jsonStr];
//        //                [self.webView evaluateJavaScript:jsStr completionHandler:nil];
//        //            }
//        //
//        //        });
//
//
//#define TEST_RUN 0
//#if (TEST_RUN || TARGET_IPHONE_SIMULATOR)
//
//        NSString *jsonStr = @"{\"login_sdk_type\":\"wxlogin\",\"code\":\"011T7Qhq0BRHcb1nGSiq0nnUhq0T7QhG\",\"err_code\":\"0\"}";
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"wxpayback" object:jsonStr];
//
//#else
//        //构造SendAuthReq结构体
//        SendAuthReq* req =[[SendAuthReq alloc ] init ];
//        req.scope = @"snsapi_userinfo" ;
//        req.state = @"123" ;
//        //第三方向微信终端发送一个SendAuthReq消息结构
//        [WXApi sendReq:req];
//#endif
//
//
//
//        //        [WXApi sendAuthReq:req viewController:self delegate:self];
//
//
//    }
//}

#pragma mark 微信登录获取code后oc调用js把code等传上去
- (void)wxpayback:(NSNotification *)text{
    
    NSString *jsStr=[NSString stringWithFormat:@"js_login_sdk('%@')",text.object];
    [self.webView evaluateJavaScript:jsStr completionHandler:nil];
    
}

#pragma mark- 其他



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

-(void)callBack:(NSString*)params{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"支付结果:%@",params] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
