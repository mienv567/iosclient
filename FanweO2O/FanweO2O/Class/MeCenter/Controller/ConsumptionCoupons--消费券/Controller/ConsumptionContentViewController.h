//
//  ConsumptionContentViewController.h
//  FanweO2O
//
//  Created by ycp on 17/3/2.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConsumptionContentViewControllerDelegate <NSObject>

- (void)qrCodeView:(NSString *)password andQrcode:(NSString *)qrcode;

@end
@interface ConsumptionContentViewController : UIViewController
@property (nonatomic,copy)NSString *order_id; //订单ID;

@property (nonatomic,assign)id<ConsumptionContentViewControllerDelegate>delegate;
@end
