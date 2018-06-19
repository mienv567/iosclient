//
//  SearchViewController.m
//  ZhoubaitongO2O
//
//  Created by Harlan on 2018/6/19.
//  Copyright © 2018年 xfg. All rights reserved.
//

#import "SearchViewController.h"
#import "LcLeftTextField.h"
@interface SearchViewController ()<UITextFieldDelegate>

@end

@implementation SearchViewController

- (void)viewDidLoad {
    self.navigationController.navigationBar.barTintColor = kMainColor;
    
    UITextField *TF = [[UITextField alloc] init];
    TF.frame = CGRectMake(0, 0, ScreenW - (130 *kScreenWidthRatio), 30);
    TF.placeholder = @"搜索店铺";
    TF.layer.masksToBounds =YES;
    TF.layer.cornerRadius = CGRectGetHeight(TF.frame) / 2;
    TF.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1.00];
    TF.leftViewMode = UITextFieldViewModeAlways;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15+14, 30)];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *lb= [[UIImageView alloc] init];
    lb.image = [UIImage imageNamed:@"search"];
    lb.frame = CGRectMake(15, 8, 14, 14);
    [view addSubview:lb];
    TF.leftView = view;
    TF.delegate = self;
    TF.keyboardType = UIReturnKeySearch;
    TF.font = [UIFont systemFontOfSize:13.0];
    TF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.navigationItem.titleView = TF;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"点击了搜索");
    return YES;
}


@end
