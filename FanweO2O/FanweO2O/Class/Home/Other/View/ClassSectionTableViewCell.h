//
//  ClassSectionTableViewCell.h
//  FanweO2O
//
//  Created by hym on 2017/1/9.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClassSectionModel;

@protocol  ClassSectionTableViewCellDelegate <NSObject>

@optional

-(void)ClassSectionSelect:(ClassSectionModel *)model;

@end

@interface ClassSectionTableViewCell : UITableViewCell

+ (ClassSectionTableViewCell *)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, assign) NSInteger iCount;
@property (nonatomic, strong) NSArray *array;

@property (weak,nonatomic) id <ClassSectionTableViewCellDelegate>delegate;

@end
