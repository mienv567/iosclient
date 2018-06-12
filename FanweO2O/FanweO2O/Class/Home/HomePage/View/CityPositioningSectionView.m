//
//  CityPositioningSectionView.m
//  FanweO2O
//
//  Created by ycp on 16/12/14.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "CityPositioningSectionView.h"

@implementation CityPositioningSectionView

- (instancetype)initWithFrame:(CGRect)frame  sectionName:(NSString*)name
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *back =[[UIView alloc] init];
        [self addSubview:back];
        UILabel *line =[[UILabel alloc] initWithFrame:CGRectMake(0, (30-0.5)/2, 30, 0.5)];
        line.backgroundColor =K_O2OLineColor;
        [back addSubview:line];
         CGSize titleSize =[name boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
        UILabel *nameLable =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line.frame)+5, 0, titleSize.width, 30)];
        nameLable.font =[UIFont systemFontOfSize:16];
        nameLable.text =name;
        nameLable.textColor =[UIColor blackColor];
        [back addSubview:nameLable];
        UILabel *line2 =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLable.frame)+5, (30-0.5)/2, 30, 0.5)];
        line2.backgroundColor =K_O2OLineColor;
        [back addSubview:line2];
        back.frame =CGRectMake((kScreenW-CGRectGetMaxX(line2.frame))/2, 0, CGRectGetMaxX(line2.frame), 30);
    }
    return self;
}

@end
