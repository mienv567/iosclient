//
//  SectionHeaderView.m
//  FanweO2O
//
//  Created by ycp on 16/12/9.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "SectionHeaderView.h"

@implementation SectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString*)imageName titleName:(NSString*)titleName
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *backView =[[UIView alloc] init];
        [self addSubview:backView];
        UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(0, 20, 30, 0.5)];
        label.backgroundColor =RGB(132, 212, 211);
        [backView addSubview:label];
        UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+5, 10, 15, 20)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image=[UIImage imageNamed:imageName];
        [backView addSubview:imageView];
        
        
        CGSize titleSize =[titleName boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
        UILabel *label2 =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+5, 10,titleSize.width, 20)];
        label2.textColor = RGB(132, 212, 211);
        label2.text=titleName;
        label2.font =[UIFont systemFontOfSize:13];
        [label2 layoutIfNeeded];
        [backView addSubview:label2];
        UILabel *label3 =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame) + 3, 20, 30, 0.5)];
        label3.backgroundColor = RGB(132, 212, 211);
        
        [backView addSubview:label3];
        
        CGFloat width =CGRectGetWidth(label.frame) +CGRectGetWidth(imageView.frame)+CGRectGetWidth(label2.frame)+CGRectGetWidth(label3.frame)+15;
        backView.frame =CGRectMake((kScreenW-width)/2,0, width, 40);
        
    }
    return self;
}
@end
