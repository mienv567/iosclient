//
//  LFLUISegmentedControl.m
//  SegmentedLFL
//
//  Created by vintop_xiaowei on 16/1/2.
//  Copyright © 2016年 vintop_DragonLi. All rights reserved.
//

#import "LFLUISegmentedControl.h"

@interface LFLUISegmentedControl ()<LFLUISegmentedControlDelegate>

@property(nonatomic,strong)NSMutableArray *ButtonArray;/**< 对应的标题文字 */

@property (nonatomic ,assign)CGFloat widthFloat;

@property (nonatomic ,strong)UIView* buttonDown;

@property (nonatomic ,assign)NSInteger selectSeugment;

/// BackGround颜色,默认底色为白色
@property(strong,nonatomic)UIColor *LFLBackGroundColor;
/// 标题文字颜色 ,默认黑色
@property(strong,nonatomic)UIColor *titleColor;/**< , */
///  选中标题按钮的颜色,默认黑色
@property(strong,nonatomic)UIColor *selectColor;/**<  */
/// 默认字体  14
@property(strong,nonatomic)UIFont *titleFont;/**< 字体大小 */
@end

@implementation LFLUISegmentedControl

+ (instancetype)segmentWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray defaultSelect:(NSInteger)defaultSelect{
    LFLUISegmentedControl *segment = [[LFLUISegmentedControl alloc]initWithFrame:frame];
    [segment AddSegumentArray:titleArray];
    [segment selectTheSegument:defaultSelect];
    return segment;
}

+ (instancetype)segmentWithFrame:(CGRect)frame
                      titleArray:(NSArray *)titleArray
                   defaultSelect:(NSInteger)defaultSelect
                      widthFloat:(CGFloat)widthFloat {
    LFLUISegmentedControl *segment = [[LFLUISegmentedControl alloc]initWithFrame:frame];
    segment.widthFloat = widthFloat;
    [segment AddSegumentArray:titleArray];
    [segment selectTheSegument:defaultSelect];
    
    return segment;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    self.selectSeugment=0;
    self.ButtonArray=[NSMutableArray arrayWithCapacity:_ButtonArray.count];
    self.titleFont=[UIFont systemFontOfSize:14.0];
    self=[super initWithFrame:frame];
    self.titleColor = [UIColor blackColor];
    self.selectColor=[UIColor blackColor];
    //    整体背景颜色
    self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)AddSegumentArray:(NSArray *)SegumentArray
{
    NSInteger seugemtNumber = SegumentArray.count;
    
    if (self.widthFloat == 0) {
       self.widthFloat = (self.bounds.size.width)/seugemtNumber;
    }
    
    UIScrollView *ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 0.5)];
    [ScrollView setContentSize:CGSizeMake(self.widthFloat * seugemtNumber, CGRectGetHeight(self.frame) - 0.5)];
    //ScrollView.bounces = NO;
    ScrollView.showsVerticalScrollIndicator = NO;
    ScrollView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:ScrollView];
    
    for (int i = 0; i < SegumentArray.count; i++) {
        UIButton* button=[[UIButton alloc]initWithFrame:CGRectMake( i * self.widthFloat, 0, self.widthFloat, self.bounds.size.height-2)];
        [button setTitle:SegumentArray[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:self.titleFont];
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectColor forState:UIControlStateSelected];
        [button setTag:i];
        [button addTarget:self action:@selector(changeTheSegument:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            //            默认下划线高  2
            self.buttonDown=[[UIView alloc]initWithFrame:CGRectMake(i* self.widthFloat, self.bounds.size.height -2, self.widthFloat, 2)];
            
#pragma mark -----buttonDown 设置下划线颜色
            [ self.buttonDown setBackgroundColor:[UIColor redColor]];
            [ScrollView addSubview: self.buttonDown];
        }
        [ScrollView addSubview:button];
        [self.ButtonArray addObject:button];
    }
    [[self.ButtonArray firstObject] setEnabled:NO];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,self.bounds.size.height - 0.5, SCREEN_WIDTH, 0.5)];
    [line setBackgroundColor:kLineColor];
    [self addSubview:line];
    
}
-(void)changeTheSegument:(UIButton*)button
{
    [self selectTheSegument:button.tag];
}
-(void)selectTheSegument:(NSInteger)segument
{
    if ( self.selectSeugment!=segument) {
        [self.ButtonArray[ self.selectSeugment] setEnabled:YES];
        [self.ButtonArray[segument] setEnabled:NO];
        [UIView animateWithDuration:0.1 animations:^{
            [ self.buttonDown setFrame:CGRectMake(segument * self.widthFloat,self.bounds.size.height-2,  self.widthFloat, 2)];
        }];
         self.selectSeugment=segument;
        [self.delegate uisegumentSelectionChange: self.selectSeugment];
    }
}

- (void)lineColor:(UIColor *)color{
    self.buttonDown.backgroundColor = color;
}

#pragma mark setter  
- (void)titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectTitleColor BackGroundColor:(UIColor *)BackGroundColor titleFontSize:(CGFloat)size{
    if (BackGroundColor) self.backgroundColor = BackGroundColor;
    for (UIView *view in self.subviews) {
        if ([[view class] isSubclassOfClass:[UIButton class]]) {
            UIButton *button =(UIButton *) view;
          if (titleColor)  [button setTitleColor:titleColor forState:UIControlStateNormal];
          if (selectTitleColor)  [button setTitleColor:selectTitleColor forState:UIControlStateDisabled];
            if (size) [button.titleLabel setFont:[UIFont systemFontOfSize:size]];
        }
    }
}
@end
