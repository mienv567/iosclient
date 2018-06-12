//
//  logInViewController.m
//  ZhoubaitongO2O
//
//  Created by Harlan on 2018/6/12.
//  Copyright © 2018年 xfg. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.LoginBtn.backgroundColor = kMainColor;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.LoginBtn.layer.cornerRadius = self.LoginBtn.height / 2;
    [self.LoginBtn.layer masksToBounds];
}
- (IBAction)LogInClick:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}



@end
