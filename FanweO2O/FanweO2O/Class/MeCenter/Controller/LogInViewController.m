//
//  logInViewController.m
//  ZhoubaitongO2O
//
//  Created by Harlan on 2018/6/12.
//  Copyright © 2018年 xfg. All rights reserved.
//

#import "LogInViewController.h"
#import "LcLeftTextField.h"
#import "FWO2OJump.h"
#import "FWO2OJumpModel.h"
#import "XNSDKCore.h"


@interface LogInViewController ()<UITextFieldDelegate> {
    NetHttpsManager *_httpManager;
    GlobalVariables *_FanweApp;
    NSInteger lesstime;
}
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet LcLeftTextField *teletNumTF;
@property (weak, nonatomic) IBOutlet UITextField *MessageTF;
@property (weak, nonatomic) IBOutlet UIButton *btnCode;
@property (weak, nonatomic) IBOutlet UIImageView *weixinImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageVeiw;

@property (nonatomic, assign) NSInteger selectType;
@property (nonatomic, strong) NSString *msg_id;
@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.LoginBtn.backgroundColor = kMainColor;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.LoginBtn.layer.cornerRadius = self.LoginBtn.height / 2;
    self.contentView.layer.shadowColor =  [UIColor blackColor].CGColor;
    self.contentView.layer.shadowOpacity = 0.8f;
    [self.LoginBtn.layer masksToBounds];
    self.contentView.layer.cornerRadius = 5;
    [self.contentView.layer masksToBounds];
    self.weixinImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickWeixin)];
      UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgclick)];
    self.contentView.userInteractionEnabled = YES;
    [self.weixinImageView addGestureRecognizer:tap];
    [self.contentView addGestureRecognizer:tap1];
    self.bgImageVeiw.userInteractionEnabled = YES;
    [self.bgImageVeiw addGestureRecognizer:tap1];
    lesstime = 60;
    
    
    _httpManager = [NetHttpsManager manager];
    _FanweApp = [GlobalVariables sharedInstance];
    
//    _agreement_link = _FanweApp.appModel.privacy_link;
//    _has_wx_login = (int)_FanweApp.appModel.has_wx_login;
}
//登录
- (IBAction)LogInClick:(id)sender {
    [self.MessageTF resignFirstResponder];
    [self.teletNumTF resignFirstResponder];

    
    if (self.selectType == 0) {
        if (![self.teletNumTF.text isTelephone]) {
            [[HUDHelper sharedInstance] tipMessage:@"请输入正确的手机号码~"];
            return;
        }
        
        if ([self.MessageTF.text length] != 6) {
            [[HUDHelper sharedInstance] tipMessage:@"请输入正确的短信验证码~"];
            return;
        }
        if ([self.msg_id length] == 0) {
            [[HUDHelper sharedInstance] tipMessage:@"验证码已经失效,请重新输入验证码~"];
            return;
        }
        ShowIndicatorTextInView(self.view,@"");
        NSMutableDictionary *parmDict = [NSMutableDictionary new];
        [parmDict setObject:@"user" forKey:@"ctl"];
        [parmDict setObject:@"dophlogin" forKey:@"act"];
        [parmDict setObject:self.msg_id forKey:@"msg_id"];
        [parmDict setObject:self.teletNumTF.text forKey:@"mobile"];
        [parmDict setObject:self.MessageTF.text forKey:@"sms_verify"];
        
        [_httpManager POSTWithParameters:parmDict
                            SuccessBlock:^(NSDictionary *responseJson) {
                                HideIndicatorInView(self.view);
                                NSString *info = responseJson[@"info"];
                                    if ([info containsString:@"无"]) {
                                        [[HUDHelper sharedInstance] tipMessage:@"请输入正确的验证码~"];
                                        return ;
                                    }
                                [[NSUserDefaults standardUserDefaults] setObject:@"is_log" forKey:@"is_log"];
                                 [[HUDHelper sharedInstance] tipMessage:[MyTool dicObject:responseJson[@"info"]]];
                                [responseJson createPropertyCode];
                                if ([responseJson[@"status"] integerValue] == 1) {
                                    _FanweApp.user_id = [MyTool dicObject:responseJson[@"id"]];
                                    _FanweApp.user_money = [MyTool dicObject:responseJson[@"money"]];
//                                    _FanweApp.user_email = [MyTool dicObject:responseJson[@"email"]];
                                    _FanweApp.user_name = [MyTool dicObject:responseJson[@"user_name"]];
//                                    头像
//                                    _FanweApp.user_avatar = [MyTool dicObject:[NSString stringWithFormat:@"http://o2o.365csh.com/mapi/%@",responseJson[@"avatar"]]];
                                    _FanweApp.user_avatar =@"http://o2o.365csh.com/public/avatar/noavatar.gif";
                                    NOTIFY_POST(@"user_avatar", _FanweApp.user_avatar);
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
                                    [self dismissViewControllerAnimated:YES completion:nil];
                                    
                                }
                                
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
//
//        if ([_tfPwd.text length] == 0) {
//
//            [[HUDHelper sharedInstance] tipMessage:@"请输入密码"];
//
//            return;
//        }
//        ShowIndicatorTextInView(self.view,@"");
//        NSMutableDictionary *dic =[NSMutableDictionary new];
//        [dic setObject:@"user" forKey:@"ctl"];
//        [dic setObject:@"dologin" forKey:@"act"];
//        [dic setObject:_tfAccount.text forKey:@"user_key"];
//        [dic setObject:_tfPwd.text forKey:@"user_pwd"];
//        [_httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
//            HideIndicatorInView(self.view);
//            if ([responseJson toInt:@"status"] == 1) {
//
//                _FanweApp.user_id = [MyTool dicObject:responseJson[@"id"]];
//                _FanweApp.user_email = [MyTool dicObject:responseJson[@"email"]];
//                _FanweApp.user_name = [MyTool dicObject:responseJson[@"user_name"]];
//                _FanweApp.user_mobile = [MyTool dicObject:responseJson[@"mobile"]];
//                _FanweApp.user_pwd = [MyTool dicObject:responseJson[@"user_pwd"]];
//                _FanweApp.session_id = [MyTool dicObject:responseJson[@"sess_id"]];
//                NSLog(@"%@",_FanweApp.session_id);
//                _FanweApp.is_login = YES;
//
//                if([XNSiteID length] > 0 && [XNKey length] > 0){
//                    NSString *userLevel = @"0";       // 用户级别。 普通用户“0”，VIP用户传“1”到“5”。（“0”为默认值）    【必填】
//                    [[XNSDKCore sharedInstance] loginWithUserid:_FanweApp.user_id  andUsername: _FanweApp.user_name andUserLevel: userLevel];
//
//                }
//
//                [[NSNotificationCenter defaultCenter] postNotificationName:Fw_O2O_ACCOUNT_LOGIN_SUCCESS
//                                                                    object:nil
//                                                                  userInfo:nil];
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//            [[HUDHelper sharedInstance] tipMessage:responseJson[@"info"]];
//
//        } FailureBlock:^(NSError *error) {
//            HideIndicatorInView(self.view);
//            [[HUDHelper sharedInstance] tipMessage:kNetErrorMsg];
//        }];
    }
}
//发送验证吗
- (IBAction)getMessageCode:(id)sender {
    [self.teletNumTF resignFirstResponder];
    [self.MessageTF resignFirstResponder];
//    [self.tfPhone resignFirstResponder];
//    [self.tfAccount resignFirstResponder];
    
    if (![_teletNumTF.text isTelephone]) {
        
        [[HUDHelper sharedInstance] tipMessage:@"请输入正确的手机号码~"];
        
        return;
    }
    
    ShowIndicatorTextInView(self.view,@"");
    
    NSMutableDictionary *parmDict = [NSMutableDictionary new];
    [parmDict setObject:@"sms" forKey:@"ctl"];
    [parmDict setObject:@"send_sms_code" forKey:@"act"];
    [parmDict setObject:_teletNumTF.text forKey:@"mobile"];
    [parmDict setObject:@"0" forKey:@"unique"];
    [_httpManager POSTWithParameters:parmDict
                        SuccessBlock:^(NSDictionary *responseJson) {
                            HideIndicatorInView(self.view);
                            self.msg_id = responseJson[@"msg_id"];
                            if ([responseJson[@"status"] integerValue] == 1) {
                                [self daojishi];
                            }
                            [[HUDHelper sharedInstance] tipMessage:responseJson[@"info"]];
                            
                        } FailureBlock:^(NSError *error) {
                            HideIndicatorInView(self.view);
                            [[HUDHelper sharedInstance] tipMessage:kNetErrorMsg];
                        }];
    
}


//微信登录
-(void)clickWeixin {
    
    [[UMSocialManager defaultManager ]getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
        NSLog(@"error----%@",error.description);
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
            [[NSUserDefaults standardUserDefaults ] setObject:@"is_log" forKey:@"is_log"];
         
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

#pragma mark 倒计时

- (void)daojishi {
    __block int timeout = (int)lesstime; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    [self.btnCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.btnCode setTitle:@"发送验证码" forState:UIControlStateNormal];
                [self.btnCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
- (IBAction)clickDismissBtn:(id)sender {
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
}


-(void)bgclick {
    [self.view endEditing:YES];
}

@end
