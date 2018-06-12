//
//  ActivityView.h
//  FanweO2O
//
//  Created by ycp on 17/3/7.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityModel.h"
@interface ActivityView : UIView
@property (nonatomic,strong)UILabel *youhuiName;
@property (nonatomic,strong)UILabel *userTime;
@property (nonatomic,strong)UIImageView *picture;
@property (nonatomic,strong)ActivityModel *aModel;
@end
