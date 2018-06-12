//
//  FWBaseViewController.h
//  FanweO2O
//
//  Created by hym on 2017/4/6.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWBaseViewController : UIViewController

@property (nonatomic, strong) NetHttpsManager *httpManager;
@property (nonatomic, strong) GlobalVariables *fanweApp;

@end
