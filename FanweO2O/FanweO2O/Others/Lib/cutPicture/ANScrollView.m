//
//  ANScrollView.m
//  test
//
//  Created by GuoMs on 16/1/28.
//  Copyright © 2016年 guoms. All rights reserved.
//

#import "ANScrollView.h"
#import "ANImageView.h"
@interface ANScrollView()<UIScrollViewDelegate>
@property (strong,nonatomic) ANImageView *imageview;
@end

@implementation ANScrollView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        [self setUp];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}



-(void)setUp{
    
    _imageview=[[ANImageView alloc]initWithFrame:self.bounds];
    _imageview.contentMode=UIViewContentModeScaleAspectFill;
    //_imageview.contentMode=UIViewContentModeCenter;
    _imageview.backgroundColor=[UIColor whiteColor];
    //_imageview.image=_image;
    self.bounces =NO;
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator=NO;
    self.scrollEnabled=NO;
    self.backgroundColor=[UIColor grayColor];
    // 缩放最大的比例
    self.maximumZoomScale = 2.5;
    // 缩放最小的比例
    self.minimumZoomScale = 0.3;
    [self addSubview:_imageview];
    
  
    self.delegate=self;
    
}


-(void)setImage:(UIImage *)image{
    _image=image;
    _imageview.image=image;
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageview;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    if (scrollView.contentSize.width>2*scrollView.frame.size.width) {
        self.scrollEnabled=YES;
        scrollView.contentSize=CGSizeMake(scrollView.contentSize.width+60, scrollView.contentSize.height+500);
    }else{
        self.scrollEnabled=NO;
    }
    CGPoint point=[self convertPoint:self.center fromView:self.superview];
    CGFloat xcenter = point.x , ycenter = point.y;
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width*0.5f : xcenter;
    
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height*0.5f : ycenter;
    _imageview.image=_image;
    _imageview.center = CGPointMake(xcenter, ycenter);
    
    

}

-(CGRect)getImageRectWithRect:(CGRect)rect{
    
    return [self.superview convertRect:rect toView:_imageview];
}
@end
