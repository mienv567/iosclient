//
//  DisplayStarView.m
//  阿达21321
//
//  Created by ycp on 17/2/6.
//  Copyright © 2017年 fanwe. All rights reserved.
//

#import "DisplayStarView.h"

@implementation DisplayStarView

@synthesize starSize = _starSize;
@synthesize maxStar = _maxStar;
@synthesize showStar = _showStar;
@synthesize emptyColor = _emptyColor;
@synthesize fullColor = _fullColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        //默认的星星的大小是 13.0f
        self.starSize = 15.0f;
        //未点亮时的颜色是 灰色的
        self.emptyColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1.00];
        //点亮时的颜色是 亮黄色的
        self.fullColor = [UIColor colorWithRed:1.000 green:0.659 blue:0.000 alpha:1.00];
        //默认的长度设置为100
        self.maxStar = 100;
    }
    
    return self;
}

//重绘视图
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSString* stars = @"★★★★★";
    
    rect = self.bounds;
    UIFont *font = [UIFont boldSystemFontOfSize:_starSize];
    CGSize starSize = [stars sizeWithFont:font];
    rect.size=starSize;
    [_emptyColor set];
    [stars drawInRect:rect withFont:font];
    
    CGRect clip = rect;
    clip.size.width = clip.size.width * _showStar / _maxStar;
    CGContextClipToRect(context,clip);
    [_fullColor set];
    [stars drawInRect:rect withFont:font];

}



@end
