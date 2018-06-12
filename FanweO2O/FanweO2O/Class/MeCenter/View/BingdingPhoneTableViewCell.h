//
//  BingdingPhoneTableViewCell.h
//  FanweO2O
//
//  Created by ycp on 17/1/19.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BingdingPhoneTableViewCellDelegate <NSObject>

- (void)close;
- (void)bingPhoneClick;

@end
@interface BingdingPhoneTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *textButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (nonatomic,assign)id<BingdingPhoneTableViewCellDelegate>delegate;
@end
