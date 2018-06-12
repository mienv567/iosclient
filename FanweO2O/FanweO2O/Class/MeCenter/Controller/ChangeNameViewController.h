//
//  ChangeNameViewController.h
//  FanweO2O
//
//  Created by ycp on 17/1/20.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeNameViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *OKButton;
@property (nonatomic,copy)NSString *name;
@end
