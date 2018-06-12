//
//  O2OCommonNavigationBarView.h
//  FanweO2O
//
//  Created by 黄煜民 on 2017/6/6.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface O2OCommonNavigationBarView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lbTitles;

+ (O2OCommonNavigationBarView *)createView;

@end
