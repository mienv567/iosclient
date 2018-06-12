//
//  CustomTopTableViewCell.h
//  FanweO2O
//
//  Created by ycp on 16/12/15.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomTopTableViewCellDelegate <NSObject>

- (void)leftBtn;

- (void)rightBtn;

@end
@interface CustomTopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (nonatomic,assign)id<CustomTopTableViewCellDelegate>delegate;
+ (instancetype)cellWithTbaleview:(UITableView *)newTableview;
@end
