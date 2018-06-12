//
//  MyThirdSectionTableViewCell.h
//  FanweO2O
//
//  Created by ycp on 17/1/9.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCenterModel.h"
#import "FWO2OJump.h"
#import "FWO2OJumpModel.h"
#import "ButtonCustom.h"

@protocol MyThirdSectionTableViewCellDelegate <NSObject>

- (void)loginView1;

@end
@interface MyThirdSectionTableViewCell : UITableViewCell
@property (nonatomic,strong)MyCenterModel *model;
@property (nonatomic,strong) NSArray *numberArray;
@property (nonatomic,assign)id<MyThirdSectionTableViewCellDelegate>delegate;
@end
