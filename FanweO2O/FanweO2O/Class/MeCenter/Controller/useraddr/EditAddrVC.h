//
//  EditAddrVC.h
//  FanweO2O
//
//  Created by zzl on 2017/3/1.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dataModel.h"
@class IQTextView;
@interface EditAddrVC : UIViewController

@property (nonatomic,strong)    OTOAddr*    mEditTag;

// i = 0 没有修改, i = 1 编辑修改了,i = 2 新增了
@property (nonatomic,strong)    void(^mItBlock)( int i,OTOAddr* edited );

@property (weak, nonatomic) IBOutlet UITextField *minputname;

@property (weak, nonatomic) IBOutlet UITextField *minputtel;

@property (weak, nonatomic) IBOutlet UIButton *mcitybt;

@property (weak, nonatomic) IBOutlet UIButton *maddrbt;
//@property (weak, nonatomic) IBOutlet UITextField *minputdetailaddr;
@property (weak, nonatomic) IBOutlet IQTextView *minputdetailaddr_t;

@property (weak, nonatomic) IBOutlet UITextField *minputnub;
@property (weak, nonatomic) IBOutlet UISwitch *msw;
@property (weak, nonatomic) IBOutlet UIButton *mokbt;


@property (weak, nonatomic) IBOutlet UIView *mbottomwaper;

@property (weak, nonatomic) IBOutlet UIPickerView *mpicka;
@property (weak, nonatomic) IBOutlet UIPickerView *mpickb;
@property (weak, nonatomic) IBOutlet UIPickerView *mpickc;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mbottomconst;


@property (weak, nonatomic) IBOutlet UIButton *mconccc;


@end
