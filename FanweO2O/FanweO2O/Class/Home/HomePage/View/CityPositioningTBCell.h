//
//  CityPositioningTBCell.h
//  FanweO2O
//
//  Created by hym on 2016/12/15.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CityBaseModel;
@class CityValueModel;
@protocol  CityPositioningTBCellDelegate <NSObject>
@optional
-(void)selectCity:(CityBaseModel *)model;
@end

@interface CityPositioningTBCell : UITableViewCell

+ (CityPositioningTBCell *)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) NSMutableArray *indexsArray;

@property (nonatomic, weak)id <CityPositioningTBCellDelegate >delegate;

@property (nonatomic, strong) CityValueModel *cityModel;
@end
