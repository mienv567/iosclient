//
//  FavorableTBCell.h
//  FanweO2O
//
//  Created by hym on 2017/1/11.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FavorableModel;

@protocol FavorableTBCellDelegate <NSObject>

@optional

//先注释掉
- (void)immediatelyGetWithModel:(FavorableModel *)model;

@end

@interface FavorableTBCell : UITableViewCell

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview;

@property (nonatomic, retain) id<FavorableTBCellDelegate> delegate;
@property (nonatomic, strong) FavorableModel *model;

@end
