//
//  XNUtilityCell.m
//  NTalkerUIKitSDK
//
//  Created by Ntalker on 16/3/16.
//  Copyright © 2016年 NTalker. All rights reserved.
//

#import "XNUtilityCell.h"
#import "XNUtilityMessage.h"
#import "XNPromptStatusLabel.h"

#define KSCREENBOUNDS [UIScreen mainScreen].bounds.size

@interface XNUtilityCell ()

@property (strong, nonatomic) XNPromptStatusLabel *promptLabel;

@end

@implementation XNUtilityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.promptLabel = [[XNPromptStatusLabel alloc] init];
        self.promptLabel.font = [UIFont systemFontOfSize:16.0];
        self.promptLabel.numberOfLines = 0;
        self.promptLabel.backgroundColor = [UIColor clearColor];
       
        [self.contentView addSubview:self.promptLabel];
        
        __weak typeof(self) weakSelf = self;
        [self.promptLabel addBlock:^(NSString *clickedString) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(blueTextClicked)]) {
                [weakSelf.delegate blueTextClicked];
            }
        }];
        
    }
    return self;
}

- (void)setUtilityCell:(XNBaseMessage *)message
{
    XNUtilityMessage *utiliMessage = (XNUtilityMessage *)message;
    self.promptLabel.textColor = [UIColor whiteColor];
    self.promptLabel.layer.cornerRadius = 4.0f;
    self.promptLabel.layer.masksToBounds = YES;
    self.promptLabel.backgroundColor = [self colorWithHexString:@"#c0c0c0"];
    self.promptLabel.font = [UIFont systemFontOfSize:14.0];
    self.promptLabel.text = utiliMessage.text;
    [self.promptLabel sizeToFit];
    CGFloat textWith = self.promptLabel.frame.size.width+10;
    if (textWith < KSCREENBOUNDS.width ) {
        self.promptLabel.frame = CGRectMake((KSCREENBOUNDS.width - textWith)/2, 5,textWith, 30);
        self.promptLabel.textAlignment = NSTextAlignmentLeft;
    }else{
        self.promptLabel.textAlignment = NSTextAlignmentLeft;//
        self.promptLabel.frame = CGRectMake(0, 5,KSCREENBOUNDS.width, 30);
        
    }
    //可折行
   [self setMultilineLabel:self.promptLabel WithWidth:KSCREENBOUNDS.width*1.26 Text:self.promptLabel.text andFont:18.0];
    
    self.frame = CGRectMake(0, 0, KSCREENBOUNDS.width, _promptLabel.frame.size.height + 10);
    
    self.promptLabel.needClickedArray = @[NSLocalizedStringFromTable(@"clickLeveMsg", @"XNLocalizable", nil)];
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
/*
 设置label内容可折行
 textWidth :label 宽度
 textString :label内容
 fontSize :字体大小
 promptLabel :目标label
 */
-(void)setMultilineLabel:(UILabel *)promptLabel WithWidth:(CGFloat)textWidth Text:(NSString *)textString andFont:(CGFloat)fontSize{
    if (!fontSize) {
        fontSize = 18.0;
    }
    UIFont * textfont = [UIFont systemFontOfSize:fontSize];
    //高度估计文本大概要显示几行，宽度根据需求自己定义。 MAXFLOAT 可以算出具体要多高
    CGSize textSize =CGSizeMake(textWidth,CGFLOAT_MAX);
    //获取当前文本的属性
    NSDictionary * textDic = [NSDictionary dictionaryWithObjectsAndKeys:textfont,NSFontAttributeName,nil];
    
    //iOS7方法，获取文本需要的size，限制宽度
    CGSize  actualsize =[textString boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin  attributes:textDic context:nil].size;
    
    promptLabel.numberOfLines = 0;
    promptLabel.lineBreakMode = NSLineBreakByWordWrapping;
    promptLabel.frame = CGRectMake(promptLabel.frame.origin.x,promptLabel.frame.origin.y, promptLabel.frame.size.width,actualsize.height);
    
}
- (void)dealloc
{
    
}

@end
