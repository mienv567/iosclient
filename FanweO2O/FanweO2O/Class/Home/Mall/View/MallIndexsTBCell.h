//
//  MallIndexsTBCell.h
//  FanweO2O
//
//  Created by hym on 2016/12/9.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MallIndexModel;
@protocol  MallIndexsTBCellDelegate <NSObject>
@optional
-(void)goNextVC:(MallIndexModel *)model;
@end

@interface MallIndexsTBCell : UITableViewCell

+ (MallIndexsTBCell *)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) NSMutableArray *indexsArray;

@property(nonatomic, weak)id <MallIndexsTBCellDelegate >delegate;

@end
