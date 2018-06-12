//
//  O2ORetrievePasswordViewController.m
//  FanweO2O
//
//  Created by ycp on 16/12/20.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "O2ORetrievePasswordViewController.h"
#import "MBProgressHUD.h"
#import "NetHttpsManager.h"
#import "FanweMessage.h"
#import "NSString+Addition.h"
#import "MyViewController.h"
@interface O2ORetrievePasswordViewController ()<MBProgressHUDDelegate>
{
    NetHttpsManager *_httpsManager;
    NSInteger       lesstime;
    NSTimer         *_timer;
}
@end

@implementation O2ORetrievePasswordViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title =_type;
    if (_phoneStr !=nil) {
        self.applePhoneText.text =_phoneStr;
        self.applePhoneText.enabled =NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.title =@"";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =_type;
    _httpsManager =[NetHttpsManager manager];
    [self initNib];
    [self.verificationCodeButton setTitleColor:kAppFontColorComblack forState:UIControlStateNormal];
}
- (void)initNib
{
    self.determineBtn.layer.masksToBounds =YES;
    self.determineBtn.layer.cornerRadius =8;
    self.determineBtn.backgroundColor =kAppMainColor;
    self.appleNewPsw.secureTextEntry =YES;
}
- (void)setType:(NSString *)type
{
    _type =type;
}
- (void)setPhoneStr:(NSString *)phoneStr
{
    _phoneStr =phoneStr;
}
- (void)setPhoneAllNumber:(NSString *)phoneAllNumber
{
    _phoneAllNumber =phoneAllNumber;
}
//发送验证码
- (IBAction)SendVerificationCode:(UIButton *)sender {
    if (_phoneAllNumber !=nil) {
         [self verificationCodeInterface];
    }else
    {
        NSString *str =_applePhoneText.text;
        if ([str isEqualToString:@""]) {
            [FanweMessage alert:@"请输入手机号码"];
            return;
        }
        if (![str isTelephone]) {
            [FanweMessage alert:@"请输入正确的手机号"];
            return;
        }
         [self verificationCodeInterface];
    }
   
    
}
- (void)verificationCodeInterface
{
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"sms" forKey:@"ctl"];
    [dic setObject:@"send_sms_code" forKey:@"act"];
    if (_phoneAllNumber !=nil) {
        [dic setObject:_phoneAllNumber forKey:@"mobile"];
    }else
    {
        [dic setObject:_applePhoneText.text forKey:@"mobile"];
    }
    [dic setObject:@"2" forKey:@"unique"];
    [_httpsManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        NSLog(@"%@",responseJson);
        if ([responseJson toInt:@"status"] ==1) {
            lesstime =[responseJson[@"lesstime"] intValue];
            [self timer];
        }
        [[HUDHelper sharedInstance] tipMessage:responseJson[@"info"]];
    } FailureBlock:^(NSError *error) {
        
    }];
    
}

- (void)timer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFire) userInfo:nil repeats:YES];
    
}
- (void)timerFire
{
    if (lesstime >1) {
        lesstime --;
        _verificationCodeButton.enabled =NO;
        [_verificationCodeButton setTitle:[NSString stringWithFormat:@"重新发送(%ld)",(long)lesstime] forState:UIControlStateNormal];
        [self.verificationCodeButton setTitleColor:kAppFontColorLightGray forState:UIControlStateNormal];
    }
    if (lesstime ==1) {
        _verificationCodeButton.enabled =YES;
        [_verificationCodeButton setTitle:[NSString stringWithFormat:@"发送验证码"] forState:UIControlStateNormal];
        [_timer invalidate];
        [self.verificationCodeButton setTitleColor:kAppFontColorComblack forState:UIControlStateNormal];
        return;
    }
}

//确定
- (IBAction)determineButton:(UIButton *)sender {
    if (_phoneAllNumber !=nil) {
        if ([_applePhoneCode.text isEqualToString:@""]) {
            [[HUDHelper sharedInstance] tipMessage:@"请输入验证码" delay:1];
            return;
        }
        if ([_appleNewPsw.text isEqualToString:@""]) {
            [[HUDHelper sharedInstance] tipMessage:@"请输入密码" delay:1];
            return;
        }
        [self retrievePasswordInterface];
    }else
    {
        if ([_applePhoneText.text isEqualToString:@""]) {
            [[HUDHelper sharedInstance] tipMessage:@"请输入手机号" delay:1];
            return;
        }
        
        if (![_applePhoneText.text isTelephone]) {
            [[HUDHelper sharedInstance] tipMessage:@"请输入正确手机号" delay:1];
            return;
        }
        
        if ([_applePhoneCode.text isEqualToString:@""]) {
            [[HUDHelper sharedInstance] tipMessage:@"请输入验证码" delay:1];
            return;
        }
        if ([_appleNewPsw.text isEqualToString:@""]) {
            [[HUDHelper sharedInstance] tipMessage:@"请输入密码" delay:1];
            return;
        }
         [self retrievePasswordInterface];
    
    }
    
    
    
    
    
}
- (void)retrievePasswordInterface
{
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"user" forKey:@"ctl"];
    [dic setObject:@"phmodifypassword" forKey:@"act"];
    if (_phoneAllNumber !=nil) {
        [dic setObject:_phoneAllNumber forKey:@"mobile"];
    }else
    {
        [dic setObject:_applePhoneText.text forKey:@"mobile"];
    }
    [dic setObject:_applePhoneCode.text forKey:@"sms_verify"];
    [dic setObject:_appleNewPsw.text forKey:@"new_pwd"];
    [_httpsManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"]==1) {
            [[HUDHelper sharedInstance] tipMessage:responseJson[@"info"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        [[HUDHelper sharedInstance] tipMessage:responseJson[@"info"]];
    } FailureBlock:^(NSError *error) {
        
    }];
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
