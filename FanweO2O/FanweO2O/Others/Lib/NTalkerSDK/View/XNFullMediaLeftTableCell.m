//
//  XNRichMediaLeftTableCell.m
//  NTalkerUIKitSDK
//
//  Created by NTalker-zhou on 16/6/3.
//  Copyright © 2016年 NTalker. All rights reserved.
//

#import "XNFullMediaLeftTableCell.h"
#import "UIImageView+NTalkerWebCache.h"
#import "XNTextMessage.h"
#import "XNUtilityHelper.h"
#import "XNFullMediaView.h"

#define kFWFullScreenHeight     [UIScreen mainScreen].bounds.size.height
#define kFWFullScreenWidth      [UIScreen mainScreen].bounds.size.width

#define chatItemTimeLine                 [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:0.0]
#define ntalker_textColor2               [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0]
#define ntalker_textColor                [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0]

@interface XNFullMediaLeftTableCell()<XNFullMediaViewDelegate,XNTapSuperFullMediaDeleate>
{
    float autoSizeScaleX;
    float autoSizeScaleY;
    BOOL iphone6P;
    BOOL iphone6;
}
@property (nonatomic, strong)XNFullMediaView *richView;//rich
//@property (nonatomic, strong)id <XNFullMediaViewDelegate>delegate;
@end

@implementation XNFullMediaLeftTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        autoSizeScaleX=kFWFullScreenWidth>320?kFWFullScreenWidth/320:1.0;
        autoSizeScaleY=kFWFullScreenHeight>480?kFWFullScreenHeight/568:1.0;
        iphone6P=CGSizeEqualToSize(CGSizeMake(414, 736), [[UIScreen mainScreen] bounds].size);
        iphone6=CGSizeEqualToSize(CGSizeMake(375, 667), [[UIScreen mainScreen] bounds].size);
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120*autoSizeScaleX, 28*autoSizeScaleY, 80*autoSizeScaleX, 13*autoSizeScaleY)];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel setTextColor:ntalker_textColor2];
        [timeLabel setTextAlignment:NSTextAlignmentCenter];
        [timeLabel setFont:[UIFont systemFontOfSize:11*autoSizeScaleY]];
        [self addSubview:timeLabel];
        
        lineView1=[[UIView alloc] initWithFrame:CGRectMake(30*autoSizeScaleX, 35*autoSizeScaleY, 90*autoSizeScaleX, 0.5)];
        [lineView1 setBackgroundColor:chatItemTimeLine];
        lineView1.hidden=YES;
        [self addSubview:lineView1];
        
        lineView2=[[UIView alloc] initWithFrame:CGRectMake(200*autoSizeScaleX, 35*autoSizeScaleY, 90*autoSizeScaleX, 0.5)];
        [lineView2 setBackgroundColor:chatItemTimeLine];
        lineView2.hidden=YES;
        [self addSubview:lineView2];
        
        headIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15*autoSizeScaleY, 45, 45)];
        [headIcon setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_KF_icon.png"]];
        headIcon.layer.masksToBounds=YES;
        headIcon.layer.cornerRadius=5.0;
        [self addSubview:headIcon];
        self.delegate = self;
        
        contentBg = [[UIImageView alloc] initWithFrame:CGRectMake(64, 15*autoSizeScaleY, 27*autoSizeScaleX, 30.0*autoSizeScaleY)];
        [contentBg setBackgroundColor:[UIColor clearColor]];
        [self addSubview:contentBg];

    }
    return self;
}

//***显示文本信息***
- (void)setChatTextMessageInfo:(XNBaseMessage *)dto hidden:(BOOL)hide{
    timeLabel.text = [XNUtilityHelper getFormatTimeString:[NSString stringWithFormat:@"%lld",dto.msgtime]];
    timeLabel.hidden=hide;
    lineView1.hidden=hide;
    lineView2.hidden=hide;
    float offHeight=hide?0:40;
    float maxWidth=0;
    //发送text的信息
    if (dto.msgType != MSG_TYPE_FULLMEDIA) {
        return;
    }
    
    XNFullMediaMessage *textMessage = (XNFullMediaMessage *)dto;
   
    float width=190*autoSizeScaleX;
    if (maxWidth<190*autoSizeScaleX && maxWidth>0) {
        width = maxWidth;
    }
    CGSize contentSize = CGSizeMake(0.0, 0.0);
    float addHeight=0;
    if (contentSize.height<30) {
        addHeight = 30-contentSize.height;
    }
    
    [headIcon setFrame:CGRectMake(10, (15+offHeight)*autoSizeScaleY, 45, 45)];
    if (dto.usericon && ![dto.usericon isEqualToString:@""]) {
        NSString *headImageUrl =[dto.usericon stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if ([headIcon respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)]) {
            [headIcon NTalkersd_setImageWithURL:[NSURL URLWithString:headImageUrl] placeholderImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_KF_icon.png"]];
        }
    }
    CGFloat linkCardX = (64 + 15 * autoSizeScaleX);
    CGFloat linkCardY = ((13.0+offHeight+addHeight/2)*autoSizeScaleY);//缩
    CGFloat linkCardW = kFWFullScreenWidth-2*(64.0 + 15.0 * autoSizeScaleX);
    CGFloat linkCardH = 73.0*autoSizeScaleY;
    CGRect linkTextFrame = CGRectMake(linkCardX,linkCardY,linkCardW,linkCardH);
  
#pragma mark 测试富媒体
    CGSize linkCardViewSize = [self setCellIfHaveFullMediaWithTextMessage:textMessage andFullMediaViewFrame:linkTextFrame];
    
    if (contentSize.width<linkCardViewSize.width) {
        contentSize.width = linkCardViewSize.width;
    }
    
    
    UIImage *contentBgImage = [UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_chat_left.png"];
    [contentBg setImage:[contentBgImage stretchableImageWithLeftCapWidth:33 topCapHeight:30]];
    contentBg.frame = CGRectMake(64, (15+offHeight)*autoSizeScaleY, contentSize.width+27*autoSizeScaleX, contentSize.height+(addHeight)+linkCardViewSize.height);//缩
    [self setFrame:CGRectMake(0, 0, kFWFullScreenWidth,(contentBg.frame.size.height+16)>61?contentBg.frame.size.height+(16+offHeight)*autoSizeScaleY:(61+offHeight)*autoSizeScaleY)];
}


# pragma mark 富媒体
-(CGSize)setCellIfHaveFullMediaWithTextMessage:(XNFullMediaMessage *)fullMadiaMsg andFullMediaViewFrame:(CGRect)FullMediaViewFrame{
    CGSize contentSize = CGSizeZero;
    if (!_richView) {
        self.richView = [[XNFullMediaView alloc]init];
    }
    self.richView = [_richView initWithFrame:FullMediaViewFrame andFullMediaMeaasge:fullMadiaMsg andDelegate:self];
    [self addSubview:_richView];
    contentSize.height = _richView.bounds.size.height;
    contentSize.width = _richView.bounds.size.width;
    return contentSize;
}

//富媒体跳转
- (void)jumpToWebViewByFullMediaViewURL:(NSString *)urlString{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToWebViewByFullMediaString:)]) {
        [self.delegate jumpToWebViewByFullMediaString:urlString];
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
