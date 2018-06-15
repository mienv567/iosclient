//
//  MyCenterViewController1.m
//  ZhoubaitongO2O
//
//  Created by Harlan on 2018/6/15.
//  Copyright © 2018年 xfg. All rights reserved.
//

#import "MyCenterViewController1.h"

@interface MyCenterViewController1 ()

@end

@implementation MyCenterViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
      self.navigationController.navigationBar.opaque  = 0;
    self.navigationController.navigationBar.hidden    = YES;

    
    
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
