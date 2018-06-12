//
//  ButtonIcon.m
//  FanweO2O
//
//  Created by ycp on 16/12/5.
//  Copyright © 2016年 fanwe. All rights reserved.
//

#import "ButtonIcon.h"

@implementation ButtonIcon

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews {
    
    [super layoutSubviews];
    self.imageView.frame = CGRectMake((CGRectGetWidth(self.frame) - 40)/2,10 ,40 , 40);

    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame) , self.frame.size.width , 20);
}

@end
