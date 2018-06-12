//
//  UIView+CutLayer.m
//  test
//
//  Created by GuoMs on 16/1/29.
//  Copyright © 2016年 guoms. All rights reserved.
//

#import "UIView+CutLayer.h"

@implementation UIView (CutLayer)

-(UIImage *)CutLayerWithFrame:(CGRect)rect{
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    [self.layer renderInContext:ctx];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
  
    
    
    
    CGImageRef iamgeRef=image.CGImage;
    int width = CGImageGetWidth(iamgeRef);
    int height = CGImageGetHeight(iamgeRef);
    CGSize iamgesize=CGSizeMake(width, height);
    CGFloat widthRate = rect.size.width/self.bounds.size.width;
    CGFloat heightRate = rect.size.height/self.bounds.size.height;
    CGFloat XRate = rect.origin.x/self.bounds.size.width;
    CGFloat YRate = rect.origin.y/self.bounds.size.height;
    CGRect cutRect=CGRectMake(iamgesize.width*XRate, iamgesize.height*YRate,iamgesize.width*widthRate, iamgesize.height*heightRate);
    
    CGImageRef newImageRef=CGImageCreateWithImageInRect(iamgeRef, cutRect);
    
    return [UIImage imageWithCGImage:newImageRef];
    
    
    
    
    
    
    
//    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
//    CGContextRef ctx2=UIGraphicsGetCurrentContext();
//    CGContextAddRect(ctx2, rect);
//    CGContextClip(ctx2);
//    [image drawInRect:self.bounds];
//    UIImage *imagetwo=UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return imagetwo;
   
//    CGImageRef imageRef=imagetwo.CGImage;
//    CGSize size=imagetwo.size;
//    CGFloat x=(size.width-rect.size.width*2)*0.5;
//    CGFloat y=(size.height-rect.size.height*2)*0.5;
//    CGImageRef newimage=CGImageCreateWithImageInRect(imageRef, CGRectMake(x, y, rect.size.width*2, rect.size.height*2));
//    
//    return [UIImage imageWithCGImage:newimage];
    
//    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
//    //CGContextRef ctx3=UIGraphicsGetCurrentContext();
//
//    [imagetwo drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
//    [imagetwo drawInRect:<#(CGRect)#> blendMode:<#(CGBlendMode)#> alpha:<#(CGFloat)#>]
//    UIImage *imagethree=UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return imagethree;

}

@end
