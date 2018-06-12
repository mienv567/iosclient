//
//  UIImage+GIF.h
//  LBGIFImage
//
//  Created by Laurin Brandner on 06.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NTalkerGIF)

+ (UIImage *)NTalkersd_animatedGIFNamed:(NSString *)name;

+ (UIImage *)NTalkersd_animatedGIFWithData:(NSData *)data;

- (UIImage *)NTalkersd_animatedImageByScalingAndCroppingToSize:(CGSize)size;

@end
