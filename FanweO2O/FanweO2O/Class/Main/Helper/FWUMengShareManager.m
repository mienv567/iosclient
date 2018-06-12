//
//  FWUMengShareManager.m
//  FanweApp
//
//  Created by mac on 2017/3/13.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWUMengShareManager.h"

@interface FWUMengShareManager()<UMSocialShareMenuViewDelegate>
{
    GlobalVariables     *_fanweApp;
    UIViewController    *_showController;
}

@end

@implementation FWUMengShareManager

static id _instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
        [_instance initMyData];
    });
    return _instance;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        [_instance initMyData];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}

- (void)initMyData
{
    _fanweApp = [GlobalVariables sharedInstance];
    NSMutableArray *umengSnsArray = [NSMutableArray array];
    
    if (_fanweApp.appModel.wx_app_api == 1)
    {
        [umengSnsArray addObject:@(UMSocialPlatformType_WechatSession)];
        [umengSnsArray addObject:@(UMSocialPlatformType_WechatTimeLine)];
    }
    if (_fanweApp.appModel.qq_app_api == 1)
    {
        [umengSnsArray addObject:@(UMSocialPlatformType_QQ)];
        [umengSnsArray addObject:@(UMSocialPlatformType_Qzone)];
    }
    if (_fanweApp.appModel.sina_app_api == 1)
    {
        [umengSnsArray addObject:@(UMSocialPlatformType_Sina)];
    }
    
    if ([umengSnsArray count])
    {
        [UMSocialUIManager setPreDefinePlatforms:umengSnsArray];
    }
    
    //设置分享面板的显示和隐藏的代理回调
    [UMSocialUIManager setShareMenuViewDelegate:self];
    
}

#pragma mark 弹出分享面板
- (void)showShareViewInControllr:(UIViewController *)vc shareModel:(shareModel *)shareModel succ:(FWUMengSuccBlock)succ failed:(FWErrorBlock)failed
{
    _showController = vc;
    
    //加入copy的操作
    //@see http://dev.umeng.com/social/ios/进阶文档#6
    //    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+2
    //                                     withPlatformIcon:[UIImage imageNamed:@"icon_circle"]
    //                                     withPlatformName:@"演示icon"];
    

    
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    
    __weak typeof(self) ws = self;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        //在回调里面获得点击的
        if (platformType == UMSocialPlatformType_UserDefine_Begin+2)
        {
            NSLog(@"点击演示添加Icon后该做的操作");
        }
        else
        {
            [ws shareWebPageToPlatformType:platformType shareModel:shareModel succ:succ failed:failed];
        }
    }];
}

#pragma mark 根据分享类型进行分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType shareModel:(shareModel *)shareModel succ:(FWUMengSuccBlock)succ failed:(FWErrorBlock)failed
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL =  shareModel.share_imageUrl;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:shareModel.share_title descr:shareModel.share_content thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = shareModel.share_url;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    __weak typeof(self) ws = self;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
            if (failed)
            {
                failed(FWCode_Normal_Error, @"分享失败");
            }
        }
        else
        {
            if ([data isKindOfClass:[UMSocialShareResponse class]])
            {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
                if (shareModel.isNotifiService)
                {
                    [ws didFinishGetUMSocialDataInViewController:resp shareModel:shareModel];
                }
                
                if (succ)
                {
                    succ(resp);
                }
            }
            else
            {
                UMSocialLogInfo(@"response data is %@",data);
                if (failed)
                {
                    failed(FWCode_Normal_Error, @"分享失败");
                }
            }
        }
    }];
}

#pragma mark 分享成功后通知服务端
- (void)didFinishGetUMSocialDataInViewController:(UMSocialShareResponse *)response shareModel:(shareModel *)shareModel
{
    NSInteger platformName = response.platformType;
    NSString *platformNameStr;
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"user" forKey:@"ctl"];
    [mDict setObject:@"share" forKey:@"act"];
    
    if (platformName == UMSocialPlatformType_WechatSession)
    { //微信好友
        [mDict setObject:@"WEIXIN" forKey:@"type"];
        platformNameStr = @"微信";
    }
    else if (platformName == UMSocialPlatformType_WechatTimeLine)
    { //朋友圈
        [mDict setObject:@"WEIXIN_CIRCLE" forKey:@"type"];
        platformNameStr = @"微信朋友圈";
    }
    else if (platformName == UMSocialPlatformType_QQ)
    { //QQ
        [mDict setObject:@"QQ" forKey:@"type"];
        platformNameStr = @"QQ";
    }
    else if (platformName == UMSocialPlatformType_Qzone)
    { //QQ空间
        [mDict setObject:@"QZONE" forKey:@"type"];
        platformNameStr = @"QQ空间";
    }
    else if (platformName == UMSocialPlatformType_Sina)
    { //新浪微博
        [mDict setObject:@"SINA" forKey:@"type"];
        platformNameStr = @"新浪微博";
    }
    
    
    [[NetHttpsManager manager] POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"] == 1)
         {
             if ([responseJson toInt:@"share_award"] > 0)
             {
                 [FanweMessage alertHUD:[responseJson toString:@"share_award_info"]];
             }
         }
     } FailureBlock:^(NSError *error) {
         
     }];
}

#pragma mark - UMSocialShareMenuViewDelegate
- (void)UMSocialShareMenuViewDidAppear
{
    NSLog(@"UMSocialShareMenuViewDidAppear");
}
- (void)UMSocialShareMenuViewDidDisappear
{
    NSLog(@"UMSocialShareMenuViewDidDisappear");
}

- (UIView*)UMSocialParentView:(UIView*)defaultSuperView
{
    return _showController.view;
}

@end
