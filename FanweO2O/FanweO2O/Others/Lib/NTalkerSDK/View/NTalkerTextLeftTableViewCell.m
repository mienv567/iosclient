//
//  NSTextLeftTableViewCell.m
//  CustomerServerSDK2
//
//  Created by NTalker on 15/4/29.
//  Copyright (c) 2015年 黄 倩. All rights reserved.
//

#import "NTalkerTextLeftTableViewCell.h"
#import "UIImageView+NTalkerWebCache.h"
#import "XNTextMessage.h"
#import "XNUtilityHelper.h"

#import "XNLinkShowCardModel.h"
#import "XNLinkShowCardView.h"
#import "XNRobotChooseViewModel.h"
#import "XNToolsHelper.h"



#define kFWFullScreenHeight     [UIScreen mainScreen].bounds.size.height
#define kFWFullScreenWidth      [UIScreen mainScreen].bounds.size.width

#define chatItemTimeLine                 [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:0.0]
#define ntalker_textColor2               [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0]
#define ntalker_textColor                [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0]

@interface NTalkerTextLeftTableViewCell()<XNLinkShowCardViewDelegate,NTalkerMLEmojiLabelDelegate>
{
    float autoSizeScaleX;
    float autoSizeScaleY;
    BOOL iphone6P;
    BOOL iphone6;
}

@property (nonatomic, strong)XNLinkShowCardView *linkCardView;//链接名片***link****
@property (nonatomic, strong)XNLinkShowCardModel *linkCardModel;//链接名片的模型数据
//机器人反问引导模型
@property (nonatomic, strong) XNRobotChooseViewModel *chooseModel;




@end
@implementation NTalkerTextLeftTableViewCell

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
        
//        headIcon = [[UIImageView alloc] init];
        //*****link***加个frame试试
        headIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15*autoSizeScaleY, 45, 45)];
        [headIcon setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_KF_icon.png"]];
        headIcon.layer.masksToBounds=YES;
        headIcon.layer.cornerRadius=5.0;
        [self addSubview:headIcon];
        
//        contentBg = [[UIImageView alloc] init];
        //*****link*****加个frame试试
        contentBg = [[UIImageView alloc] initWithFrame:CGRectMake(64, 15*autoSizeScaleY, 27*autoSizeScaleX, 30.0*autoSizeScaleY)];
        [contentBg setBackgroundColor:[UIColor clearColor]];
        [self addSubview:contentBg];
        
        emojiLabel = [NTalkerMLEmojiLabel new];
//        emojiLabel.lineSpace=2;
        //15
        emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        emojiLabel.customEmojiPlistName = @"expressionImage_custom";
        emojiLabel.font = [UIFont systemFontOfSize:16.0];
//        [emojiLabel setTextColor:ntalker_textColor];
        [emojiLabel setBackgroundColor:[UIColor clearColor]];
        // link
        emojiLabel.delegate =self;
        
#pragma mark - 添加手势（长按复制 点击跳转）
        UILongPressGestureRecognizer *longpressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressLeftCopy:)];
        longpressGesture.delegate = self;//
        [emojiLabel addGestureRecognizer:longpressGesture];
        [self addSubview:emojiLabel];
        }
    return self;
}

//********link******复制菜单（重构）
- (void)longpressLeftCopy:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NTalkerTextLeftTableViewCell *cell = (NTalkerTextLeftTableViewCell*)recognizer.view;
        [cell becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        if (menu.menuItems) {
            [menu setMenuItems:nil];
        }
        UIMenuItem *copyURL = [[UIMenuItem alloc]initWithTitle:NSLocalizedStringFromTable(@"copyLink", @"XNLocalizable", nil) action:@selector(copyURL:)];
        
        if ((_linkCardView.linkUrl.length>0)) {
            NSArray *menuItems = [NSArray arrayWithObjects:copyURL,nil];
            [menu setMenuItems:menuItems];
            
        }
        [menu setTargetRect:cell.frame inView:cell.superview];
        [menu setMenuVisible:YES animated:YES];
        
    }
}
//*****link****不加的话，剪贴板出不来
-(BOOL)canBecomeFirstResponder{
    return YES;
}
//重写
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    if (action==@selector(copyURL:)||action==@selector(copy:)) {
        return YES;
    }
    
    return NO;//隐藏系统默认的菜单项
    
}
-(void)copyURL:(UIButton *)sender{
    
    UIPasteboard *pastBoard = [UIPasteboard generalPasteboard];
    
    if ((_linkCardView.linkUrl.length>0)) {
        pastBoard.string = _linkCardView.linkUrl;
    }
}

- (void)hiddenButton
{
    [self.publicButton resignFirstResponder];
    [self.publicButton setHidden:YES];
}
#pragma mark - 跳转链接
//跳转链接（app内跳转与链接跳转）
- (void)tapToLink:(UITapGestureRecognizer *)sender
{
    NSError *error = nil;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink  error:&error];
    
    NSString *textString = emojiLabel.text;
    
    
    if (self.publicButton.hidden == NO) {
        [self hiddenButton];
    }
    
    NSString *checkNum = @"^[0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",checkNum];
    if ([predicate evaluateWithObject:emojiLabel.text]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",emojiLabel.text]]];
        
    }
    
    [detector enumerateMatchesInString:textString options:kNilOptions range:NSMakeRange(0, [textString length])
                            usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                
                                if ([result resultType] == NSTextCheckingTypeLink) {
                                    
                                    NSString *newUrl = [NSString stringWithFormat:@"%@",result.URL];
                                   if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToWebViewByLink:)]) {
                                            [self.delegate jumpToWebViewByLink:newUrl];
                                        }
                                    }
                                }];
}
//***link****名片链接跳转代理
- (void)jumpToWebViewByLinkViewURL:(NSString *)linkString{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToWebViewByLink:)]) {
        [self.delegate jumpToWebViewByLink:linkString];
    }
}

//***link*****显示文本信息***
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
    //头像
    [headIcon setFrame:CGRectMake(10, (15+offHeight)*autoSizeScaleY, 45, 45)];
    if (dto.usericon && ![dto.usericon isEqualToString:@""]) {
        NSString *headImageUrl =[dto.usericon stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if ([headIcon respondsToSelector:@selector(NTalkersd_setImageWithURL:placeholderImage:)]) {
            [headIcon NTalkersd_setImageWithURL:[NSURL URLWithString:headImageUrl] placeholderImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_KF_icon.png"]];
        }
    }
    UIImage *contentBgImage = [UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_chat_left.png"];
    [contentBg setImage:[contentBgImage stretchableImageWithLeftCapWidth:33 topCapHeight:30]];
    
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

    
    float width=190*autoSizeScaleX;
    //反问引导
    if (textMessage.isRobotAsklink) {
        if (!_chooseModel) {
            _chooseModel = [[XNRobotChooseViewModel alloc]init];
            _chooseModel.tableViewWidth = width;
            _chooseModel.fontSize = 15;
            __weak __typeof(self) weakSelf = self;
            _chooseModel.didSelectCellBlock = ^(NSString *text) {
//                NSString *temptext =[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSRange clickRange = [weakSelf getRobotRichTextRangeByText:text];
            weakSelf.chooseModel.clickRange = clickRange;
            NSString *richText = [text substringWithRange:clickRange];
            NSRange sendFrom = [richText rangeOfString:@"]"];
            NSString *sendText = @"";
            //发送的文字
            if (sendFrom.location != NSNotFound) {
                    sendText = [richText substringFromIndex:sendFrom.location+1];
                    sendText = [sendText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                }
                if (![text isEqualToString:@""]&&![sendText isEqualToString:@""]) {
                    XNTextMessage *message = [[XNTextMessage alloc] init];
                    message.textMsg = sendText;
                    if ([weakSelf.delegate respondsToSelector:@selector(didSelectedToSendMsg:)]) {
                        [weakSelf.delegate didSelectedToSendMsg:message];
                    }
                }
            };
            [self addSubview:_chooseModel.tableView];
            _chooseModel.canSelected = self.canSelected;
            if (self.canSelected) {
                _chooseModel.fontColor = [XNToolsHelper colorWithHexString:@"27b0ff"];
            } else {
                _chooseModel.fontColor = [UIColor blackColor];
            }
            emojiLabel.hidden = YES;//
            _chooseModel.tableView.hidden = NO;
            _chooseModel.textMsg = textMessage.textMsg;
            
            _chooseModel.tableView.frame = CGRectMake(64 + 15 * autoSizeScaleX, (21 + offHeight) * autoSizeScaleY, width, _chooseModel.tableView.contentSize.height);
            
            CGSize contentSize = _chooseModel.tableView.frame.size;
            contentBg.frame = CGRectMake(64, (15 + offHeight) * autoSizeScaleY, contentSize.width + 22 * autoSizeScaleX, contentSize.height + 15 * autoSizeScaleX);
            
            
        }
        
    }else {
        //机器人返回留言
        if (textMessage.systype &&(textMessage.systype.length>0)&&(content.length>0)) {
            NSString *clickText = NSLocalizedStringFromTable(@"systypeClickText", @"XNLocalizable", nil);
            NSArray *clickArr = [NSArray arrayWithObjects:clickText, nil];
            if ((clickText.length >0)&&([content  rangeOfString:clickText].location !=NSNotFound)) {
                content = [emojiLabel configureWithText:content andClickText:(NSMutableArray *)clickArr];
                //点击进留言
                __weak typeof(self) weakSelf = self;
                emojiLabel.userInteractionEnabled = YES;
                emojiLabel.clickTextArray = (NSMutableArray *)clickArr;
                emojiLabel.text = content;
                [emojiLabel setBlock:^(NSString *clickedBlueTextBlock) {
                    
                    if (weakSelf.delegate &&[weakSelf.delegate respondsToSelector:@selector(clickBlueText)]) {
                        [weakSelf.delegate clickBlueText];
                    }
                }];
                
            }else {
                emojiLabel.text = content;
            }
            //点击转人工
        }else if (textMessage.isRobotLink==YES){
            NSArray *clickArr = ((NSArray *)textMessage.clickTextArray)?:([[NSArray alloc]init]);
            
            if ([clickArr count]>0) {
                
                content = [emojiLabel configureWithText:content andClickText:textMessage.clickTextArray];
                __weak typeof(self) weakSelf = self;
                emojiLabel.userInteractionEnabled = YES;
                emojiLabel.clickTextArray = textMessage.clickTextArray;
                emojiLabel.text = content;
                [emojiLabel setBlock:^(NSString *clickedBlueTextBlock) {
                    if (weakSelf.delegate &&[weakSelf.delegate respondsToSelector:@selector(clickBlueTextToChangeManual)]) {
                        [weakSelf.delegate clickBlueTextToChangeManual];
                    }
                }];
                
            }
        }else {
            emojiLabel.text = content;
        }
        
        if (maxWidth<190*autoSizeScaleX && maxWidth>0) {
            width = maxWidth;
        }
        CGSize contentSize = [emojiLabel preferredSizeWithMaxWidth:width];
        float addHeight=0;
        if (contentSize.height<30) {
            addHeight = 30-contentSize.height;
        }
        
        // 链接名片
        BOOL isHaveShawLine = YES;//
        NSString * msg = [self clearPreHttp:textMessage.textMsg];
        NSString * onlyUrl = [self clearPreHttp:textMessage.onlyOneUrl];
        if ((textMessage.linkUrl.length>0)&&([textMessage.textMsg isEqualToString:textMessage.onlyOneUrl]||[msg isEqualToString:onlyUrl])) {
            emojiLabel.text = @"";
            isHaveShawLine = NO;
            [emojiLabel setFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
            addHeight = 0.0;
            contentSize.height = 0.0;
        }else{
            isHaveShawLine = YES;
            emojiLabel.text = content;//obj?:
            [emojiLabel setFrame:CGRectMake(64 + 15 * autoSizeScaleX, (21+offHeight+addHeight/2)*autoSizeScaleY, contentSize.width, contentSize.height)];
        }
        //链接名片新UI
        CGFloat linkCardX = ([emojiLabel.text length]>0)?(emojiLabel.frame.origin.x):(64 + 15 * autoSizeScaleX);
        CGFloat linkCardY = ([emojiLabel.text length]>0)?(CGRectGetMaxY(emojiLabel.frame)+5*autoSizeScaleY):((21+offHeight+addHeight/2)*autoSizeScaleY);
        CGFloat defaultCardW = kFWFullScreenWidth-2*(64.0 + 15.0 * autoSizeScaleX);
        CGFloat linkCardW = (emojiLabel.frame.size.width>defaultCardW)?(emojiLabel.frame.size.width):defaultCardW;
        CGFloat linkCardH = 73.0*autoSizeScaleY;
        CGRect linkTextFrame = CGRectMake(linkCardX,linkCardY,linkCardW,linkCardH);
        
        CGSize linkCardViewSize =[self setCellIfHaveLinkWithTextMessage:textMessage andLinkViewFrame:linkTextFrame andisHaveShawline:isHaveShawLine];
        
        if (contentSize.width<linkCardViewSize.width) {
            contentSize.width = linkCardViewSize.width;
        }
        
        
        contentBg.frame = CGRectMake(64, (15+offHeight)*autoSizeScaleY, contentSize.width+27*autoSizeScaleX, contentSize.height+(15*autoSizeScaleY+addHeight)+linkCardViewSize.height);
    }
    
    [self setFrame:CGRectMake(0, 0, kFWFullScreenWidth,(contentBg.frame.size.height+16)>61?contentBg.frame.size.height+(16+offHeight)*autoSizeScaleY:(61+offHeight)*autoSizeScaleY)];


}

//获取机器人反问引导可点击文字
-(NSRange)getRobotRichTextRangeByText:(NSString *)text{
    NSRange clickFromRange = [text rangeOfString:@"["];
    NSRange clickToRange = [text rangeOfString:@"\n"];
    NSRange clickRange = NSMakeRange(0, 0);
    //需要截取
    if (clickFromRange.location!=NSNotFound) {
        clickRange.location = clickFromRange.location;
        //截取部分
        if (clickToRange.location!=NSNotFound&&(clickToRange.location>clickFromRange.location)) {
            clickRange.length = clickToRange.location - clickFromRange.location;
            //截到最后
        }else{
            clickRange.length = text.length - clickFromRange.location;
        }
    }
    return clickRange;
}

//清除http前缀干扰 **link***
-(NSString *)clearPreHttp:(NSString*)oldString{
    if ([oldString rangeOfString:@"http://"].location != NSNotFound) {
        oldString = [oldString stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    }
    if ([oldString rangeOfString:@"https://"].location != NSNotFound) {
        oldString = [oldString stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    }
    return oldString;
}

//*******link*******
-(CGSize)setCellIfHaveLinkWithTextMessage:(XNTextMessage *)textMessage andLinkViewFrame:(CGRect)cardFrame andisHaveShawline:(BOOL)ishaveLine{
    CGSize contentSize = CGSizeZero;
    //有链接 添加链接名片(服务器有返回链接名片信息)
    if ((textMessage.onlyOneUrl.length>0)&&(textMessage.linkTitle.length>0)) {
        if (!_linkCardView) {
            XNLinkShowCardView *cardView = [[XNLinkShowCardView alloc]init];
            _linkCardView = [cardView initWithFrame:cardFrame andTextMeaasge:textMessage isHaveShawLine:ishaveLine andDelegate:self];
        }
        [self addSubview:_linkCardView];
        
        contentSize.height = _linkCardView.bounds.size.height;
        contentSize.width = _linkCardView.bounds.size.width;
        return contentSize;
        
    }
    
    return contentSize;
    
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
            if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToWebViewByLink:)]) {
                [self.delegate jumpToWebViewByLink:newUrl];
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

- (void)dealloc
{
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
