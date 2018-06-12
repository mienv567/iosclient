//
//  MyOrderStoreInfoView.h
//  FanweO2O
//
//  Created by hym on 2017/3/3.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DealOrderItem;

@interface MyOrderStoreInfoView : UIView

+ (instancetype )appView;

@property (nonatomic, strong) DealOrderItem *item;

@property (weak, nonatomic) IBOutlet UILabel *lbStatus;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@end
