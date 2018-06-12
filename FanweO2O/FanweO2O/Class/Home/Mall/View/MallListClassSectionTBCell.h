//
//  MallListClassSectionTBCell.h
//  FanweO2O
//
//  Created by hym on 2017/1/12.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassSectionModel;

@protocol  MallListClassSectionTBCellDelegate <NSObject>

@optional

- (void)MallListClassSectionSelect:(ClassSectionModel *)model;

- (void)MallListClassSection:(BOOL)hsClass;

@end

@interface MallListClassSectionTBCell : UITableViewCell

+ (MallListClassSectionTBCell *)cellWithTableView:(UITableView *)tableView;

@property (weak,nonatomic) id <MallListClassSectionTBCellDelegate>delegate;

- (void)upDataWith:(NSArray *)array hsClass:(BOOL)hsClass;

@end
