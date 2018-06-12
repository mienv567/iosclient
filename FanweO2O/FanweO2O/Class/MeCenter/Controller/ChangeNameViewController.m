//
//  ChangeNameViewController.m
//  FanweO2O
//
//  Created by ycp on 17/1/20.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ChangeNameViewController.h"
#import "FanweMessage.h"
#import "NetHttpsManager.h"
@interface ChangeNameViewController ()
{
    NetHttpsManager *_httpManager;
}

@end

@implementation ChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"修改昵称";
    self.OKButton.backgroundColor =[UIColor colorWithRed:0.953 green:0.204 blue:0.161 alpha:1.00];
    self.textField.text =_name;
    _httpManager =[NetHttpsManager manager];
    
    
}
- (IBAction)OK:(id)sender {
    if (self.textField.text.length <2) {
        [FanweMessage alert:@"请输入大于2个字"];
        return;
    }
    if (self.textField.text.length >16) {
        [FanweMessage alert:@"请输入小于16个字"];
        return;
    }
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"user" forKey:@"ctl"];
    [dic setObject:@"dochangeuname" forKey:@"act"];
    [dic setObject:self.textField.text forKey:@"user_name"];
    [_httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] ==1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        [FanweMessage alert:responseJson[@"info"]];
        
    } FailureBlock:^(NSError *error) {
        [[HUDHelper sharedInstance] tipMessage:kNetErrorMsg];
    }];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [_textField resignFirstResponder];
    
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
