//
//  XNHistoryTipTableViewCell.m
//  NTalkerUIKitSDK
//
//  Created by NTalker-zhou on 16/2/23.
//  Copyright © 2016年 NTalker. All rights reserved.
//

#import "XNHistoryTipTableViewCell.h"

@implementation XNHistoryTipTableViewCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureHistoryMessageTipCell:(BOOL)isShowTip{
    self.backgroundColor = [UIColor clearColor];
    if (isShowTip) {
      //长度自适应
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.text = NSLocalizedStringFromTable(@"historyTip", @"XNLocalizable", nil);
        [tipLabel sizeToFit];
        tipLabel.frame =
        CGRectMake(([UIScreen mainScreen].bounds.size.width-tipLabel.bounds.size.width)/2,15.0,tipLabel.bounds.size.width,20.0);
        
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.layer.cornerRadius = 4.0f;
        tipLabel.layer.masksToBounds = YES;
        UIColor *backColor = [self colorWithHexString:@"#c0c0c0"];
        tipLabel.backgroundColor = backColor;
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:tipLabel];
        CGRect cellframe =[self frame];
        cellframe.size.height = 35.0f;
        self.frame = cellframe;
        
    }
}

- (UIColor *)colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    //if ([cString length] < 6) return DEFAULT_VOID_COLOR;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    //if ([cString length] != 6) return DEFAULT_VOID_COLOR;
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:(1.0)];
}



@end
