//
//  GroupBuyTBVC.h
//  FanweO2O
//
//  Created by hym on 2016/12/12.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWCommonViewController.h"
@interface GroupBuyTBVC : FWCommonViewController
@property (nonatomic,assign)BOOL isAccordingCell;
@property (nonatomic,copy)NSString *count1;
@property (nonatomic,copy)NSString *count2;
@property (nonatomic,copy)NSString *count3;
@property (nonatomic,copy)NSString *count4;
@property (nonatomic,strong)NSMutableArray *lastArray;
@end
