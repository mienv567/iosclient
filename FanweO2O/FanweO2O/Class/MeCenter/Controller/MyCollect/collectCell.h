//
//  collectCell.h
//  FanweO2O
//
//  Created by zzl on 2017/3/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface collectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mlogo;

@property (weak, nonatomic) IBOutlet UILabel *mtitle;
@property (weak, nonatomic) IBOutlet UILabel *mprcie;
@property (weak, nonatomic) IBOutlet UIImageView *moutvailed;
@property (weak, nonatomic) IBOutlet UIImageView *mgou;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mgouconst;

@end
