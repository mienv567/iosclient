//
//  ClassSectionButton.m
//  FanweO2O
//
//  Created by hym on 2017/1/20.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ClassSectionButton.h"

@implementation ClassSectionButton

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.imageView.image) {
        
        self.titleLabel.frame = CGRectMake((CGRectGetWidth(self.frame) - CGRectGetWidth(self.titleLabel.frame) - 13)/2,0, CGRectGetWidth(self.titleLabel.frame), CGRectGetHeight(self.frame));
        self.imageView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+1, (CGRectGetHeight(self.frame) - 12)/2, 12, 12);
        
        //NSLog(@"tiles = %@",self.titleLabel.text);
    }
}

@end
