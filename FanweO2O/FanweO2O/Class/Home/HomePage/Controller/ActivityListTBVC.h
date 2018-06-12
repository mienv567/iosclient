//
//  ActivityListTBVC.h
//  FanweO2O
//
//  Created by hym on 2017/1/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityBcateListModel.h"

@interface ActivityListTBVC : UITableViewController

@property (nonatomic, strong) ActivityBcateListModel *bcateModel;
@property (nonatomic, copy) NSString *word;
@end
