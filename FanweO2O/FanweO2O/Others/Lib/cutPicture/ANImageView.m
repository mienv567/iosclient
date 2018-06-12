//
//  ANImageView.m
//  test
//
//  Created by apple on 16/1/28.
//  Copyright © 2016年 guoms. All rights reserved.
//

#import "ANImageView.h"
@interface ANImageView ()

@end

@implementation ANImageView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        self.userInteractionEnabled=YES;
    }
    return self;
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    CGPoint current=[touch locationInView:self];
    CGPoint previous=[touch previousLocationInView:self];
    
    CGPoint center=self.center;
    center.x+=current.x-previous.x;
    center.y+=current.y-previous.y;
    self.center=center;
}

@end
