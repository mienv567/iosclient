//
//  BindingPhoneViewController.h
//  FanweO2O
//
//  Created by ycp on 17/1/18.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindingPhoneViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *telPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *yzmTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendyzmButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic,copy)NSString * step; //1:已有绑定手机的第一步 2:无绑定手机或已绑定手机的第二步
@property (nonatomic,copy)NSString * telString; //手机完整号码
@property (nonatomic,copy)NSString * telEncryptionString;//加密的手机号码
@end
