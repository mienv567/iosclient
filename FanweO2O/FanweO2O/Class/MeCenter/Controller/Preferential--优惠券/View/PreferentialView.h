//
//  PreferentialView.h
//  FanweO2O
//
//  Created by ycp on 17/3/7.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreferentialModel.h"
@interface PreferentialView : UIView
@property (nonatomic,strong)UILabel *youhuiName;
@property (nonatomic,strong)UILabel *userTime;
@property (nonatomic,strong)UILabel *price;
@property (nonatomic,strong)PreferentialModel *pModel;
@end
