//
//  BrandCustomView.m
//  FanweO2O
//
//  Created by ycp on 17/1/22.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BrandCustomView.h"
#define RandomColor [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1] //随机颜色
@implementation BrandCustomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor clearColor];
        _brandArray =[NSMutableArray array];
        _view =[[UIView alloc] init];
        _view.frame =CGRectMake(0, 0, kScreenW, kScreenH/3);
        _view.backgroundColor =[UIColor colorWithRed:0.973 green:0.980 blue:0.980 alpha:1.00];
        [self addSubview:_view];
        
        _hiddenLabel =[[UILabel alloc] init];
        _hiddenLabel.frame =CGRectMake(0, 0, kScreenW, 60);
        _hiddenLabel.text =@"暂无品牌";
        _hiddenLabel.textAlignment =NSTextAlignmentCenter;
        _hiddenLabel.textColor =KAppMainTextBackColor;
        _hiddenLabel.font =KAppTextFont13;
        _hiddenLabel.hidden =YES;
        [_view addSubview:_hiddenLabel];

        [self addSubview:_view];
        _btn1 =[UIButton buttonWithType:UIButtonTypeCustom];
        [_btn1 setTitle:@"重置" forState:UIControlStateNormal];
        [_btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn1 setBackgroundColor: [UIColor whiteColor]];
         _btn1.titleLabel.font =KAppTextFont13;
        [_btn1 addTarget:self action:@selector(btn1Click) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn1];
        
        _btn2 =[UIButton buttonWithType:UIButtonTypeCustom];
        [_btn2 setTitle:@"确定" forState:UIControlStateNormal];
        [_btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn2 setBackgroundColor: [UIColor colorWithRed:1.000 green:0.133 blue:0.267 alpha:1.00]];
        _btn2.titleLabel.font =KAppTextFont13;
        [_btn2 addTarget:self action:@selector(btn2Click) forControlEvents:UIControlEventTouchUpInside];
       
        [self addSubview:_btn2];
       
//        UILabel *lineLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_view.frame), kScreenW, 1)];
//        lineLabel.backgroundColor =[UIColor colorWithRed:0.973 green:0.980 blue:0.980 alpha:1.00];
//        [self addSubview:lineLabel];
        
       
        
        _scrollView =[[UIScrollView alloc] init];
        _scrollView.indicatorStyle =UIScrollViewIndicatorStyleBlack;
        [_scrollView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_scrollView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(brandRefresh) name:@"noticeBrand" object:nil];
        
        
    }
    return self;
}
- (void)setModel:(ClassSectionDataModel *)model
{
//    for (UIView *view in self.subviews) {
//        if ([view isKindOfClass:[UIButton class]]) {
//            [view removeFromSuperview];
//        }
//    }
//    for (int i =0; i<_model.brand_list.count; i++) {
//        UIButton *btn = [_scrollView viewWithTag:i+10086];
//        [btn removeFromSuperview];
//    }
    if (model.brand_list.count ==0) {
        _view.frame =CGRectMake(0, 0, kScreenW, 60);
        _hiddenLabel.hidden =NO;
        _btn1.frame =CGRectMake(0,CGRectGetMaxY(_view.frame), kScreenW/2, 44);
        _btn2.frame =CGRectMake((kScreenW/2),CGRectGetMaxY(_view.frame), kScreenW/2, 44);
        _scrollView.frame =self.view.frame;
       
    }else
    {
        if (model.brand_list.count/2>=4) {
            _view.frame =CGRectMake(0, 0, kScreenW, kScreenH/3);
            
        }else
        {
            if (model.brand_list.count%2==1) {
               _view.frame =CGRectMake(0, 0, kScreenW, model.brand_list.count/2*40+40+10);
            }else
            {
                _view.frame =CGRectMake(0, 0, kScreenW, model.brand_list.count/2*40+10);
            }
            
        }
        _scrollView.frame =self.view.frame;
        _btn1.frame =CGRectMake(0,CGRectGetMaxY(_view.frame), kScreenW/2, 44);
        _btn2.frame =CGRectMake((kScreenW/2),CGRectGetMaxY(_view.frame), kScreenW/2, 44);
        _hiddenLabel.hidden =YES;
        _model =model;
        _scrollView.contentSize =CGSizeMake(kScreenW, model.brand_list.count/2*40+10);
        for (int i =0; i<model.brand_list.count; i ++) {
            _brandBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            _brandBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft ;
            _brandBtn.frame =CGRectMake(10+(i%2)*(10+(kScreenW-30)/2), 10+40*(i/2), (kScreenW-30)/2, 40);
            ClassBrand_list *a =model.brand_list[i];
            [_brandBtn setTitle:a.name forState:UIControlStateNormal];
            
            [_brandBtn setTitleColor:KAppMainTextBackColor forState:UIControlStateNormal];
            [_brandBtn setImage:[UIImage imageNamed:@"gray_gou"] forState:UIControlStateNormal];
            [_brandBtn setTitleColor:[UIColor colorWithRed:1.000 green:0.133 blue:0.267 alpha:1.00] forState:UIControlStateSelected];
            [_brandBtn setImage:[UIImage imageNamed:@"red_gou"] forState:UIControlStateSelected];
            [_brandBtn setImageEdgeInsets:UIEdgeInsetsMake(0, (kScreenW/2-30), 0, 0)];
            _brandBtn.titleLabel.font =KAppTextFont13;
            _brandBtn.tag =i +10086;
            [_brandBtn addTarget:self action:@selector(brandClickButton:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:_brandBtn];
        }
    }
    
    
}
- (void)brandClickButton:(UIButton *)btn
{
    
    if (!btn.selected ) {
        [_brandArray addObject:_model.brand_list[btn.tag-10086]];
        
    }else
    {
        [_brandArray removeObject:_model.brand_list[btn.tag-10086]];

    }
    btn.selected =! btn.selected;
   
}
- (void)btn1Click
{
    for (int i =0; i<_model.brand_list.count; i++) {
        UIButton *btn = [_scrollView viewWithTag:i+10086];
        [btn removeFromSuperview];
    }
    [self setModel:_model];
    [_brandArray removeAllObjects];
}
- (void)btn2Click{
    if (_delegate && [_delegate respondsToSelector:@selector(brand:)]) {
        [_delegate brand:_brandArray];
    }
}

- (void)brandRefresh
{
    for (int i =0; i<_model.brand_list.count; i++) {
        UIButton *btn = [_scrollView viewWithTag:i+10086];
        [btn removeFromSuperview];
    }
    [self setModel:_model];
    [_brandArray removeAllObjects];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_delegate && [_delegate respondsToSelector:@selector(goBackBrandView)]) {
        [_delegate goBackBrandView];
    }
}
@end
