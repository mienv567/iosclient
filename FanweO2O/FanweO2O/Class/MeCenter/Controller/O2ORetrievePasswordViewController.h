//
//  O2ORetrievePasswordViewController.h
//  FanweO2O
//
//  Created by ycp on 16/12/20.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface O2ORetrievePasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *applePhoneText;
@property (weak, nonatomic) IBOutlet UITextField *applePhoneCode;
@property (weak, nonatomic) IBOutlet UITextField *appleNewPsw;
@property (weak, nonatomic) IBOutlet UIButton *verificationCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *determineBtn;
@property (nonatomic,copy)NSString *type; //type 1:修改密码  0:找回密码;
@property (nonatomic,copy)NSString *phoneStr; //手机号;
@property (nonatomic,copy)NSString *phoneAllNumber; //手机全部号码;
@end
