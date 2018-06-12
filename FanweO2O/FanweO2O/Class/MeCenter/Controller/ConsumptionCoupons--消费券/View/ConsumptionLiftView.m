//
//  ConsumptionLiftView.m
//  FanweO2O
//
//  Created by ycp on 17/3/6.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ConsumptionLiftView.h"
#define MHEIGHT1 45
#define MHEIGHT2 47
@implementation ConsumptionLiftView

- (instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        [self initialize];
        
    }
    return  self;
}
- (void)initialize{
    self.oderNumber =[[UILabel alloc] init];
    self.oderNumber.frame =CGRectMake(10,0 , kScreenW-10, MHEIGHT1-1);
    self.oderNumber.textColor =[UIColor colorWithRed:0.631 green:0.631 blue:0.631 alpha:1.00];
    self.oderNumber.font =kAppTextFont12;
    [self addSubview:self.oderNumber];
    
    UILabel *line1 =[[UILabel alloc] initWithFrame:CGRectMake(10,MHEIGHT1-1 , kScreenW-10, 1)];
    line1.backgroundColor =[UIColor colorWithRed:0.973 green:0.976 blue:0.980 alpha:1.00];
    [self addSubview:line1];
    
    self.storesIcon =[[UIImageView alloc]init];
    self.storesIcon.frame =CGRectMake(10,CGRectGetMaxY(self.oderNumber.frame)+(MHEIGHT2-20)/2, 20, 20);
    self.storesIcon.image =[UIImage imageNamed:@"my_ store"];
    [self addSubview:self.storesIcon];
    
    self.arrowImageView =[[UIImageView alloc]init];
    self.arrowImageView.frame =CGRectMake(kScreenW -26,CGRectGetMaxY(self.oderNumber.frame)+ (MHEIGHT2-16)/2, 16, 16);
    self.arrowImageView.image =[UIImage imageNamed:@"arrow_right"];
     [self addSubview:self.arrowImageView];
    self.storesNumberLabel =[[UILabel alloc] init];
    self.storesNumberLabel.frame =CGRectMake(kScreenW-80-16, CGRectGetMaxY(self.oderNumber.frame), 70, MHEIGHT2);
    self.storesNumberLabel.font =kAppTextFont12;
    self.storesNumberLabel.textAlignment =NSTextAlignmentRight;
    self.storesNumberLabel.textColor =[UIColor colorWithRed:0.631 green:0.631 blue:0.631 alpha:1.00];
    [self addSubview:self.storesNumberLabel];
    
    self.storesName =[[UILabel alloc] init];
    self.storesName.frame =CGRectMake(CGRectGetMaxX(self.storesIcon.frame)+10,CGRectGetMaxY(self.oderNumber.frame), 280, MHEIGHT2);
    self.storesName.font =kAppTextFont12;
    [self addSubview:self.storesName];
    
    UILabel *line2 =[[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(self.storesName.frame)-1 , kScreenW-10, 1)];
    line2.backgroundColor =[UIColor colorWithRed:0.973 green:0.976 blue:0.980 alpha:1.00];
    [self addSubview:line2];

}
- (void)setModel:(ConsumptionModel *)model
{
    if (model != nil) {
        self.oderNumber.text =[NSString stringWithFormat:@"订单编号:%@",model.order_sn];
        self.storesName.text =model.supplier_name;
        self.storesNumberLabel.text =[NSString stringWithFormat:@"共%@件商品",model.all_number];
    }
}
- (void)setPModel:(PickUpGoodsModel *)pModel
{
    if (pModel != nil) {
        self.oderNumber.text =[NSString stringWithFormat:@"订单编号:%@",pModel.order_sn];
        self.storesName.text =pModel.dist_name;
        self.storesNumberLabel.text =[NSString stringWithFormat:@"共%@件商品",pModel.number];
    }
}
@end
