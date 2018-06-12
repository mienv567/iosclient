//
//  BindingPhoneViewController.m
//  FanweO2O
//
//  Created by ycp on 17/1/18.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BindingPhoneViewController.h"
#import "FanweMessage.h"
#import "NetHttpsManager.h"
#import "NewBindingPhoneViewController.h"
@interface BindingPhoneViewController ()
{
    NetHttpsManager *_httpManager;
    NSInteger       lesstime;
    NSTimer         *_timer;
}

@end

@implementation BindingPhoneViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_telString != nil) {
        _telPhoneTextField.text =_telEncryptionString;
        _telPhoneTextField.enabled =NO;
    }else
    {
        _telPhoneTextField.clearButtonMode =UITextFieldViewModeAlways;
    }
     self.title =@"验证绑定手机号";
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.title=@"";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"验证绑定手机号";
    self.nextButton.backgroundColor =[UIColor colorWithRed:1.000 green:0.133 blue:0.267 alpha:1.00];
    _httpManager =[NetHttpsManager manager];
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(goBackHome) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"o2o_dismiss_icon"] forState:UIControlStateNormal];
    UIBarButtonItem *item =[[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:item];

   

    
}
- (IBAction)sendYZM:(id)sender {
    if (_telString !=nil) {
         [self verificationCodeInterface];
    }else
    {
        if ([_telPhoneTextField.text isEqualToString:@""]) {
            [FanweMessage alert:@"请输入手机号码"];
            return;
        }
        if (![_telPhoneTextField.text isTelephone]) {
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
    if (_telString !=nil) {
        [dic setObject:_telString forKey:@"mobile"];
    }else
    {
        [dic setObject:_telPhoneTextField.text forKey:@"mobile"];
    }
    
    [dic setObject:@"4" forKey:@"unique"];
    [_httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        NSLog(@"%@",responseJson);
        if ([responseJson toInt:@"status"] ==1) {
            lesstime =[responseJson[@"lesstime"] intValue];
            [self timer];
            
            if ([responseJson toInt:@"is_bind"] == 1) {
                [FanweMessage alert:[responseJson toString:@"bind_ts"]];
            }
            
        }
        [[HUDHelper sharedInstance] tipMessage:responseJson[@"info"]];
    } FailureBlock:^(NSError *error) {
        [[HUDHelper sharedInstance] tipMessage:kNetErrorMsg];
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
        _sendyzmButton.enabled =NO;
        [_sendyzmButton setTitle:[NSString stringWithFormat:@"重新发送(%ld)",(long)lesstime] forState:UIControlStateNormal];
        [_sendyzmButton setTitleColor:kAppFontColorLightGray forState:UIControlStateNormal];
    }
    if (lesstime ==1) {
        _sendyzmButton.enabled =YES;
        [_sendyzmButton setTitle:[NSString stringWithFormat:@"发送验证码"] forState:UIControlStateNormal];
        [_timer invalidate];
        [_sendyzmButton setTitleColor:kAppFontColorComblack forState:UIControlStateNormal];
        return;
    }
}
- (IBAction)next:(id)sender {
    if (_telString != nil) {
        if ([_yzmTextField.text isEqualToString:@""]) {
            [FanweMessage alert:@"请输入验证码"];
            return;
        }

    }else
    {
        if ([_telPhoneTextField.text isEqualToString:@""]) {
            [FanweMessage alert:@"请输入手机号码"];
            return;
        }
        if (![_telPhoneTextField.text isTelephone]) {
            [FanweMessage alert:@"请输入正确的手机号"];
            return;
        }
        if ([_yzmTextField.text isEqualToString:@""]) {
            [FanweMessage alert:@"请输入验证码"];
            return;
        }

    }
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"uc_account" forKey:@"ctl"];
    [dic setObject:@"bindphone" forKey:@"act"];
    if (_telString !=nil) {
        [dic setObject:_telString forKey:@"mobile"];
    }else
    {
        [dic setObject:_telPhoneTextField.text forKey:@"mobile"];
    }
    [dic setObject:_yzmTextField.text forKey:@"sms_verify"];
    [dic setObject:_step forKey:@"step"];
    [_httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] ==1) {
            NewBindingPhoneViewController *vc =[NewBindingPhoneViewController new];
            vc.is_luck =responseJson[@"is_luck"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } FailureBlock:^(NSError *error) {
        [[HUDHelper sharedInstance] tipMessage:kNetErrorMsg];
    }];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [_yzmTextField resignFirstResponder];
    [_telPhoneTextField resignFirstResponder];

}
- (void)goBackHome
{
    [self.navigationController popViewControllerAnimated:YES];
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
