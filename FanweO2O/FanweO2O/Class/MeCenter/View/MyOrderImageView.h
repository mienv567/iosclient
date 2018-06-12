//
//  MyOrderImageView.h
//  FanweO2O
//
//  Created by hym on 2017/3/15.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXNibBridge.h"
@interface MyOrderImageView : UIView <XXNibBridge>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

+ (instancetype )createView;

@end
