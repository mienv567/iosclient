//
//  ConsumptionMeselfLiftViewController.h
//  FanweO2O
//
//  Created by ycp on 17/3/3.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConsumptionMeselfLiftViewControllerDelegate <NSObject>

- (void)qrCodeView:(NSString *)password andQrcode:(NSString *)qrcode;

@end
@interface ConsumptionMeselfLiftViewController : UIViewController
@property (nonatomic,copy)NSString *order_id; //订单ID;
@property (nonatomic,assign)id<ConsumptionMeselfLiftViewControllerDelegate>delegate;
@end
