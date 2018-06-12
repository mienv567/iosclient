//
//  RefSectionHeaderView.h
//  FanweO2O
//
//  Created by ycp on 17/3/14.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefundApplicationModel.h"
@interface RefSectionHeaderView : UIView
@property(nonatomic,strong)UILabel *storeLabel;
@property(nonatomic,strong)UIImageView *imageIcon;
@property(nonatomic,strong)RefundApplicationModel  *model;
@end
