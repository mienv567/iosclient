//
//  PreferentialView.m
//  FanweO2O
//
//  Created by ycp on 17/3/7.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "PreferentialView.h"

@implementation PreferentialView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        [self initialize:frame];
    }
    return self;
}
- (void)initialize:(CGRect)frame
{
    
    self.youhuiName =[[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenW-120, 36)];
    self.youhuiName.textColor =KAppMainTextBackColor;
    self.youhuiName.textAlignment =NSTextAlignmentLeft;
    self.youhuiName.font =KAppTextFont13;
    self.youhuiName.numberOfLines =2;
    [self addSubview:self.youhuiName];
    
    self.userTime =[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.youhuiName.frame), kScreenW-120, 25)];
    self.userTime.textColor =[UIColor colorWithRed:0.600 green:0.600 blue:0.600 alpha:1.00];
    self.userTime.textAlignment =NSTextAlignmentLeft;
    self.userTime.font =KAppTextFont13;
    self.userTime.numberOfLines =0;
    [self addSubview:self.userTime];
    
    self.price =[[UILabel alloc] initWithFrame:CGRectMake(kScreenW-110, 10, 100, frame.size.height-20)];
    self.price.textColor =[UIColor colorWithRed:1.000 green:0.133 blue:0.267 alpha:1.00];
    self.price.textAlignment =NSTextAlignmentRight;
    self.price.numberOfLines =0;
    [self addSubview:self.price];
    
    UILabel *line =[[UILabel alloc] initWithFrame:CGRectMake(10, 86-1, kScreenW, 1)];
    line.backgroundColor =[UIColor colorWithRed:0.953 green:0.965 blue:0.961 alpha:1.00];
    [self addSubview:line];
}
- (void)setPModel:(PreferentialModel *)pModel
{
    NSString *str;
    if (pModel !=nil) {
        self.youhuiName.text =pModel.yName;
        self.userTime.text =[NSString stringWithFormat:@"使用期限: %@",pModel.expire_time];
        
        if ([pModel.youhui_type integerValue] ==0) {
            if (pModel.youhui_value.length ==1) {
                str =[NSString stringWithFormat:@"¥ %@.0",pModel.youhui_value];
            }else
            {
                 str =[NSString stringWithFormat:@"¥ %@",pModel.youhui_value];
            }
            //判断字符串中是否有小数点
            if ([str rangeOfString:@"."].location !=NSNotFound) {
                NSRange range =[str rangeOfString:@"."];
                NSMutableAttributedString *string =[[NSMutableAttributedString alloc] initWithString:str];
                [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0] range:NSMakeRange(0, 1)];
                //最开始的字符串到小数点的位置
                [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:40.0] range:NSMakeRange(1, range.location)];
                //小数点的位置到最后字符的位置 (需要减去小数点之前的location才可以)
                [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0] range:NSMakeRange(range.location,string.length-range.location)];
                self.price.attributedText =string;

            }else{
                 NSMutableAttributedString *string =[[NSMutableAttributedString alloc] initWithString:str];
                [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0] range:NSMakeRange(0, 1)];
                [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:40.0] range:NSMakeRange(1, string.length-1)];
                self.price.attributedText =string;
            }
            
        }else{
            str =[NSString stringWithFormat:@"%.1f折",[pModel.youhui_value floatValue]/10];
            NSRange range =[str rangeOfString:@"."];
            NSMutableAttributedString *string =[[NSMutableAttributedString alloc] initWithString:str];
            [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:40.0] range:NSMakeRange(0, range.location)];
            [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0] range:NSMakeRange(range.location,string.length-range.location)];
            self.price.attributedText =string;
        }
    }
}
@end
