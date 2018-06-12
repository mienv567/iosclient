//
//  CustomGoodsTableViewCell.h
//  FanweO2O
//
//  Created by ycp on 16/12/7.
//  Copyright © 2016年 fanwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomGoodsModel;
@protocol  CustomGoodsTBCellDelegate <NSObject>
@optional
-(void)customGoodGoNextVC:(CustomGoodsModel *)model;
@end

@interface CustomGoodsTableViewCell : UITableViewCell

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview;

- (void)upDataWith:(NSMutableArray *)array indexPath:(NSIndexPath *)indexPath;

@property (weak,nonatomic) id <CustomGoodsTBCellDelegate >delegate;

@property (nonatomic, assign) BOOL hsShowPrice;

@end
