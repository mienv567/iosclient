//
//  O2OAccountRegisterVC.m
//  FanweO2O
//
//  Created by hym on 2016/12/19.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "O2OAccountRegisterVC.h"
#import "NetHttpsManager.h"
#import "HUDHelper.h"
#import "NSString+Addition.h"
#import "FWO2OJump.h"
#import "FWO2OJumpModel.h"

@interface O2OAccountRegisterVC () {
    NetHttpsManager *_httpManager;
    NSInteger lesstime;
    GlobalVariables *_FanweApp;
}

@property (weak, nonatomic) IBOutlet UITextField *tfAcoount;
@property (weak, nonatomic) IBOutlet UITextField *tfPwd;
@property (weak, nonatomic) IBOutlet UITextField *tfCode;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnCode;
@property (weak, nonatomic) IBOutlet UIButton *btnShowPwd;

@property (weak, nonatomic) IBOutlet UILabel *lbHint;



@end

@implementation O2OAccountRegisterVC


- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.tfCode setTextColor:kAppFontColorComblack];
    [self.tfPwd setTextColor:kAppFontColorComblack];
    [self.tfAcoount setTextColor:kAppFontColorComblack];
    [self.btnCode setTitleColor:kAppFontColorComblack forState:UIControlStateNormal];
    
    self.btnLogin.layer.masksToBounds = YES;
    self.btnLogin.layer.cornerRadius = 8;
    self.tfPwd.secureTextEntry = YES;
    [self.lbHint setTextColor:kAppFontColorLightGray];
    
    self.title = @"注册";
    
    _httpManager = [NetHttpsManager manager];
    _FanweApp = [GlobalVariables sharedInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mrak 按钮事件
- (IBAction)onClickShow:(id)sender {
    self.tfPwd.secureTextEntry = !self.tfPwd.secureTextEntry;
    self.btnShowPwd.selected = !self.btnShowPwd.selected;
}

- (IBAction)onClickGetCode:(id)sender {
    
    if (![_tfAcoount.text isTelephone]) {
        
        [[HUDHelper sharedInstance] tipMessage:@"请输入正确的手机号码~"];
        
        return;
    }
    
    NSMutableDictionary *parmDict = [NSMutableDictionary new];
    [parmDict setObject:@"sms" forKey:@"ctl"];
    [parmDict setObject:@"send_sms_code" forKey:@"act"];
    [parmDict setObject:_tfAcoount.text forKey:@"mobile"];
    [parmDict setObject:@"1" forKey:@"unique"];
    
    [_httpManager POSTWithParameters:parmDict
                        SuccessBlock:^(NSDictionary *responseJson) {
                            
                            if ([responseJson[@"status"] integerValue] == 1) {
                                lesstime = [responseJson[@"lesstime"] integerValue];
                                [self daojishi];
                            }
                            
                            [[HUDHelper sharedInstance] tipMessage:responseJson[@"info"]];
                            
    } FailureBlock:^(NSError *error) {
        
        [[HUDHelper sharedInstance] tipMessage:kNetErrorMsg];
    }];
    
    
}

- (IBAction)onClickLogin:(id)sender {
    
    if (![_tfAcoount.text isTelephone]) {
        [[HUDHelper sharedInstance] tipMessage:@"请输入注册手机号"];
        return;
    }
    
    if ([_tfCode.text length] == 0) {
        [[HUDHelper sharedInstance] tipMessage:@"请输入短信验证码"];
        return;
    }
    
    if ([_tfPwd.text length] == 0) {
        
        [[HUDHelper sharedInstance] tipMessage:@"请输入密码"];
        return;
    }
    
    if ([_tfPwd.text length] < 4 ) {
        
        [[HUDHelper sharedInstance] tipMessage:@"至少输入4位密码"];
        return;
    }
    if ([_tfPwd.text length] > 30 ) {
        
        [[HUDHelper sharedInstance] tipMessage:@"最多可输入30位密码"];
        return;
    }
    NSMutableDictionary *parmDict = [NSMutableDictionary new];
    [parmDict setObject:@"user" forKey:@"ctl"];
    [parmDict setObject:@"dophregister" forKey:@"act"];
    [parmDict setObject:_tfAcoount.text forKey:@"user_mobile"];
    [parmDict setObject:_tfPwd.text forKey:@"user_pwd"];
    [parmDict setObject:_tfCode.text forKey:@"sms_verify"];
    [parmDict setObject:@"1" forKey:@"unique"];
    [_httpManager POSTWithParameters:parmDict
                        SuccessBlock:^(NSDictionary *responseJson) {
                            if ([responseJson[@"status"] integerValue] == 1) {
                                
                                [self loginIng];
                            }
                            [[HUDHelper sharedInstance] tipMessage:responseJson[@"info"]];
                            
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
    
    [self.btnCode setTitleColor:kAppFontColorLightGray forState:UIControlStateNormal];
    
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.btnCode setTitle:@"发送验证码" forState:UIControlStateNormal];
                self.btnCode.userInteractionEnabled = YES;
                [self.btnCode setTitleColor:kAppFontColorComblack forState:UIControlStateNormal];
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
                [self.btnCode setTitleColor:kAppFontColorGray forState:UIControlStateNormal];
                [self.btnCode setTitle:[NSString stringWithFormat:@"重新发送(%@)",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                self.btnCode.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)loginIng {
    ShowIndicatorTextInView(self.view,@"");
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"user" forKey:@"ctl"];
    [dic setObject:@"dologin" forKey:@"act"];
    [dic setObject:_tfAcoount.text forKey:@"user_key"];
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
            _FanweApp.is_login = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:Fw_O2O_ACCOUNT_LOGIN_SUCCESS
                                                                object:nil
                                                              userInfo:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        [[HUDHelper sharedInstance] tipMessage:responseJson[@"info"]];
        
    } FailureBlock:^(NSError *error) {
        [[HUDHelper sharedInstance] tipMessage:kNetErrorMsg];
        HideIndicatorInView(self.view);
        
    }];

}
- (IBAction)userAgreementButton:(UIButton *)sender {
    FWO2OJumpModel *model =[FWO2OJumpModel new];
    
    NSString *urlString = [NSString stringWithFormat:@"%@?ctl=user&act=protocol",
                          API_LOTTERYOUT_URL];
    model.url =urlString;
    model.type =0;
    model.isHideTabBar = YES;
    model.isHideNavBar = YES;
    [FWO2OJump didSelect:model];
}



@end
