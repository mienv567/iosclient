//
//  NSTextRightTableViewCell.m
//  CustomerServerSDK2
//
//  Created by NTalker on 15/4/29.
//  Copyright (c) 2015年 黄 倩. All rights reserved.
//

#import "NTalkerTextRightTableViewCell.h"
#import "UIImageView+NTalkerWebCache.h"
#import "XNTextMessage.h"
#import "XNUtilityHelper.h"


#define kFWFullScreenHeight     [UIScreen mainScreen].bounds.size.height
#define kFWFullScreenWidth      [UIScreen mainScreen].bounds.size.width

#define chatItemTimeLine                 [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:0.0]
#define ntalker_textColor2               [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0]
#define ntalker_textColor                [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0]

@interface NTalkerTextRightTableViewCell()<NTalkerMLEmojiLabelDelegate>
{
    float autoSizeScaleX;
    float autoSizeScaleY;
    BOOL iphone6P;
    BOOL iphone6;
}

@property (nonatomic, strong) NSMutableArray *sendFailedArray;

@end



@implementation NTalkerTextRightTableViewCell
@synthesize failedBtn;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.sendFailedArray = [[NSMutableArray alloc] init];
        
        autoSizeScaleX=kFWFullScreenHeight>480?kFWFullScreenWidth/320:1.0;
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
        
        headIcon = [[UIImageView alloc] init];
        [headIcon setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_FK_icon.png"]];
        headIcon.layer.masksToBounds=YES;
        headIcon.layer.cornerRadius=5.0;
        [self addSubview:headIcon];
        
        contentBg = [[UIImageView alloc] init];
        [contentBg setBackgroundColor:[UIColor clearColor]];
        [self addSubview:contentBg];
        
        emojiLabel = [NTalkerMLEmojiLabel new];
        emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        emojiLabel.customEmojiPlistName = @"expressionImage_custom";
        emojiLabel.font = [UIFont systemFontOfSize:16.0];
        emojiLabel.delegate = self;
//        textView.lineSpace=2;
//        textView.font = [UIFont systemFontOfSize:15];
//        [textView setTextColor:ntalker_textColor];
        [emojiLabel setBackgroundColor:[UIColor clearColor]];
        
#pragma mark - 添加手势（长按复制 点击跳转）
        UILongPressGestureRecognizer *longpressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressRightCopy:)];
        longpressGesture.delegate = self;
        [emojiLabel addGestureRecognizer:longpressGesture];
        [self addSubview:emojiLabel];
        indicatorView = [[UIActivityIndicatorView alloc] init];
        indicatorView.color=ntalker_textColor;
        [self addSubview:indicatorView];
        
        failedBtn = [[UIButton alloc] init];
        //        failedBtn.userInteractionEnabled=NO;
        [failedBtn setBackgroundImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_msg_failed.png"] forState:UIControlStateNormal];
        [failedBtn addTarget:self action:@selector(resendMessage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:failedBtn];
        
        
#pragma mark - 修改内容开始
#pragma mark - 添加点击手势 用于取消 Button
//        UITapGestureRecognizer *screenTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenButton)];
//        screenTapGesture.delegate = self;
//        //文本 和 其父控件 均添加手势
//        [emojiLabel addGestureRecognizer:screenTapGesture];
//        [emojiLabel.superview addGestureRecognizer:screenTapGesture];
        
    }
    return self;
}
//复制方法重构
- (void)longpressRightCopy:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        NTalkerTextRightTableViewCell *cell = (NTalkerTextRightTableViewCell*)sender.view;
        [cell becomeFirstResponder];
        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        if (menu.menuItems) {
            [menu setMenuItems:nil];
        }
        
        [menu setTargetRect:cell.frame inView:cell.superview];
        [menu setMenuVisible:YES animated:YES];
    }
}
- (void)hiddenButton
{
    [self.publicButton resignFirstResponder];
    [self.publicButton setHidden:YES];
}
- (void)setChatTextMessageInfo:(XNBaseMessage *)dto hidden:(BOOL)hide{
    timeLabel.text = [XNUtilityHelper getFormatTimeString:[NSString stringWithFormat:@"%lld",dto.msgtime]];
    timeLabel.hidden=hide;
    lineView1.hidden=hide;
    lineView2.hidden=hide;
    float offHeight=hide?0:40;
    float maxWidth=0;
    //发送text的信息
    if (dto.msgType != MSG_TYPE_TEXT) {
        return;
    }
    
    XNTextMessage *textMessage = (XNTextMessage *)dto;
    NSString *content = textMessage.textMsg;
    
    if ([content rangeOfString:@"&amp;"].location != NSNotFound) {
        content = [content stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    }
    
    if ([content rangeOfString:@"&lt;"].location != NSNotFound) {
        content = [content stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    }
    
    if ([content rangeOfString:@"&gt;"].location != NSNotFound) {
        content = [content stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    }
    //全角转半角
    NSMutableString *contentStr = [content mutableCopy];
    CFStringTransform((CFMutableStringRef)contentStr, NULL, kCFStringTransformFullwidthHalfwidth, false);
    content = [NSString stringWithFormat:@"%@",contentStr];

    emojiLabel.text = content;
    
    float width=190*autoSizeScaleX;
    if (maxWidth<190*autoSizeScaleX && maxWidth>0) {
        width = maxWidth;
    }

    CGSize contentSize = [emojiLabel preferredSizeWithMaxWidth:width];
    float addHeight=0;
    if (contentSize.height<30) {
        addHeight = 30-contentSize.height;
    }
    //当前访客
    [headIcon setFrame:CGRectMake(kFWFullScreenWidth - 45 - 10, (15+offHeight)*autoSizeScaleY, 45, 45)];
    [headIcon setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_FK_icon.png"]];
    [emojiLabel setFrame:CGRectMake(kFWFullScreenWidth - 45 - 10 -(contentSize.width+27*autoSizeScaleX) - 10 + 15*(kFWFullScreenWidth/414), (21+offHeight+addHeight/2)*autoSizeScaleY, contentSize.width, contentSize.height)];
    UIImage *contentBgImage = [UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_chat_right.png"];
    [contentBg setImage:[contentBgImage stretchableImageWithLeftCapWidth:33 topCapHeight:29]];//12  18
    contentBg.frame = CGRectMake(kFWFullScreenWidth - 45 - 10-(contentSize.width+27*autoSizeScaleX) - 10, (15+offHeight)*autoSizeScaleY, contentSize.width+27*autoSizeScaleX, contentSize.height+(15+addHeight));
    //调整cell的间距
    [self setFrame:CGRectMake(0, 0, kFWFullScreenWidth,(contentBg.frame.size.height+16)>61?contentBg.frame.size.height+(16+offHeight)*autoSizeScaleY:(61+offHeight)*autoSizeScaleY)];
    indicatorView.hidden=YES;
    failedBtn.hidden=YES;//0703
    if (dto.sendStatus == SS_TOSEND || dto.sendStatus == SS_SENDING) {
        [indicatorView setFrame:CGRectMake(CGRectGetMinX(contentBg.frame) - 25*autoSizeScaleX, (15+offHeight)*autoSizeScaleY+(contentSize.height+addHeight*autoSizeScaleX-5*autoSizeScaleX)/2, 25*autoSizeScaleX, 25*autoSizeScaleX)];
        [indicatorView startAnimating];
        indicatorView.hidden=NO;
        [self.sendFailedArray removeObject:dto];
    } else if (dto.sendStatus == SS_SENDFAILED){
        [indicatorView stopAnimating];
        [failedBtn setFrame:CGRectMake(CGRectGetMinX(contentBg.frame) - 25 - 3, (15+offHeight)*autoSizeScaleY+(contentSize.height+addHeight*autoSizeScaleX-5*autoSizeScaleX)/2, 25, 25)];
        failedBtn.hidden=NO;
        failedBtn.tag = [[dto.msgid substringWithRange:NSMakeRange(5, dto.msgid.length - 6)] integerValue];
        [self.sendFailedArray addObject:dto];
    } else {
        [indicatorView stopAnimating];
    }
}


#pragma mark ======================重发消息===================

- (void)resendMessage:(UIButton *)sender
{
    if (!self.delegate || ![self.delegate respondsToSelector:@selector(resendTextMsg:)]) {
        return;
    }
    
    XNTextMessage *textMessage = nil;
    for (XNTextMessage *message in _sendFailedArray) {
        if ([message isKindOfClass:[XNTextMessage class]]) {
            
            if (!message.msgid.length) continue;
            
            NSInteger msgIdTag = [[message.msgid substringWithRange:NSMakeRange(5, message.msgid.length - 6)] integerValue];
            if (sender.tag == msgIdTag) {
                textMessage = message;
                break;
            }
        }
    }
    
    if (!textMessage) {
        return;
    }
    
    [self.delegate resendTextMsg:textMessage];
}

// woo 
- (void)mlEmojiLabel:(NTalkerMLEmojiLabel *)emojiLabel didSelectLink:(NSString *)link withType:(NTalkerMLEmojiLabelLinkType)type
{
    [self tapToLink:link withType:type];
}
// woo
- (void)tapToLink:(NSString *)link withType:(NTalkerMLEmojiLabelLinkType)type {
    
    if (self.publicButton.hidden == NO) {
        [self hiddenButton];
    }
    switch (type) {
            
        case NTalkerMLEmojiLabelLinkTypePhoneNumber:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",link]]];
            
            break;
        case NTalkerMLEmojiLabelLinkTypeURL:
        {
            //修复IP地址点击不能跳转bug 0511
            if (!([link hasPrefix:@"http://"]|[link hasPrefix:@"https://"])) {
                //获取info.plist配置
                NSDictionary *info = [NSBundle mainBundle].infoDictionary;
                NSDictionary *security = info[@"NSAppTransportSecurity"];
                if (security) {
                    BOOL isAllowHttp = security[@"NSAllowsArbitraryLoads"];
                    if (isAllowHttp == YES) {
                        link = [NSString stringWithFormat:@"http://%@",link];
                    }else{
                        link = [NSString stringWithFormat:@"https://%@",link];
                    }
                    
                }else{
                    link = [NSString stringWithFormat:@"https://%@",link];
                }

            }
            NSError *error = nil;
            NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingAllTypes error:&error];
            NSTextCheckingResult *result = [detector firstMatchInString:link options:0 range:NSMakeRange(0, link.length)];
            NSString *newUrl = [NSString stringWithFormat:@"%@",result.URL];
            if (self.delegate && [self.delegate respondsToSelector:@selector(toWebViewBySuperLink:)]) {
                [self.delegate toWebViewBySuperLink:newUrl];
            }
            
        }
            break;
            
        default:
            break;
    }
    
}

// woo 添加代理方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        return YES;
    }
    if ([touch.view isKindOfClass:[NTalkerMLEmojiLabel class]]){
        NTalkerMLEmojiLabel *label = (NTalkerMLEmojiLabel *)touch.view;
        if ([label containslinkAtPoint:[touch locationInView:label]]){
            return NO;
        }else{
            return YES;
        }
    }else{
        return YES;
    }
}
//*****link****不加的话，剪贴板出不来
-(BOOL)canBecomeFirstResponder{
    return YES;
}
//重写
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    if (action==@selector(copy:)) {
        return YES;
    }
    
    return NO;//隐藏系统默认的菜单项
    
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
