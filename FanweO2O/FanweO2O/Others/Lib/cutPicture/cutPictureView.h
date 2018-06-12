//
//  cutPictureView.h
//  test
//
//  Created by GuoMs on 16/1/28.
//  Copyright © 2016年 guoms. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol cutPictureViewDelegate <NSObject>

-(void)imageDidCut:(UIImage *)image;

@end

@interface cutPictureView : UIView

@property (weak,nonatomic) UIViewController *control;
+(instancetype)cutPicture;

@property (nonatomic,assign) CGSize size;
@property (nonatomic,strong) UIImage *image;
@property (weak,nonatomic) id<cutPictureViewDelegate> delegate;
@end
