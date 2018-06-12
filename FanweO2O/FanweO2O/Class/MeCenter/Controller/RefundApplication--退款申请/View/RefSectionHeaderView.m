//
//  RefSectionHeaderView.m
//  FanweO2O
//
//  Created by ycp on 17/3/14.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "RefSectionHeaderView.h"

@implementation RefSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor colorWithRed:0.953 green:0.965 blue:0.961 alpha:1.00];
        [self initialize];
    }
    return self;
}
- (void)initialize
{
    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 46)];
    view.backgroundColor =[UIColor whiteColor];
    [self addSubview:view];
    
    UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 16, 16)];
    imageView.centerY =view.centerY;
    imageView.image =[UIImage imageNamed:@"my_ store"];
    [view addSubview:imageView];
    
    self.storeLabel =[[UILabel alloc] init];
    self.storeLabel.textAlignment =NSTextAlignmentLeft;
    self.storeLabel.font  =KAppTextFont13;
    [view addSubview:self.storeLabel];
    
    self.imageIcon=[[UIImageView alloc] init];
    self.imageIcon.image =[UIImage imageNamed:@"arrow_right"];
    [view addSubview:self.imageIcon];
    
}
- (void)setModel:(RefundApplicationModel *)model
{
    if (model != nil) {
        CGSize wide =[model.supplier_name boundingRectWithSize:CGSizeMake(kScreenW-36-26, 46) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KAppTextFont13} context:nil].size;
        self.storeLabel.frame =CGRectMake(36, 0, wide.width, 46);
        self.storeLabel.text =model.supplier_name;
        self.imageIcon.frame =CGRectMake(CGRectGetMaxX(self.storeLabel.frame), (46-16)/2, 16, 16);
    }
}
@end
