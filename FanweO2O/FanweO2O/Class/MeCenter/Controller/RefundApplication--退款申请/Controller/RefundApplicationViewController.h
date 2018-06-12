//
//  RefundApplicationViewController.h
//  FanweO2O
//
//  Created by ycp on 17/3/13.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefundShopModel.h"
@interface RefundApplicationViewController : UIViewController
@property (nonatomic,copy)NSMutableArray *shopArray;
@property (nonatomic,copy)NSMutableArray *content;
@property (nonatomic,strong)RefundShopModel *shopModel;
@end
