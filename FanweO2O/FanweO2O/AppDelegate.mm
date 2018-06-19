//
//  AppDelegate.m
//  FanweO2O
//
//  Created by mac on 16/12/7.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "GlobalVariables.h"
#import "LKDBHelper.h"
#import "NSDictionary+Property.h"
#import "O2OConfigModel.h"
#import "DLAVAlertView.h"
#import "WXApi.h"
#import "ShoppingViewController.h"
#import "XNSDKCore.h"
#import <UMSocialCore/UMSocialCore.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import "IQKeyboardManager.h"
#import "NTalkerChatViewController.h"
#import "NTalkerLeaveMsgViewController.h"

@interface AppDelegate ()<WXApiDelegate,UITabBarControllerDelegate,UIAlertViewDelegate>{

    GlobalVariables *_fanweApp;
    NetHttpsManager *_httpManager;

}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self bulidWindow];
    
    //创建tabbar的样式
    [self setTabBarStyle];
    
    [self initConfig];
    
    // 配置第三方sdk
    [self configureOhter:launchOptions];
    
    [_fanweApp startLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initConfig) name:FW_O2O_INIT_MSG object:nil];
    
    
    
    return YES;
}

#pragma mark 配置第三方sdk
- (void)configureOhter:(NSDictionary *)launchOptions
{
   
    if([UmengKey length] > 0){
        
        //打开调试日志
        [[UMSocialManager defaultManager] openLog:YES];
        //设置友盟appkey
        
        [[UMSocialManager defaultManager] setUmSocialAppkey:UmengKey];
    }
    
    if([WeixinAppId length] > 0 && [WeixinSecret length] > 0){
        //设置微信
        [[UMSocialManager defaultManager]   setPlaform:UMSocialPlatformType_WechatSession
                                                appKey:WeixinAppId
                                             appSecret:WeixinSecret
                                           redirectURL:@""];
    }
    
    if([QQAppId length] > 0 && [QQSecret length] > 0){
        //设置QQ
        [[UMSocialManager defaultManager]   setPlaform:UMSocialPlatformType_QQ
                                                appKey:QQAppId
                                             appSecret:QQSecret redirectURL:@""];
    }
    
    if([SinaAppId length] > 0 && [SinaSecret length] > 0){
        
        //设置新浪  第三个参数是新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。
        [[UMSocialManager defaultManager]   setPlaform:UMSocialPlatformType_Sina
                                                appKey:SinaAppId
                                             appSecret:SinaSecret
                                           redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    }
   
    if([XNSiteID length] > 0 && [XNKey length] > 0){
        
        //小能初始化
        [[XNSDKCore sharedInstance] initSDKWithSiteid:XNSiteID
                                            andSDKKey:XNKey];
        [[XNSDKCore sharedInstance] setLinkCardEnable:YES];
        
        [[IQKeyboardManager sharedManager] disableDistanceHandlingInViewControllerClass:[NTalkerChatViewController class]];
        
        [[IQKeyboardManager sharedManager] disableDistanceHandlingInViewControllerClass:[NTalkerLeaveMsgViewController class]];
        
    }
    
}



// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
        
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return [[UMSocialManager defaultManager] handleOpenURL:url];
}
///支持目前所有iOS系统
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
        NSLog(@"不支持 所有ios系统回调 调用%s",__FUNCTION__);
        return [WXApi handleOpenURL:url delegate:self];
    }
   
    return [[UMSocialManager defaultManager] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
        
        return [WXApi handleOpenURL:url delegate:self];
        
    }
    
    return [[UMSocialManager defaultManager] handleOpenURL:url];
}


- (void)bulidWindow
{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    MainTabBarController *TAB = [MainTabBarController new];
    TAB.delegate = self;
    self.window.rootViewController = TAB;
    [self.window makeKeyAndVisible];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
   
    if (viewController == [tabBarController.viewControllers objectAtIndex:3]) {
        
        ShoppingViewController *shop = [ShoppingViewController webControlerWithUrlString:nil andNavTitle:nil isShowIndicator:NO isHideNavBar:YES isHideTabBar:NO];
        [[AppDelegate sharedAppDelegate] pushViewController:shop];
        //[self setupChildViewController:@"购物车" viewController:shop image:@"third_normal" selectedImage:@"third_selected"];
        
        return NO;
    }
    
    return YES;
}



- (void)setTabBarStyle
{
    UITabBar *tabBar =[UITabBar appearance];
    tabBar.tintColor = kMainColor;
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9]} forState:UIControlStateSelected];
    tabBar.backgroundColor =[UIColor whiteColor];
    tabBar.barTintColor =[UIColor whiteColor];
    UINavigationBar *navBar =[UINavigationBar appearance];
    navBar.translucent = NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    _fanweApp.rowid = 1;
    
    [_fanweApp saveToDB];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


//应用将要结束时调用
- (void)applicationWillTerminate:(UIApplication *)application {
   
    [self saveContext];
    
}

#pragma mark 初始化配置
- (void)initConfig {
    //获取基础配置
    LKDBHelper* globalHelper = [GlobalVariables getUsingLKDBHelper];
    NSMutableArray *ne = [globalHelper searchWithSQL:@"select * from @t" toClass:[GlobalVariables class]];
    _fanweApp = [GlobalVariables sharedInstance];
    if (ne.count != 0) {
        
        GlobalVariables *global = [ne lastObject];
        _fanweApp.user_id = global.user_id;
        _fanweApp.user_name = global.user_name;
        _fanweApp.user_pwd = global.user_pwd;
        _fanweApp.city_id = global.city_id;
        _fanweApp.city_name = global.city_name;
        _fanweApp.session_id = global.session_id;
        _fanweApp.is_login = global.is_login;
        
    }

    _httpManager = [NetHttpsManager manager];
    
    NSMutableDictionary *Parameters = [NSMutableDictionary new];
    [Parameters setObject:@"init" forKey:@"ctl"];
    [Parameters setObject:@"ios" forKey:@"sdk_version"];
    [_httpManager POSTWithParameters:Parameters SuccessBlock:^(NSDictionary *responseJson) {
        NSLog(@"%@",responseJson);
        O2OConfigModel *config = [O2OConfigModel mj_objectWithKeyValues:responseJson];
        
        _fanweApp.O2OConfig = config;
        _fanweApp.is_fx =config.is_fx;
        _fanweApp.ios_upgrade = config.ios_upgrade;
        _fanweApp.ios_down_url = config.ios_down_url;
        //是否审核
        if ([config.is_ios_upgrading integerValue] == 1 && [config.serverVersion isEqualToString:VersionTime]) {
            _fanweApp.needCustomUI = YES;
        }else {
            _fanweApp.needCustomUI = NO;
        }
        
        //是否更新
        if ([config.is_ios_upgrading integerValue] == 1) {
            _fanweApp.needUpgrade = NO;
        }else {
            if ([config.serverVersion isEqualToString:VersionTime]) {
                _fanweApp.needUpgrade = NO;
            }else {
                _fanweApp.needUpgrade = YES;
            }
        }
        
        _fanweApp.forcedUpgrade = [config.ios_forced_upgrade isEqualToString:@"1"] ? YES : NO;
        
        
        if (_fanweApp.needUpgrade) {
            
            
            if (_fanweApp.forcedUpgrade) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:_fanweApp.ios_upgrade delegate:self   cancelButtonTitle:@"前往AppStore" otherButtonTitles:nil, nil];
                [alert show];
            }else {
                
                BOOL needUpgrade = [[[NSUserDefaults standardUserDefaults] objectForKey:@"needUpgrade"] boolValue];
                
                if (!needUpgrade) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:_fanweApp.ios_upgrade delegate:self   cancelButtonTitle:@"知道了" otherButtonTitles:@"前往AppStore", nil];
                    [alert show];
                }
                
            }
        }
        
        if (_fanweApp.city_id == 0) {
            
            _fanweApp.city_id = [config.city_id integerValue];
            _fanweApp.city_name = config.city_name;
            _fanweApp.session_id = config.sess_id;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:FW_O2O_CITY_DEFAULT_SELECT_MSG object:nil userInfo:nil];
        }
        
        
    } FailureBlock:^(NSError *error) {
        [[HUDHelper sharedInstance] tipMessage:kNetErrorMsg];
    }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        if (_fanweApp.forcedUpgrade) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://%@",_fanweApp.ios_down_url]]];
            
            if (_fanweApp.forcedUpgrade) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:_fanweApp.ios_upgrade delegate:self   cancelButtonTitle:@"前往AppStore" otherButtonTitles:nil, nil];
                [alert show];
            }else {
                
                BOOL needUpgrade = [[[NSUserDefaults standardUserDefaults] objectForKey:@"needUpgrade"] boolValue];
                
                if (!needUpgrade) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:_fanweApp.ios_upgrade delegate:self   cancelButtonTitle:@"知道了" otherButtonTitles:@"前往AppStore", nil];
                    [alert show];
                }
                
            }
            
        }else {
            
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"needUpgrade"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        
    }else if (buttonIndex == 1) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://%@",_fanweApp.ios_down_url]]];
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"needUpgrade"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"FanweO2O"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

#pragma mark 微信回调方法

- (void)onResp:(BaseResp *)resp
{
    NSString * strMsg = [NSString stringWithFormat:@"errorCode: %d",resp.errCode];
    NSLog(@"strMsg: %@",strMsg);
    
    NSString * errStr       = [NSString stringWithFormat:@"errStr: %@",resp.errStr];
    NSLog(@"errStr: %@",errStr);
    
    NSString * strTitle;
    //判断是微信消息的回调 --> 是支付回调回来的还是消息回调回来的.
    if ([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息的结果"];
    }
    
    NSString * wxPayResult;
    //判断是否是微信支付回调 (注意是PayResp 而不是PayReq)
    
    if ([resp isKindOfClass:[PayResp class]])
    {
        //支付返回的结果, 实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode)
        {
            case WXSuccess:
            {
                strMsg = @"支付结果:";
                NSLog(@"支付成功: %d",resp.errCode);
                wxPayResult = @"success";
                break;
            }
            case WXErrCodeUserCancel:
            {
                strMsg = @"用户取消了支付";
                NSLog(@"用户取消支付: %d",resp.errCode);
                wxPayResult = @"cancel";
                break;
            }
            default:
            {
                strMsg = [NSString stringWithFormat:@"支付失败! code: %d  errorStr: %@",resp.errCode,resp.errStr];
                NSLog(@":支付失败: code: %d str: %@",resp.errCode,resp.errStr);
                wxPayResult = @"faile";
                break;
            }
        }
        //发出通知 从微信回调回来之后,发一个通知,让请求支付的页面接收消息,并且展示出来,或者进行一些自定义的展示或者跳转
        NSNotification * notification = [NSNotification notificationWithName:FW_O2O_WX_PAY_RESULT_MSG object:wxPayResult];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

@end
