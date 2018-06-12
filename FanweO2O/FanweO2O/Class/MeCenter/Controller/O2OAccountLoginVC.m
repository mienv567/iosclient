//
//  O2OAccountLoginVC.m
//  FanweO2O
//
//  Created by hym on 2016/12/19.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "O2OAccountLoginVC.h"
#import "O2OAccountRegisterVC.h"
#import "O2ORetrievePasswordViewController.h"
#import "WXApi.h"
#import "FWO2OJump.h"
#import "FWO2OJumpModel.h"
#import "XNSDKCore.h"


@interface O2OAccountLoginVC ()<UITextFieldDelegate> {
    NetHttpsManager *_httpManager;
    GlobalVariables *_FanweApp;
    NSInteger lesstime;
}
@property (weak, nonatomic) IBOutlet UIButton *btnPhoneLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnAccountLogin;

//手机号快捷登录
@property (weak, nonatomic) IBOutlet UIView *phoneContainer;
@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnCode;
@property (weak, nonatomic) IBOutlet UITextField *tfCode;
@property (weak, nonatomic) IBOutlet UILabel *lbHint;

//账号密码登录
@property (weak, nonatomic) IBOutlet UIView *accountContainer;
@property (weak, nonatomic) IBOutlet UITextField *tfAccount;
@property (weak, nonatomic) IBOutlet UITextField *tfPwd;
@property (weak, nonatomic) IBOutlet UIButton *btnGetPwd;
@property (weak, nonatomic) IBOutlet UIButton *btnShowPwd;

@property (nonatomic, assign) NSInteger selectType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *laytop;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@property (weak, nonatomic) IBOutlet UILabel *otherLogin;
@property (weak, nonatomic) IBOutlet UIButton *wxLogin;

@end

@implementation O2OAccountLoginVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden =NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectType = 1001;
    self.laytop.constant = 180;
    
    self.btnLogin.layer.masksToBounds = YES;
    self.btnLogin.layer.cornerRadius = 8;
    
    [self.tfPwd setTextColor:kAppFontColorComblack];
    [self.tfCode setTextColor:kAppFontColorComblack];
    [self.tfPhone setTextColor:kAppFontColorComblack];
    [self.tfAccount setTextColor:kAppFontColorComblack];
    
    [self.lbHint setTextColor:kAppFontColorLightGray];
    
    [self.btnPhoneLogin setTitleColor:kAppFontColorComblack forState:UIControlStateNormal];
    
    [self.btnAccountLogin setTitleColor:kAppFontColorComblack forState:UIControlStateNormal];
    
    [self.btnGetPwd setTitleColor:kAppFontColorComblack forState:UIControlStateNormal];
    self.btnGetPwd.hidden = NO;
    self.title = @"登录";
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 30, 30);
    
    [btn setImage:[UIImage imageNamed:@"o2o_dismiss_icon"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftBarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item =[[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem =item;
    
    [self setViewBorder:self.btnPhoneLogin bordrcolor:[UIColor whiteColor] backGroundColor:[UIColor whiteColor]];
    [self setViewBorder:self.btnAccountLogin bordrcolor:kLineLightColor backGroundColor:kBackGroundColor];
    
    self.tfPwd.secureTextEntry = YES;
    [self setNav];
    
    _httpManager = [NetHttpsManager manager];
    _FanweApp = [GlobalVariables sharedInstance];
   
    _agreement_link = _FanweApp.appModel.privacy_link;
    _has_wx_login = (int)_FanweApp.appModel.has_wx_login;
    [self logining];
    self.navigationController.navigationBar.hidden = NO;
    //self.tabBarController.tabBar.hidden = YES;
    
    self.fd_interactivePopDisabled = YES;
    
    if ([GlobalVariables sharedInstance].needCustomUI) {
        _otherLogin.hidden = YES;
        _wxLogin.hidden = YES;
    }else {
        _otherLogin.hidden = NO;
        _wxLogin.hidden = NO;
    }
    
}

- (void)setNav {
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(0, 0,60, 45);
    rightBtn.titleLabel.font =KAppTextFont13;
    
    [rightBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:KAppMainTextBackColor forState:UIControlStateNormal];
    
    UIBarButtonItem *rightItem =[[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightButtonClick {
    
    O2OAccountRegisterVC *vc = [[O2OAccountRegisterVC alloc] initWithNibName:@"O2OAccountRegisterVC" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark 按钮事件
//用户协议
- (IBAction)onClickAgreement:(id)sender {
    
}

//选择登录方式 1001-手机号快捷登录  1002-账号登录
- (IBAction)onClickSelectLoginType:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.selectType == btn.tag) {
        return;
    }
    
    self.selectType = btn.tag;
    if (self.selectType == 1001) {
        
        self.accountContainer.hidden = YES;
        //self.btnGetPwd.hidden = YES;
        self.phoneContainer.hidden = NO;
        self.laytop.constant = 180;
        
        [self setViewBorder:self.btnPhoneLogin bordrcolor:[UIColor whiteColor] backGroundColor:[UIColor whiteColor]];
        [self setViewBorder:self.btnAccountLogin bordrcolor:kLineLightColor backGroundColor:kBackGroundColor];
        
    }else {
        
        self.accountContainer.hidden = NO;
        //self.btnGetPwd.hidden = NO;
        self.phoneContainer.hidden = YES;
        self.laytop.constant = 180;
        
        [self setViewBorder:self.btnAccountLogin bordrcolor:[UIColor whiteColor] backGroundColor:[UIColor whiteColor]];
        
        [self setViewBorder:self.btnPhoneLogin bordrcolor:kLineLightColor backGroundColor:kBackGroundColor];
        
        //[self.btnPhoneLogin setBackgroundColor:kBackGroundColor];
        //[self.btnAccountLogin setBackgroundColor:[UIColor whiteColor]];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated {
    HideIndicatorInView(self.view);
}

//发送验证码
- (IBAction)onClickGetCode:(id)sender {
    
    [self.tfPwd resignFirstResponder];
    [self.tfCode resignFirstResponder];
    [self.tfPhone resignFirstResponder];
    [self.tfAccount resignFirstResponder];
    
    if (![_tfPhone.text isTelephone]) {
        
        [[HUDHelper sharedInstance] tipMessage:@"请输入正确的手机号码~"];
        
        return;
    }
    
    ShowIndicatorTextInView(self.view,@"");
    
    NSMutableDictionary *parmDict = [NSMutableDictionary new];
    [parmDict setObject:@"sms" forKey:@"ctl"];
    [parmDict setObject:@"send_sms_code" forKey:@"act"];
    [parmDict setObject:_tfPhone.text forKey:@"mobile"];
    [parmDict setObject:@"0" forKey:@"unique"];
    [_httpManager POSTWithParameters:parmDict
                        SuccessBlock:^(NSDictionary *responseJson) {
                            HideIndicatorInView(self.view);
                            NSLog(@"%@",responseJson);
                            if ([responseJson[@"status"] integerValue] == 1) {
                                lesstime = [responseJson[@"lesstime"] integerValue];
                                [self daojishi];
                            }
                            [[HUDHelper sharedInstance] tipMessage:responseJson[@"info"]];
                            
                        } FailureBlock:^(NSError *error) {
                            HideIndicatorInView(self.view);
                            [[HUDHelper sharedInstance] tipMessage:kNetErrorMsg];
                        }];
    
}

//登录
- (IBAction)onClickLogin:(id)sender {
    
    [self.tfPwd resignFirstResponder];
    [self.tfCode resignFirstResponder];
    [self.tfPhone resignFirstResponder];
    [self.tfAccount resignFirstResponder];
    
    if (self.selectType == 1001) {
        if (![_tfPhone.text isTelephone]) {
            
            [[HUDHelper sharedInstance] tipMessage:@"请输入正确的手机号码~"];
            
            return;
        }
        
        if ([_tfCode.text length] == 0) {
            
            [[HUDHelper sharedInstance] tipMessage:@"请输入短信验证码~"];
            
            return;
        }
        
        ShowIndicatorTextInView(self.view,@"");
        NSMutableDictionary *parmDict = [NSMutableDictionary new];
        [parmDict setObject:@"user" forKey:@"ctl"];
        [parmDict setObject:@"dophlogin" forKey:@"act"];
        [parmDict setObject:_tfPhone.text forKey:@"mobile"];
        [parmDict setObject:_tfCode.text forKey:@"sms_verify"];
        
        [_httpManager POSTWithParameters:parmDict
                            SuccessBlock:^(NSDictionary *responseJson) {
                                NSLog(@"==================\n%@",responseJson);
                                [responseJson createPropertyCode];
                                HideIndicatorInView(self.view);
                                if ([responseJson[@"status"] integerValue] == 1) {
                                    
                                    _FanweApp.user_id = [MyTool dicObject:responseJson[@"id"]];
                                    _FanweApp.user_email = [MyTool dicObject:responseJson[@"email"]];
                                    _FanweApp.user_name = [MyTool dicObject:responseJson[@"user_name"]];
                                    _FanweApp.user_mobile = [MyTool dicObject:responseJson[@"mobile"]];
                                    _FanweApp.user_pwd = [MyTool dicObject:responseJson[@"user_pwd"]];
                                    _FanweApp.session_id = [MyTool dicObject:responseJson[@"sess_id"]];
                                    _FanweApp.is_login = YES;
                                    
                                    if([XNSiteID length] > 0 && [XNKey length] > 0){
                                        NSString *userLevel = @"0";       // 用户级别。 普通用户“0”，VIP用户传“1”到“5”。（“0”为默认值）    【必填】
                                        [[XNSDKCore sharedInstance] loginWithUserid:_FanweApp.user_id  andUsername: _FanweApp.user_name andUserLevel: userLevel];
                                        
                                    }
                                
                                    [[NSNotificationCenter defaultCenter] postNotificationName:Fw_O2O_ACCOUNT_LOGIN_SUCCESS
                                                                                        object:nil
                                                                                      userInfo:nil];
                                    [self.navigationController popViewControllerAnimated:YES];
                                    
                                }
                                [[HUDHelper sharedInstance] tipMessage:[MyTool dicObject:responseJson[@"info"]]];
                                
                            } FailureBlock:^(NSError *error) {
                                
                                HideIndicatorInView(self.view);
                                [[HUDHelper sharedInstance] tipMessage:kNetErrorMsg];
                                
                            }];
        
    }else
    {
        //if (![_tfAccount.text isTelephone]) {
            
            //[[HUDHelper sharedInstance] tipMessage:@"请输入正确的手机号码"];
            
            //return;
        //}
        
        if ([_tfPwd.text length] == 0) {
            
            [[HUDHelper sharedInstance] tipMessage:@"请输入密码"];
            
            return;
        }
        ShowIndicatorTextInView(self.view,@"");
        NSMutableDictionary *dic =[NSMutableDictionary new];
        [dic setObject:@"user" forKey:@"ctl"];
        [dic setObject:@"dologin" forKey:@"act"];
        [dic setObject:_tfAccount.text forKey:@"user_key"];
        [dic setObject:_tfPwd.text forKey:@"user_pwd"];
        [_httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
            HideIndicatorInView(self.view);
            if ([responseJson toInt:@"status"] == 1) {
                
                _FanweApp.user_id = [MyTool dicObject:responseJson[@"id"]];
                _FanweApp.user_email = [MyTool dicObject:responseJson[@"email"]];
                _FanweApp.user_name = [MyTool dicObject:responseJson[@"user_name"]];
                _FanweApp.user_mobile = [MyTool dicObject:responseJson[@"mobile"]];
                _FanweApp.user_pwd = [MyTool dicObject:responseJson[@"user_pwd"]];
                _FanweApp.session_id = [MyTool dicObject:responseJson[@"sess_id"]];
                NSLog(@"%@",_FanweApp.session_id);
                _FanweApp.is_login = YES;
                
                if([XNSiteID length] > 0 && [XNKey length] > 0){
                    NSString *userLevel = @"0";       // 用户级别。 普通用户“0”，VIP用户传“1”到“5”。（“0”为默认值）    【必填】
                    [[XNSDKCore sharedInstance] loginWithUserid:_FanweApp.user_id  andUsername: _FanweApp.user_name andUserLevel: userLevel];
                    
                }

                [[NSNotificationCenter defaultCenter] postNotificationName:Fw_O2O_ACCOUNT_LOGIN_SUCCESS
                                                                    object:nil
                                                                  userInfo:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            [[HUDHelper sharedInstance] tipMessage:responseJson[@"info"]];
            
        } FailureBlock:^(NSError *error) {
            HideIndicatorInView(self.view);
            [[HUDHelper sharedInstance] tipMessage:kNetErrorMsg];
        }];
    }
    
    
    
    //ctl=&act=
}

//密码显示或隐藏
- (IBAction)onClickShowPwd:(id)sender {
    
    _tfPwd.secureTextEntry = !_tfPwd.secureTextEntry;
    _btnShowPwd.selected = !_btnShowPwd.selected;
}



#pragma mark 其他

- (void)setViewBorder:(UIView *)view bordrcolor:(UIColor *)color backGroundColor:(UIColor *)backGroundColor{
    
    [view setBackgroundColor:backGroundColor];
    view.layer.borderColor = color.CGColor;
    view.layer.borderWidth = 0.5;
}


#pragma mark 倒计时

- (void)daojishi {
    __block int timeout = (int)lesstime; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    [self.btnCode setTitleColor:kAppFontColorLightGray forState:UIControlStateNormal];
    
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.btnCode setTitle:@"发送验证码" forState:UIControlStateNormal];
                [self.btnCode setTitleColor:kAppFontColorComblack forState:UIControlStateNormal];
                self.btnCode.userInteractionEnabled = YES;
            });
        }else{
            
            NSString *strTime;
            if (timeout == lesstime) {
                strTime = [NSString stringWithFormat:@"%ld",lesstime];
            }else {
                int seconds = timeout % lesstime;
                strTime = [NSString stringWithFormat:@"%.2d", seconds];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [self.btnCode setTitle:[NSString stringWithFormat:@"重新发送(%@)",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                self.btnCode.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
//忘记密码
- (IBAction)forgeButton:(UIButton *)sender {
    O2ORetrievePasswordViewController *vc =[[O2ORetrievePasswordViewController alloc] init];
    vc.type =@"找回密码";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)leftBarBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)logining
{
//        if (_FanweApp.appModel.auto_login)
//        {
//            _otherLogin.hidden =YES;
//            _wxLogin.hidden =YES;
//        }
//        if (self.has_wx_login ==1) {
            _wxLogin.hidden =NO;
//        }else
//        {
//            _wxLogin.hidden =YES;
//        }
}
- (IBAction)wxLogining:(UIButton *)sender {
//    if (![WXApi isWXAppInstalled]) {
//        [[HUDHelper sharedInstance] tipMessage:@"微信未安装"];
//    }else
//    {
        [self loginByWechat];
//    }
}
#pragma mark 微信登录
- (void)loginByWechat{
    //构造SendAuthReq结构体
/*    SendAuthReq* req =[[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
  */
    
    
    [[UMSocialManager defaultManager ]getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp =result;
        NSLog(@"----%@",result);
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);
        
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.gender);
        NSLog(@"error%@",error);
        
        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
        if (result ==nil ) {
            [[HUDHelper sharedInstance] tipMessage:@"取消登录"];
            return ;
            
        }else{
           
            [self wechatLoginByRequestForH5:resp.name unionid:resp.originalResponse[@"unionid"] headimgurl:resp.originalResponse[@"headimgurl"] openid:resp.openid access_token:resp.accessToken];

        }
    }];
}


- (void)wechatLoginByRequestForH5:(NSString*)nickname unionid:(NSString *)unionid headimgurl:(NSString *)headimgurl openid:(NSString *)openid access_token:(NSString *)access_token
{
  
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"synclogin" forKey:@"ctl"];
    [dic setObject:@"index" forKey:@"act"];
    [dic setObject:@"Wechat" forKey:@"login_type"];
    [dic setObject:openid forKey:@"openid"];
    [dic setObject:access_token  forKey:@"access_token"];
    [dic setObject:nickname forKey:@"nickname"];
    [dic setObject:unionid forKey:@"unionid"];
    [dic setObject:headimgurl forKey:@"headimgurl"];
    [_httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] ==1) {
            
            _FanweApp.user_id = [MyTool dicObject:responseJson[@"id"]];
            _FanweApp.user_email = [MyTool dicObject:responseJson[@"email"]];
            _FanweApp.user_name = [MyTool dicObject:responseJson[@"user_name"]];
            _FanweApp.user_mobile = [MyTool dicObject:responseJson[@"mobile"]];
            _FanweApp.user_pwd = [MyTool dicObject:responseJson[@"user_pwd"]];
            _FanweApp.session_id = [MyTool dicObject:responseJson[@"sess_id"]];
            _FanweApp.is_login =YES;
            
            if([XNSiteID length] > 0 && [XNKey length] > 0){
                
                NSString *userLevel = @"0";       // 用户级别。 普通用户“0”，VIP用户传“1”到“5”。（“0”为默认值）    【必填】
                [[XNSDKCore sharedInstance] loginWithUserid:_FanweApp.user_id  andUsername: _FanweApp.user_name andUserLevel: userLevel];
                
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:Fw_O2O_ACCOUNT_LOGIN_SUCCESS
                                                                object:nil
                                                              userInfo:nil];
            [[AppDelegate sharedAppDelegate] popViewController];
        }
    } FailureBlock:^(NSError *error) {
        [[HUDHelper sharedInstance] tipMessage:kNetErrorMsg];
    }];
}


#pragma mark qq登录
- (void)loginByQQ{
  
    [[UMSocialManager defaultManager ]getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:self completion:^(id result, NSError *error) {
        UMSocialUserInfoResponse *resp =result;
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:@"login" forKey:@"ctl"];
        [parmDict setObject:@"qq_login" forKey:@"act"];
        [parmDict setObject:resp.openid forKey:@"openid"];
        [parmDict setObject:resp.accessToken forKey:@"access_token"];
        [_httpManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
            if ([responseJson toInt:@"status"] ==1) {
                
                
            }
        } FailureBlock:^(NSError *error) {
            NSLog(@"error==%@",error);
            [[HUDHelper sharedInstance] tipMessage:kNetErrorMsg];
        }];
        
    }];
}
//用户协议
- (IBAction)userXY:(id)sender {
    

    
    FWO2OJumpModel *model = [FWO2OJumpModel new];
    NSString *urlString = [NSString stringWithFormat:@"%@?ctl=user&act=protocol",
                          API_LOTTERYOUT_URL];
    model.url =urlString;
    model.type =0;
    model.isHideTabBar = YES;
    model.isHideNavBar = YES;
    [FWO2OJump didSelect:model];
}

@end
