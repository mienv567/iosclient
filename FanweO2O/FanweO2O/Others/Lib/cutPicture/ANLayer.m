//
//  ANLayer.m
//  test
//
//  Created by GuoMs on 16/1/28.
//  Copyright © 2016年 guoms. All rights reserved.
//

#import "ANLayer.h"
#import <UIKit/UIKit.h>
#define BordWidth 1
@interface ANLayer()
@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;

@end

@implementation ANLayer


-(void)drawInContext:(CGContextRef)ctx{
    
   
    _width=_size.width+2*BordWidth;
    _height=_size.height+2*BordWidth;
    _x=(self.frame.size.width-_width)*0.5;
    _y=(self.frame.size.height-_height)*0.5;
    _rect=CGRectMake(_x, _y, _width, _height);
    
    CGContextSetRGBStrokeColor(ctx, 0.6, 0.6, 0.6, 1);
    CGFloat lengths[] = {10,6};
    CGContextSetLineDash(ctx, 0, lengths, 2);
    CGContextSetLineWidth(ctx, BordWidth);

    NSLog(@"%@",NSStringFromCGRect(_rect));
    
    CGContextAddRect(ctx, _rect);
    //CGContextFillPath(ctx);
    CGContextStrokePath(ctx);
}

-(void)setSize:(CGSize)size{
    _size=size;
    _width=_size.width;
    _height=_size.height;
    _x=(self.frame.size.width-_width)*0.5;
    _y=(self.frame.size.height-_height)*0.5;
    _rect=CGRectMake(_x, _y, _width, _height);
    
}


@end
