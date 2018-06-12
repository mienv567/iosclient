//
//  FWBaseViewController.m
//  FanweO2O
//
//  Created by hym on 2017/4/6.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FWBaseViewController.h"

@interface FWBaseViewController ()

@end

@implementation FWBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _httpManager = [NetHttpsManager manager];
    
    _fanweApp = [GlobalVariables sharedInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
