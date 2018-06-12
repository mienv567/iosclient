//
//  ConsumptionView.m
//  FanweO2O
//
//  Created by ycp on 17/3/3.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ConsumptionView.h"
@implementation ConsumptionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.bigImageView =[MyOrderImageView createView];
        self.bigImageView.frame = CGRectMake(10, 10, 63, 63);
        [self addSubview:self.bigImageView];
        self.goodsName =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.bigImageView.frame)+10, 10, kScreenW-CGRectGetMaxX(self.bigImageView.frame)-10, 36)];
        self.goodsName.numberOfLines =2;
        self.goodsName.textAlignment=NSTextAlignmentLeft;
        self.goodsName.textColor=KAppMainTextBackColor;
        self.goodsName.font =KAppTextFont13;
        [self addSubview:self.goodsName];
        self.goodsTime =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.bigImageView.frame)+10, CGRectGetMaxY(self.goodsName.frame)+5, kScreenW-CGRectGetMaxX(self.bigImageView.frame)-10, 25)];
        self.goodsTime.textColor =[UIColor colorWithRed:0.651 green:0.651 blue:0.651 alpha:1.00];
        self.goodsTime.font=KAppTextFont13;
        [self addSubview:self.goodsTime];
        self.line =[[UILabel alloc] initWithFrame:CGRectMake(10, 63+20-1, kScreenW, 1)];
        self.line.hidden =YES;
        [self addSubview:self.line];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bigImageView.frame = CGRectMake(10, 10, 63, 63);
}


- (void)setModel:(ConsumptionModel *)model
{
    if (model ==nil) {
        return;
    }else
    {
        _model =model;
        [self.bigImageView.imageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
        self.goodsTime.text =[NSString stringWithFormat:@"有效期: %@",model.coupon_end_time];
        self.goodsName.text =model.name;
    }
}
- (void)setAModel:(ActivityModel *)aModel
{
    if (aModel ==nil) {
        return;
    }else
    {
        _aModel =aModel;
        [self.bigImageView.imageView sd_setImageWithURL:[NSURL URLWithString:aModel.icon]];
        self.goodsTime.text =[NSString stringWithFormat:@"使用期限: %@",aModel.event_end_time];
        self.goodsName.text =aModel.eName;
    }
}
- (void)setBackColor:(UIColor *)backColor
{
    if (backColor !=nil) {
        self.backgroundColor =backColor;
    }
}
- (void)setLineColor:(UIColor *)lineColor
{
    if (lineColor !=nil) {
        self.line.hidden =NO;
        self.line.backgroundColor =lineColor;
    }
}
@end
