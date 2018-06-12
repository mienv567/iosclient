//
//  XNRichMediaView.m
//  NTalkerUIKitSDK
//
//  Created by NTalker-zhou on 16/6/3.
//  Copyright © 2016年 NTalker. All rights reserved.
//

#import "XNFullMediaView.h"
#import "UIImageView+NTalkerWebCache.h"

#define kFWFullScreenHeight     [UIScreen mainScreen].bounds.size.height
#define kFWFullScreenWidth      [UIScreen mainScreen].bounds.size.width


@interface XNFullMediaView ()

@property(nonatomic,weak) id <XNFullMediaViewDelegate>delegate;

@property (strong, nonatomic) XNFullMediaMessage *mediaMessage;

@property (strong, nonatomic) UIImageView *mediaImageView;

@property (strong, nonatomic) UILabel *descriptionLabel;

//@property(nonatomic,strong)NSString *textMsgContent;

@end


@implementation XNFullMediaView
-(instancetype)initWithFrame:(CGRect)frame andFullMediaMeaasge:(XNFullMediaMessage *)fullMediaMessage andDelegate:(id <XNFullMediaViewDelegate>)delegate{
    if (!self) {
        self = [[XNFullMediaView alloc]init];
    }
    [self setFrame:frame];
    self.delegate = delegate;
    self.backgroundColor = [UIColor whiteColor];
//    _textMsgContent = textMessage.textMsg;
    self.mediaMessage = fullMediaMessage;
    [self configureRichMediaViewWithTextMsg:fullMediaMessage];
    return self;
    
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self setFrame:frame];
//        self.delegate = delegate;
//        self.backgroundColor = [UIColor whiteColor];
//        //    _textMsgContent = textMessage.textMsg;
//        self.mediaMessage = fullMediaMessage;
//        [self configureRichMediaViewWithTextMsg:fullMediaMessage];
//    }
//    return self;
}
-(void)configureRichMediaViewWithTextMsg:(XNFullMediaMessage *)fullMediaMessage
{
    //图片
    CGRect imageframe = CGRectMake(0.0,self.frame.size.height*0.05/2,self.frame.size.height*0.95,self.frame.size.height*0.95);
    if (!self.mediaImageView) {
        self.mediaImageView = [[UIImageView alloc]initWithFrame:imageframe];
        self.mediaImageView.frame = imageframe;
        [self.mediaImageView setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/NTalker_LinkCard_Image.png"]];
        self.mediaImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_mediaImageView];
    }
    if (fullMediaMessage.image.length >0) {
        NSString *urlImageUrl = [fullMediaMessage.image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self.mediaImageView NTalkersd_setImageWithURL:[NSURL URLWithString:urlImageUrl] placeholderImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/NTalker_LinkCard_Image.png"]];
    }
    //详情
    CGFloat imageMaxX = CGRectGetMaxX(imageframe);
    CGRect descriptionLabelFrame = CGRectMake(imageMaxX+5.0, self.frame.size.height*0.05/2, self.frame.size.width-(imageMaxX+5.0)-5.0,self.frame.size.height*0.95);
    if (!self.descriptionLabel) {
        UILabel *label = nil;
        [self addLabel:&label frame:descriptionLabelFrame text:fullMediaMessage.desc textColor:[UIColor grayColor] fontSize:12.0 alignment:NSTextAlignmentLeft inView:self andNumOfLine:4];
        self.descriptionLabel = label;
    }
    self.descriptionLabel.text = fullMediaMessage.desc;
    //点击打开链接
    UITapGestureRecognizer *FullMadiaTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullMediaViewTaped:)];
    [self addGestureRecognizer:FullMadiaTap];
   }
//打开富文本的URL
-(void)fullMediaViewTaped:(UITapGestureRecognizer *)tapGesture
{
    NSString *textString = _mediaMessage.url.length?_mediaMessage.url:_mediaMessage.content;
    //崩溃保护
    if (!(textString.length>0)) {
        return;
    }
    //https
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
                                    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToWebViewByFullMediaViewURL:)]) {
                                        [self.delegate jumpToWebViewByFullMediaViewURL:newUrl];
                                    }
                                }
                            }];
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

@end
