//
//  NewBindingPhoneViewController.m
//  FanweO2O
//
//  Created by ycp on 17/1/19.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "NewBindingPhoneViewController.h"
#import "FanweMessage.h"
#import "AccountManagementViewController.h"
@interface NewBindingPhoneViewController ()
{
    NetHttpsManager *_httpManager;
    NSInteger       lesstime;
    NSTimer         *_timer;
}
@end

@implementation NewBindingPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"新绑定手机号";
    _httpManager =[NetHttpsManager manager];
    UIButton *but =[UIButton buttonWithType:UIButtonTypeCustom];
    but.frame =CGRectMake(0, 0, 30, 30);
    [but addTarget:self action:@selector(closeBut) forControlEvents:UIControlEventTouchUpInside];
    [but setImage:[UIImage imageNamed:@"o2o_dismiss_icon"] forState:UIControlStateNormal];
    UIBarButtonItem *item =[[UIBarButtonItem alloc] initWithCustomView:but];
    self.navigationItem.leftBarButtonItem =item;
    
    [self.nextButton setBackgroundColor:[UIColor colorWithRed:1.000 green:0.133 blue:0.267 alpha:1.00]];
    
    
    
}
- (IBAction)sendYZM:(id)sender {
    
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

- (void)verificationCodeInterface
{
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"sms" forKey:@"ctl"];
    [dic setObject:@"send_sms_code" forKey:@"act"];
    [dic setObject:_telPhoneTextField.text forKey:@"mobile"];
    [dic setObject:@"4" forKey:@"unique"];
    [_httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
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
- (IBAction)nextBack:(id)sender {
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
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"uc_account" forKey:@"ctl"];
    [dic setObject:@"bindphone" forKey:@"act"];
    [dic setObject:_telPhoneTextField.text forKey:@"mobile"];
    [dic setObject:_yzmTextField.text forKey:@"sms_verify"];
    [dic setObject:@"2" forKey:@"step"];
    if (_is_luck != nil) {
        [dic setObject:_is_luck forKey:@"is_luck"];
    }
    [_httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] ==1) {

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
        [[HUDHelper sharedInstance]tipMessage:responseJson[@"info"]];
    } FailureBlock:^(NSError *error) {
        [[HUDHelper sharedInstance] tipMessage:kNetErrorMsg];
    }];
}
- (void)closeBut
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[AccountManagementViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [_yzmTextField resignFirstResponder];
    [_telPhoneTextField resignFirstResponder];
    
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
