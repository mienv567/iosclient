//
//  BlindCellPhoneController.m
//  ZhoubaitongO2O
//
//  Created by Harlan on 2018/6/14.
//  Copyright © 2018年 xfg. All rights reserved.
//

#import "BlindCellPhoneController.h"

@interface BlindCellPhoneController ()
@property (weak, nonatomic) IBOutlet UITextField *TFTelephone;
@property (weak, nonatomic) IBOutlet UITextField *TFMessageCode;
@property (weak, nonatomic) IBOutlet UIButton *BTNGetCode;

@end

@implementation BlindCellPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.BTNGetCode.layer.borderWidth = 1;
    CGColorSpaceRef colorSpace =CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 29/255.0, 134/255.0, 255/255.0, 1 });
    self.BTNGetCode.layer.cornerRadius = 3;
    self.BTNGetCode.layer.masksToBounds = YES;
    self.BTNGetCode.layer.borderColor=colorref;
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)getCode:(id)sender {
}

//绑定手机号码
- (IBAction)blindCode:(id)sender {
}


@end
