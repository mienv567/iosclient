//
//  BaseWebController.h
//  FanweApp
//  Created by mac on 16/4/12.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "shareModel.h"

@interface BaseWebController : BaseViewController <WKScriptMessageHandler,WKNavigationDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,WKUIDelegate,UIAlertViewDelegate,MBProgressHUDDelegate>

@property (nonatomic, strong) NSString    *urlString;             // url地址
@property (nonatomic, copy) NSString    *navTitle;              // 标题栏
@property (nonatomic, assign) BOOL      isShowBack;             // 是否显示返回按钮
@property (nonatomic, assign) BOOL      isHideNavBar;           // 是否隐藏导航栏
@property (nonatomic, assign) BOOL      isHideTabBar;           // 是否隐藏tabBar
@property (nonatomic, assign) BOOL      isShowIndicator;        // 是否显示指示器
@property (nonatomic, assign) BOOL      isShowLaunchImgView;    // 是否显示launchImgView，等webview加载完成后再隐藏

@property (nonatomic, assign) BOOL      isRegist;               //是否来自协议
@property (nonatomic, assign) BOOL      isFront;                //是否允许进入前台刷新
@property (nonatomic, assign) BOOL      isBackReload;           //是否允许从直播间回到到h5页面进行刷新

@property (nonatomic, strong) WKWebView         *webView;               //wkwebview
@property (nonatomic, strong) NSNumber          *share_key;             //分享的key
@property (nonatomic, assign) BOOL              isLoadError;            //是否加载出错
@property (nonatomic, assign) BOOL              isFirstLoad;            //是否第一次加载
@property (nonatomic, assign) BOOL              isImageLoad;            //是否更换头像
@property (nonatomic, strong) UIAlertView       *alertView;
@property (nonatomic, strong) MBProgressHUD     *HUD;
@property (nonatomic, strong) UIImageView       *launchImgView;         // 某些情况用来遮盖当前页面，等页面加载完后再隐藏
@property (nonatomic, strong) shareModel        *myShareModel;          //当前分享的实体
@property (nonatomic, assign) CGSize            size;                   //裁剪图片时的size
@property (nonatomic, strong) UIImageView       *loadingImgView;        // 加载中状态图
@property (nonatomic, strong) UILabel           *loadingLabel;          // 加载中label
@property (nonatomic, strong) NSTimer           *timer;                


@property (nonatomic,copy) NSString *cookieStr2;
+(instancetype)webControlerWithWebView:(WKWebView *)webView;


+(instancetype)webControlerWithUrlString:(NSString *)url andIsShowLaunchImgView:(BOOL)isShowLaunchImgView;

/*
 * urlStr：          url地址
 * navTitle：        导航栏标题
 * isShowIndicator： 是否显示指示器
 * isHideNavBar：    是否显示导航栏
 */
+(instancetype)webControlerWithUrlString:(NSString *)urlStr andNavTitle:(NSString *)navTitle isShowIndicator:(BOOL)isShowIndicator isHideNavBar:(BOOL)isHideNavBar;

/*
 * urlStr：          url地址
 * navTitle：        导航栏标题
 * isShowIndicator： 是否显示指示器
 * isHideNavBar：    是否显示导航栏
 * isHideTabBar：    是否显示底部菜单栏
 */
+(instancetype)webControlerWithUrlString:(NSString *)urlStr andNavTitle:(NSString *)navTitle isShowIndicator:(BOOL)isShowIndicator isHideNavBar:(BOOL)isHideNavBar isHideTabBar:(BOOL)isHideTabBar;

// 加载主页
- (void)loadMyView;


// ===============供子类重写======================

- (void)hideMyHud;

- (void)reloadWebView;

- (NSDictionary *)backDic:(NSString *)jsonStr;

- (void)myUserContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@end
