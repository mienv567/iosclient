//
//  AccountManagerTableViewCell.m
//  FanweO2O
//
//  Created by ycp on 17/1/14.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "AccountManagerTableViewCell.h"

@implementation AccountManagerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor =[UIColor colorWithRed:0.918 green:0.929 blue:0.925 alpha:1.00];
    self.firstView.layer.masksToBounds =YES;
    self.firstView.layer.cornerRadius =4;
    
    self.secondView.layer.masksToBounds =YES;
    self.secondView.layer.cornerRadius =4;
    self.titleLabel.text =@"我的会员组";
    self.titleLabel.backgroundColor =[UIColor colorWithRed:1.000 green:0.404 blue:0.373 alpha:1.00];
    self.titleLabel.layer.masksToBounds =YES;
    self.titleLabel.layer.cornerRadius =self.titleLabel.frame.size.height/2;
    self.titleLabel.layer.borderWidth =1;
    self.titleLabel.layer.borderColor =[UIColor colorWithRed:0.918 green:0.929 blue:0.925 alpha:1.00].CGColor;
    [self.contentView addSubview:self.titleLabel];
    
    [self.firstLittleButton setTitleColor:[UIColor colorWithRed:0.910 green:0.871 blue:0.639 alpha:1.00] forState:UIControlStateNormal];
    self.firstLittleButton.hidden =YES;
    [self.firstLittleButton setBackgroundImage:[UIImage imageNamed:@"my_btnBackGround"] forState:UIControlStateNormal];
  
    
    [self.secondLittleButton setTitle:@"当前经验值" forState:UIControlStateNormal];
    [self.secondLittleButton setTitleColor:[UIColor colorWithRed:0.910 green:0.871 blue:0.639 alpha:1.00] forState:UIControlStateNormal];
    [self.secondLittleButton setBackgroundImage:[UIImage imageNamed:@"my_btnBlueGround"] forState:UIControlStateNormal];
    
    self.firstBottomLabel.textColor =[UIColor colorWithRed:0.925 green:0.796 blue:0.596 alpha:1.00];
    self.secondBottomLabel.textColor =[UIColor colorWithRed:0.569 green:0.886 blue:0.988 alpha:1.00];
    
    self.firstProgressView.transform =CGAffineTransformMakeScale(1.0, 2.0);
    self.firstProgressView.progressTintColor =[UIColor colorWithRed:0.925 green:0.796 blue:0.596 alpha:1.00];
    self.firstProgressView.progress =0;
    self.firstProgressView.trackTintColor =[UIColor whiteColor];
    
    self.secondProgressView.transform =CGAffineTransformMakeScale(1.0, 2.0);
    self.secondProgressView.progressTintColor =[UIColor colorWithRed:0.569 green:0.886 blue:0.988 alpha:1.00];
    self.secondProgressView.progress =0;
    self.secondProgressView.trackTintColor =[UIColor whiteColor];
   
    
}
- (void)setModel:(AccountManagerModel *)model
{
    
    _model =model;
    UserInfo *_frist;
    UserInfo *_second;
    _isComing =YES;
    if (model.group_info.count !=0) {
        _frist =[model.group_info firstObject];
        self.firstTitleView.text =_model.currdis.name;
        self.firstLeftLabel.text =_frist.name;
        _second= [model.group_info lastObject];
        self.firstRightLabel.text =_second.name;
        
        if ([model.currdis.discount isEqualToString:@"10"]) {
            self.firstLittleButton.hidden =YES;
        }else
        {
            self.firstLittleButton.hidden =NO;
            [self.firstLittleButton setTitle:[NSString stringWithFormat:@"享%@折优惠",model.currdis.discount] forState:UIControlStateNormal];
        }
        if (model.ghighest ==1) {
//            self.firstRightLabel.text =@"";
//            _frist = [model.group_info firstObject];
//            self.firstLeftLabel.text =_frist.name;
//            self.firstTitleView.text =_frist.name;
            self.firstBottomLabel.text =@"你已升至最高级";
//            self.firstLittleButton.hidden =NO;
//            [self.firstLittleButton setTitle:[NSString stringWithFormat:@"享%.1f折优惠",[_frist.discount floatValue]*10] forState:UIControlStateNormal];
            
            [self performSelector:@selector(delayTimer3) withObject:nil afterDelay:0.5];
        }else
        {
           
//            if ([_frist.discount intValue]*100/10 ==10) {
//                self.firstLittleButton.hidden =YES;
//            }else
//            {
//                self.firstLittleButton.hidden =NO;
//                [self.firstLittleButton setTitle:[NSString stringWithFormat:@"享%.1f折优惠",[_frist.discount floatValue]*10] forState:UIControlStateNormal];
//            }
            NSString *last;
            NSString *string =[NSString stringWithFormat:@"%.1f",[_second.discount floatValue]*100/10];
            NSLog(@"%@",[string substringWithRange:NSMakeRange(2, 1)]);
            if ([[string substringWithRange:NSMakeRange(2, 1)] isEqualToString:@"0"]) {
               last = [NSString stringWithFormat:@"%d",[string intValue]];
            }else
            {
                last =string;
            }
            
            self.firstBottomLabel.text =[NSString stringWithFormat:@"还差%d积分升级至%@,购物享%@折优惠",[_second.score intValue] -[model.user_info.total_score intValue],_second.name,last];
            CGFloat count =([model.user_info.total_score floatValue] - [_frist.score floatValue]) /([_second.score floatValue] -[ _frist.score floatValue]);
            NSNumber *number =[NSNumber numberWithFloat:count];
            [self performSelector:@selector(delayTimer1:) withObject:number afterDelay:0.5];
        }
       
    }
    
    if (model.level_info.count !=0) {
        _frist = [model.level_info firstObject];
        self.secondLeftLabel.text =_frist.name;
        _second= [model.level_info lastObject];
        self.secondRightLabel.text =_second.name;
        if (model.phighest ==1) {
//            self.secondRightLabel.text =@"";
//            _frist = [model.level_info firstObject];
//            self.secondLeftLabel.text =_frist.name;
            self.secondBottomLabel.text =@"你已升至最高级";
            [self performSelector:@selector(delayTimer4) withObject:nil afterDelay:0.5];
            
        }else
        {
//            _frist = [model.level_info firstObject];
//            self.secondLeftLabel.text =_frist.name;
//            _second= [model.level_info lastObject];
//            self.secondRightLabel.text =_second.name;
            self.secondBottomLabel.text =[NSString stringWithFormat:@"还差%d经验值升级至%@",[_second.point intValue] -[model.user_info.point intValue], _second.name];
            CGFloat count =([model.user_info.point floatValue] - [_frist.point floatValue]) /([_second.point floatValue] -[ _frist.point floatValue]);
            NSNumber *number =[NSNumber numberWithFloat:count];
            [self performSelector:@selector(delayTimer2:) withObject:number afterDelay:0.5];
           
        }
         self.secondTitleLabel.text =_model.user_info.point;
    }

}
- (void)delayTimer1:(NSNumber *)count
{
    [self.firstProgressView setProgress:[count floatValue] animated:YES];
    
}
- (void)delayTimer2:(NSNumber *)count
{
    [self.secondProgressView setProgress:[count floatValue] animated:YES];

}
- (void)delayTimer3{
    [self.firstProgressView setProgress:1 animated:YES];
}
- (void)delayTimer4{
    [self.secondProgressView setProgress:1 animated:YES];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 1);
    layer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:1.000 green:0.294 blue:0.333 alpha:1.00].CGColor,(id)[UIColor colorWithRed:0.957 green:0.451 blue:0.345 alpha:1.00].CGColor,nil];
    layer.frame = self.firstView.layer.bounds;
    CGRect new =layer.frame;
    new.size.width =kScreenW -20;
    layer.frame =new;
    [self.firstView.layer insertSublayer:layer atIndex:0];
    
    CAGradientLayer *tlayer = [CAGradientLayer layer];
    tlayer.startPoint = CGPointMake(0, 0);
    tlayer.endPoint = CGPointMake(1, 1);
    tlayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:0.475 green:0.443 blue:0.961 alpha:1.00].CGColor,(id)[UIColor colorWithRed:0.435 green:0.616 blue:0.961 alpha:1.00].CGColor,nil];
    tlayer.frame = self.secondView.layer.bounds;
    CGRect tnew =layer.frame;
    tnew.size.width =kScreenW -20;
    tlayer.frame =tnew;
    [self.secondView.layer insertSublayer:tlayer atIndex:0];
}


@end
