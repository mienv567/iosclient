//
//  UIView+Layout.m
//  CommonLibrary
//
//  Created by Alexi Chen on 2/28/13.
//  Copyright (c) 2013 AlexiChen. All rights reserved.
//

#import "UIView+Layout.h"

@implementation UIView (Layout)
@dynamic top;
@dynamic bottom;
@dynamic left;
@dynamic right;

@dynamic width;
@dynamic height;

@dynamic size;

@dynamic x;
@dynamic y;
- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.size.height + self.frame.origin.y;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.size.width + self.frame.origin.x;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)value
{
    CGRect frame = self.frame;
    frame.origin.x = value;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)value
{
    CGRect frame = self.frame;
    frame.origin.y = value;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (id)init
{
    if (self = [self initWithFrame:CGRectZero]) {
        
        if (![self isAutoLayout])
        {
            [self addOwnViews];
            [self configOwnViews];
        }
        else
        {
            [self autoLayoutSubViews];
        }
        
    }
    return self;
}

- (BOOL)isAutoLayout
{
    return NO;
}

- (void)autoLayoutSubViews
{
    
}

- (void)addOwnViews
{
    // 添加自己的控件
}

- (void)configOwnViews
{
    // 初始化控件的值
}

//- (void)configWith:(NSMutableDictionary *)jsonDic
//{
//    
//}

- (void)setFrameAndLayout:(CGRect)rect
{
    self.frame = rect;
    if (self.bounds.size.width != 0 && self.bounds.size.height != 0)
    {
        [self relayoutFrameOfSubViews];
    }
}
- (void)relayoutFrameOfSubViews
{
    // do nothing here
}

- (void)addBottomLine:(CGRect)rect
{
    [self addBottomLine:kLightGrayColor inRect:rect];
}

- (void)addBottomLine:(UIColor *)color inRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    //Set the stroke (pen) color
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 1.0);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
   	CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    
    CGContextStrokePath(context);
    
    UIGraphicsPopContext();
}

@end


@implementation UIView (ShakeAnimation)

- (void)shake
{
    CGFloat t =4.0;
    CGAffineTransform translateRight = CGAffineTransformTranslate(CGAffineTransformIdentity, t, 0.0);
    CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, 0.0);
    self.transform = translateLeft;
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        self.transform = translateRight;
    } completion:^(BOOL finished) {
        if(finished)
        {
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

@end
