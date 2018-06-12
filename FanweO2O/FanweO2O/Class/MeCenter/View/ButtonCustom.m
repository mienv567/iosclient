//
//  ButtonCustom.m
//  FanweO2O
//
//  Created by ycp on 17/1/6.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ButtonCustom.h"

@implementation ButtonCustom
//+ (void)init:(UIImage *)imageIcon titleText:(NSString *)titleText angelNumber:(NSString *)number{
//    
//    
//}
- (instancetype)initWithFrame:(CGRect)frame imageIcon:(NSString *)imageIcon titleText:(NSString *)titleText angelNumber:(NSString *)number
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame =frame;
        UIImageView *image =[[UIImageView alloc] init];
        image.contentMode =UIViewContentModeScaleAspectFit;
       
        image.image =[UIImage imageNamed:imageIcon];
        image.frame=CGRectMake((75-30)/2, 10, 30, 30);
        [self addSubview:image];
        UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(0, 61-18, 75, 18)];
        label.text =titleText;
        label.textAlignment =NSTextAlignmentCenter;
        label.font =kAppTextFont12;
        [self addSubview:label];
        UILabel *littleLabel =[[UILabel alloc] init];
        littleLabel.frame =CGRectMake(CGRectGetMaxX(image.frame)-10, 10, 14, 14);
        littleLabel.textAlignment =NSTextAlignmentCenter;
        littleLabel.layer.masksToBounds =YES;
        littleLabel.layer.cornerRadius =littleLabel.frame.size.width/2;
        littleLabel.backgroundColor =[UIColor redColor];
        littleLabel.font =kAppTextFont10;
        littleLabel.textColor =[UIColor whiteColor];
        if (number ==nil || [number isEqualToString:@""]) {
            littleLabel.hidden =YES;
        }else{
            if ([number integerValue] >=10) {
                littleLabel.text =@"9+";
                          }else{
                littleLabel.text =number;

            }
        }
       
        [self addSubview:littleLabel];
        
        UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
        btn.frame =CGRectMake(0, 0, frame.size.width, frame.size.width);
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}

- (void)btnClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(buttonCustonToNext:)]) {
        [_delegate buttonCustonToNext:self.Tag];
    }
    
}
@end
