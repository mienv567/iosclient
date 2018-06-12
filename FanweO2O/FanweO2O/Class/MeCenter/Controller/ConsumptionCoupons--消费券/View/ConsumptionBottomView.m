//
//  ConsumptionBottomView.m
//  FanweO2O
//
//  Created by ycp on 17/3/3.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ConsumptionBottomView.h"

@implementation ConsumptionBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        CGRect width =[@"点击展开" boundingRectWithSize:CGSizeMake(kScreenW, 46) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KAppTextFont13,NSBackgroundColorAttributeName:KAppMainTextBackColor} context:nil];
        self.clickLabel =[[UILabel alloc ] initWithFrame:CGRectMake((kScreenW-width.size.width)/2, 0, width.size.width, 46)];
        self.clickLabel.textAlignment =NSTextAlignmentCenter;
        self.clickLabel.textColor =KAppMainTextBackColor;
        self.clickLabel.font =KAppTextFont13;
        [self addSubview:self.clickLabel];
        self.imageIcon =[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.clickLabel.frame), (46-20)/2, 20, 20)];
        [self addSubview:self.imageIcon];
        UIView *grayView =[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.clickLabel.frame), kScreenW, 10)];
        grayView.backgroundColor =[UIColor colorWithRed:0.953 green:0.965 blue:0.961 alpha:1.00];
        [self addSubview:grayView];
        
    }
    return self;
}
- (void)setType:(NSString *)type
{
    _type =type;
    if ([_type integerValue] ==1) {
        _clickLabel.text =@"点击展开";
        _imageIcon.image =[UIImage imageNamed:@"me_downArrow"];
    }else
    {
        _clickLabel.text =@"点击收起";
         _imageIcon.image =[UIImage imageNamed:@"me_upArrow"];
    }
}
@end
