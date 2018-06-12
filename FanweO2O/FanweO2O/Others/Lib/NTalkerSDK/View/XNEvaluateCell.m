//
//  XNEvaluateCell.m
//  XNChatCore
//
//  Created by Ntalker on 15/11/9.
//  Copyright © 2015年 Kevin. All rights reserved.
//

#import "XNEvaluateCell.h"
#import "XNEvaluateMessage.h"

#define ntalker_textColor2               [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0]

#define KWidth [UIScreen mainScreen].bounds.size.width

@interface XNEvaluateCell ()

@property (strong, nonatomic) UILabel *evaluateLabel;

@end

@implementation XNEvaluateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.evaluateLabel = [[UILabel alloc] init];
        self.evaluateLabel.backgroundColor = [UIColor clearColor];
        self.evaluateLabel.textColor = ntalker_textColor2;
        self.evaluateLabel.frame = CGRectMake(0, 10, KWidth - 20, 100);
        self.evaluateLabel.textAlignment = NSTextAlignmentCenter;
        self.evaluateLabel.numberOfLines = 0;
        self.evaluateLabel.textColor = [UIColor whiteColor];
        self.evaluateLabel.layer.cornerRadius = 4.0f;
        self.evaluateLabel.layer.masksToBounds = YES;
        self.evaluateLabel.backgroundColor = [self colorWithHexString:@"#c0c0c0"];
        self.evaluateLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.evaluateLabel];
    }
    return self;
}

- (void)configureAnything:(XNBaseMessage *)message
{
    if (![message isKindOfClass:[XNEvaluateMessage class]]) {
        return;
    }
//    XNEvaluateMessage *evaluateMessage = (XNEvaluateMessage *)message;
//    self.evaluateLabel.text = [NSString stringWithFormat:@"评价结果:%@; %@; %@",evaluateMessage.evaluateContent,evaluateMessage.solveStatus.length?evaluateMessage.solveStatus:@"",evaluateMessage.proposal.length?evaluateMessage.proposal:@""];
    self.evaluateLabel.text = NSLocalizedStringFromTable(@"submitEvalueResult", @"XNLocalizable", nil);
    [self.evaluateLabel sizeToFit];
    
    CGFloat textWith = self.evaluateLabel.frame.size.width+10;
    self.evaluateLabel.frame = CGRectMake((KWidth - textWith)/2, 5,textWith, 30);
    
    self.frame = CGRectMake(0, 0, KWidth, _evaluateLabel.frame.size.height + 10);
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

- (void)dealloc
{
    
}

@end
