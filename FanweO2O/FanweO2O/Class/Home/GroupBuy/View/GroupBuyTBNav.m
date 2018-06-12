//
//  GroupBuyTBNav.m
//  FanweO2O
//
//  Created by ycp on 17/6/8.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "GroupBuyTBNav.h"

@implementation GroupBuyTBNav

+ (instancetype)EditNibFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}
- (void)setTitleText:(NSString *)titleText
{
    [_titleBtn setTitle:titleText forState:UIControlStateNormal];
    
}
- (IBAction)contenBtn:(id)sender {
    if ([_delegate respondsToSelector:@selector(contenBtn)]) {
        [_delegate contenBtn];
    }
}
- (IBAction)goBackBtn:(id)sender {
     [[AppDelegate sharedAppDelegate] popViewController];
}
- (IBAction)searchBtn:(id)sender {
    if ([_delegate respondsToSelector:@selector(searchBtn)]) {
        [_delegate searchBtn];
    }
}

@end
