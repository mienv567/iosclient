//
//  FWHeadLineTBCell.h
//  FanweO2O
//
//  Created by hym on 2016/12/12.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FW_HEADELINE_HIGHT 45
@class HeadLineModel;

@protocol FWHeadLineTBCellDelegate <NSObject>

- (void)moreButton;

@end
@interface FWHeadLineTBCell : UITableViewCell

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview;

@property (nonatomic, strong) NSMutableArray *headLineArray;
@property (nonatomic,assign)id<FWHeadLineTBCellDelegate>delegate;
@end
