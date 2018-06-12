//
//  XNLinkShowCardView.m
//  NTalkerUIKitSDK
//
//  Created by NTalker-zhou on 16/2/24.
//  Copyright © 2016年 NTalker. All rights reserved.
//

#import "XNLinkShowCardView.h"
#import "UIImageView+NTalkerWebCache.h"
#import "XNTextMessage.h"
#import "NTalkerMLEmojiLabel.h"

#define kFWFullScreenHeight     [UIScreen mainScreen].bounds.size.height
#define kFWFullScreenWidth      [UIScreen mainScreen].bounds.size.width


@interface XNLinkShowCardView ()

@property(nonatomic,weak) id <XNLinkShowCardViewDelegate>delegate;
@property(nonatomic,strong)NSString *textMsgContent;

@end


@implementation XNLinkShowCardView

-(instancetype)initWithFrame:(CGRect)frame andTextMeaasge:(XNTextMessage*)textMessage isHaveShawLine:(BOOL)isShaw andDelegate:(id <XNLinkShowCardViewDelegate>)delegate{
   
    if (!self) {
        self = [[XNLinkShowCardView alloc]init];
        
    }
    [self setFrame:frame];
    self.delegate = delegate;
    self.backgroundColor = [UIColor whiteColor];
    _textMsgContent = textMessage.textMsg;
    [self configureLinkImageViewWithTextMsg:textMessage andHaveShawLine:isShaw];
    return self;
}
-(void)configureLinkImageViewWithTextMsg:(XNTextMessage *)textMessage andHaveShawLine:(BOOL)ishaveShaw {
    _linkUrl = textMessage.linkUrl;
    if ((textMessage.linkTitle.length >0)&&(_linkUrl.length>0)) {
        if (ishaveShaw) {
            //阴影
            CGFloat  autoSizeScaleX = kFWFullScreenWidth>320?kFWFullScreenWidth/320.0:1.0;
            CGFloat autoSizeScaleY = kFWFullScreenHeight>480?kFWFullScreenHeight/480.0:1.0;
            CGRect shadowImageFrame = CGRectMake(-10*autoSizeScaleX,-5*autoSizeScaleY,self.frame.size.width+21*autoSizeScaleX,6*autoSizeScaleY);
            UIImageView *shadowImageView = [[UIImageView alloc]initWithFrame:shadowImageFrame];
            shadowImageView.frame = shadowImageFrame;
            [shadowImageView setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_linkCard_shadow.png"]];
            shadowImageView.backgroundColor = [UIColor clearColor];
            [self addSubview:shadowImageView];
            
        }
       //图片
        CGRect imageframe = CGRectMake(0.0,self.frame.size.height*0.05/2,self.frame.size.height*0.95,self.frame.size.height*0.95);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:imageframe];
        imageView.frame = imageframe;
        [imageView setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/NTalker_LinkCard_Image.png"]];
        if (textMessage.linkImageUrl.length >0) {
            NSString *urlImageUrl = [textMessage.linkImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [imageView NTalkersd_setImageWithURL:[NSURL URLWithString:urlImageUrl] placeholderImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/NTalker_LinkCard_Image.png"]];
        }
        imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:imageView];
        //标题
        CGFloat imageMaxX = CGRectGetMaxX(imageView.frame);
        CGRect titleLabelframe = CGRectMake(imageMaxX +10.0, imageView.frame.origin.y,(self.frame.size.width-(imageMaxX +10.0)),imageView.frame.size.height/2);
        UILabel *titleLabel = nil;
        
        [self addLabel:&titleLabel frame:titleLabelframe text:textMessage.linkTitle textColor:[UIColor grayColor] fontSize:14.0 alignment:NSTextAlignmentLeft inView:self andNumOfLine:1];
        // 详情
        CGFloat titleLabelMaxY = CGRectGetMaxY(titleLabel.frame);
        CGRect contentLabelframe = CGRectMake(imageMaxX+10.0, titleLabelMaxY,(self.frame.size.width-(imageMaxX +10.0)),imageView.frame.size.height/2);
        
        [self addLabel:&titleLabel frame:contentLabelframe text:textMessage.linkdescription textColor:[UIColor grayColor] fontSize:12.0 alignment:NSTextAlignmentLeft inView:self andNumOfLine:0];
        //点击打开链接
        UITapGestureRecognizer *cardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(linkCardViewTaped:)];
        [self addGestureRecognizer:cardTap];
        //长按复制链接
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToCopyLeftLinkViewUrl:)];
        [self addGestureRecognizer:longPressGesture];
        }
    
}

#pragma mark ========================util==========================

- (void)addLabel:(UILabel **)lbl frame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize alignment:(NSTextAlignment)alignment inView:(UIView *)superView andNumOfLine:(NSInteger)numLine
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text?:@"";
    label.textColor = textColor;
    label.numberOfLines = numLine;
    label.textAlignment = alignment;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:fontSize];
    [superView addSubview:label];
    
    if (lbl) {
        *lbl = label;
    }
}
#pragma mark - 复制链接名片的URL

- (void)longPressToCopyLeftLinkViewUrl:(UILongPressGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        if (menu.menuItems) {
           [menu setMenuItems:nil];
        }
        UIMenuItem *copyURL = [[UIMenuItem alloc]initWithTitle:NSLocalizedStringFromTable(@"copyLink", @"XNLocalizable", nil) action:@selector(copyURL:)];
       
        if (_linkUrl.length >0) {
            NSArray *menuItems = [NSArray arrayWithObjects:copyURL,nil];
            [menu setMenuItems:menuItems];
}
        
        [menu setTargetRect:self.frame inView:self.superview];
        [menu setMenuVisible:YES animated:YES];
    }
}
//*****link****不加的话，剪贴板出不来
-(BOOL)canBecomeFirstResponder{
    return YES;
}


//重写()
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    if (action==@selector(copyURL:)||action==@selector(copy:)) {
        return YES;
    }
    
    return NO;//隐藏系统默认的菜单项
    
}
-(void)copyURL:(id)sender{
    UIPasteboard *pastBoard = [UIPasteboard generalPasteboard];
        if ((_linkUrl.length>0)) {
            pastBoard.string = _linkUrl;
            }

}

-(void)copy:(id)sender{
    UIPasteboard *pastBoard = [UIPasteboard generalPasteboard];
    if ((_textMsgContent.length>0)) {
        pastBoard.string = _textMsgContent;
    }
    
}

#pragma mark - 跳转链接
//跳转链接（app内跳转与链接跳转）
- (void)linkCardViewTaped:(UITapGestureRecognizer *)tapGesture
{
    NSString *textString = _linkUrl;
    //崩溃保护
    if (!(textString.length>0)) {
        return;
    }
    if (!([textString hasPrefix:@"http://"] || [textString hasPrefix:@"https://"])) {
        //获取info.plist配置
        NSDictionary *info = [NSBundle mainBundle].infoDictionary;
        NSDictionary *security = info[@"NSAppTransportSecurity"];
        if (security) {
            BOOL isAllowHttp = security[@"NSAllowsArbitraryLoads"];
            if (isAllowHttp == YES) {
                textString = [@"http://" stringByAppendingString:textString];
            }else{
                textString = [@"https://" stringByAppendingString:textString];
            }
            
        }else{
            textString = [@"http://" stringByAppendingString:textString];
        }
    }
    NSError *error = nil;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink  error:&error];
    [detector enumerateMatchesInString:textString options:kNilOptions range:NSMakeRange(0, [textString length])
                            usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                
                                if ([result resultType] == NSTextCheckingTypeLink) {
                                    
                                    NSString *newUrl = [NSString stringWithFormat:@"%@",result.URL];
                                    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToWebViewByLinkViewURL:)]) {
                                            [self.delegate jumpToWebViewByLinkViewURL:newUrl];
                                        }
                                }
                            }];
}

//点击链接名片跳转URL（浏览器方式打开）
//-(void)linkCardViewTaped:(UITapGestureRecognizer *)tapGesture{
//
//    NSString *textString = _linkUrl;
//    if (!([textString hasPrefix:@"http://"] || [textString hasPrefix:@"https://"])) {
//        textString = [@"http://" stringByAppendingString:textString];
//    }
//
//    if (textString.length >0) {
//
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:textString]];
//    }
//}


@end
