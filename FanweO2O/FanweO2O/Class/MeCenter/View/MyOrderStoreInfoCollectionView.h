//
//  MyOrderStoreInfoCollectionView.h
//  FanweO2O
//
//  Created by hym on 2017/3/3.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyBlock)();

@class DealOrderItem;

@interface MyOrderStoreInfoCollectionView : UIView

+ (instancetype )appView;

@property (nonatomic, strong) DealOrderItem *item;

@property (nonatomic, copy) MyBlock block;

@property (weak, nonatomic) IBOutlet UILabel *lbStatus;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;

@end
