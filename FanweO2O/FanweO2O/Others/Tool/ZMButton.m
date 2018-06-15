//
//  ZMButton.m
//  MyBoRuiSi
//
//  Created by baoqiang song on 2017/7/6.
//  Copyright © 2017年 itcast.com. All rights reserved.
//

#import "ZMButton.h"

@implementation ZMButton

- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.imageView.y = 0;
//    self.imageView.centerX = self.width*0.5;
//    [self.titleLabel sizeToFit];
//
//    self.titleLabel.centerX = self.width*0.5;
//    self.titleLabel.y = self.height - self.titleLabel.height;
    
    
    self.imageView.y = 0;
    self.imageView.centerX = self.width * 0.5;
    
    // bug:控件莫名其妙往右边挪动,可能是中心点导致
    // 设置label宽度
    //    CGFloat textW = [self.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:15]].width;
    //    self.titleLabel.xmg_width = textW;
    // 会自动根据文字计算内容,并且设置label尺寸
    [self.titleLabel sizeToFit];
    
    
    self.titleLabel.centerX = self.width * 0.5;
    self.titleLabel.y = self.height - self.titleLabel.height;
    
}
@end
