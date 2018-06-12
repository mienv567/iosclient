//
//  BingdingPhoneTableViewCell.m
//  FanweO2O
//
//  Created by ycp on 17/1/19.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BingdingPhoneTableViewCell.h"

@implementation BingdingPhoneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor =[UIColor colorWithRed:1.000 green:0.980 blue:0.910 alpha:1.00];
    NSString *str1 =@"点击绑定手机号,确保账户安全~";
    NSMutableAttributedString *string =[[NSMutableAttributedString alloc] initWithString:str1];
    [string addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:1.000 green:0.145 blue:0.275 alpha:1.00],NSFontAttributeName:KAppTextFont13} range:NSMakeRange(2,5)];
    [self.textButton setAttributedTitle:string forState:UIControlStateNormal];
    self.textButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
}
- (IBAction)closeBtn:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(close)]) {
        [_delegate close];
    }
}
- (IBAction)text:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(bingPhoneClick)]) {
        [_delegate bingPhoneClick];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
