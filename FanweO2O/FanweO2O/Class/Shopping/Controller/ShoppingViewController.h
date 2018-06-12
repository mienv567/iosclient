//
//  ShoppingViewController.h
//  FanweO2O
//
//  Created by ycp on 16/11/25.
//  Copyright © 2016年 fanwe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseWebController.h"

@interface ShoppingViewController : BaseWebController
@property (nonatomic,readonly) int   lastSekectdIndex;

+(instancetype)webControlerWithUrlString:(NSString *)urlStr andNavTitle:(NSString *)navTitle isShowIndicator:(BOOL)isShowIndicator isHideNavBar:(BOOL)isHideNavBar isHideTabBar:(BOOL)isHideTabBar;
@end
