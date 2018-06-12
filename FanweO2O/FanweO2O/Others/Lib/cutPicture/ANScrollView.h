//
//  ANScrollView.h
//  test
//
//  Created by GuoMs on 16/1/28.
//  Copyright © 2016年 guoms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANScrollView : UIScrollView
@property (strong,nonatomic) UIImage *image;

-(CGRect)getImageRectWithRect:(CGRect)rect;
@end
