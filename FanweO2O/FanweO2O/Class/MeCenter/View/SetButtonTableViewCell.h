//
//  SetButtonTableViewCell.h
//  FanweO2O
//
//  Created by ycp on 17/1/4.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetButtonTableViewCellDelegate <NSObject>

- (void)loginOutEnd;

@end
@interface SetButtonTableViewCell : UITableViewCell
@property (nonatomic,assign)id<SetButtonTableViewCellDelegate>delegate;
@end
