//
//  O2OCommonNavigationBarView.m
//  FanweO2O
//
//  Created by 黄煜民 on 2017/6/6.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "O2OCommonNavigationBarView.h"


@interface O2OCommonNavigationBarView()



@end


@implementation O2OCommonNavigationBarView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.lbTitles setTextColor:kAppFontColorComblack];
}

- (IBAction)onClickBack:(id)sender {
    
    [[AppDelegate sharedAppDelegate] popViewController];
}

+ (O2OCommonNavigationBarView *)createView {
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSArray *objs = [bundle loadNibNamed:@"O2OCommonNavigationBarView" owner:nil options:nil];
    O2OCommonNavigationBarView *view = [objs firstObject];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    
    return view;
    
}

@end
