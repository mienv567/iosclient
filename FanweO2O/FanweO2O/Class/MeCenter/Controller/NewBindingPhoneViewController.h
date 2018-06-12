//
//  NewBindingPhoneViewController.h
//  FanweO2O
//
//  Created by ycp on 17/1/19.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewBindingPhoneViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *telPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *yzmTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendyzmButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic,copy)NSString * is_luck; //已绑定手机的第二步验证参数
@end
