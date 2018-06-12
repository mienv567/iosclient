//
//  XNVideoRightTableViewCell.m
//  NTalkerUIKitSDK
//
//  Created by NTalker-zhou on 16/8/9.
//  Copyright © 2016年 NTalker. All rights reserved.
//

#import "XNVideoRightTableViewCell.h"
#import "XNVideoMessage.h"
#import "XNUtilityHelper.h"

#import "UIImageView+NTalkerWebCache.h"
#import "NTalkerSDWebImageManager.h"



#define kFWFullScreenHeight     [UIScreen mainScreen].bounds.size.height
#define kFWFullScreenWidth      [UIScreen mainScreen].bounds.size.width

#define chatItemTimeLine        [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:0.0]
#define ntalker_textColor       [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0]
#define ntalker_textColor2      [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0]

@interface  XNVideoRightTableViewCell()
{
    float autoSizeScaleX;
    float autoSizeScaleY;
    BOOL iphone6P;
    BOOL iphone6;
}

@property (nonatomic, strong) NSMutableArray *sendFailedArray;

@property (nonatomic, strong) XNVideoMessage *videoMessage;

@property (nonatomic, strong) UIImageView *playImageView;

@end

@implementation XNVideoRightTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.sendFailedArray = [[NSMutableArray alloc]init];
        autoSizeScaleX = kFWFullScreenHeight>480?kFWFullScreenWidth/320:1.0;
        autoSizeScaleY = kFWFullScreenHeight>480?kFWFullScreenHeight/568:1.0;
        iphone6P = CGSizeEqualToSize(CGSizeMake(414, 736), [[UIScreen mainScreen] bounds].size);
        iphone6 = CGSizeEqualToSize(CGSizeMake(375, 667), [[UIScreen mainScreen] bounds].size);
        
        // Initialization code
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120*autoSizeScaleX, 28*autoSizeScaleY, 80*autoSizeScaleX, 13*autoSizeScaleY)];
        [self.timeLabel setBackgroundColor:[UIColor clearColor]];
        [self.timeLabel setTextColor:ntalker_textColor2];
        [self.timeLabel setTextAlignment:NSTextAlignmentCenter];
        [self.timeLabel setFont:[UIFont systemFontOfSize:11*autoSizeScaleY]];
        [self addSubview:self.timeLabel];
        
        self.lineView1=[[UIView alloc] initWithFrame:CGRectMake(30*autoSizeScaleX, 35*autoSizeScaleY, 90*autoSizeScaleX, 0.5)];
        [self.lineView1 setBackgroundColor:chatItemTimeLine];
        self.lineView1.hidden = YES;
        [self addSubview:self.lineView1];
        
        self.lineView2=[[UIView alloc] initWithFrame:CGRectMake(200*autoSizeScaleX, 35*autoSizeScaleY, 90*autoSizeScaleX, 0.5)];
        [self.lineView2 setBackgroundColor:chatItemTimeLine];
        self.lineView2.hidden = YES;
        [self addSubview:self.lineView2];
        
        _headIcon = [[UIImageView alloc] init];
        _headIcon.layer.masksToBounds = YES;
        _headIcon.layer.cornerRadius = 5.0;
        [self addSubview:_headIcon];
        
        self.contentImage = [[UIImageView alloc] init];
        [self addSubview:self.contentImage];
        
        self.contentBg = [[UIImageView alloc] init];
        
        [self addSubview:self.contentBg];
        
        self.contentBg.userInteractionEnabled = YES;
        UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo)];
        [self.contentBg addGestureRecognizer:tap];
        
        self.indicatorView  = [[UIActivityIndicatorView alloc] init];
        self.indicatorView.color= ntalker_textColor;
        [self addSubview: self.indicatorView];
        
        self.failedBtn = [[UIButton alloc] init];
        [self.failedBtn setBackgroundImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_msg_failed.png"] forState:UIControlStateNormal];
        [self.failedBtn addTarget:self action:@selector(resendFailedVideoMessage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.failedBtn];
        
        self.playImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_video_recordPlay.png"]];
        [self.contentBg addSubview:_playImageView];
        
    }

    return self;
}

- (void)setChatVideoMessageCell:(XNBaseMessage *)dto hidden:(BOOL)hide{
    self.timeLabel.text = [XNUtilityHelper getFormatTimeString:[NSString stringWithFormat:@"%lld",dto.msgtime]];
    self.timeLabel.hidden=hide;
    self.lineView1.hidden=hide;
    self.lineView2.hidden=hide;
    float offHeight=hide?0:40;
    //当前访客
    if (dto.msgType == 8) {
        
        self.videoMessage = (XNVideoMessage *)dto;
        
        [_headIcon setFrame:CGRectMake(kFWFullScreenWidth - 10 - 45, (15+offHeight)*autoSizeScaleY, 45, 45)];
        [_headIcon setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_FK_icon.png"]];
        
        UIImage *contentBgImage = [UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_image_chat_right.png"];
        //气泡图
        [self.contentBg setImage:[contentBgImage stretchableImageWithLeftCapWidth:18 topCapHeight:38]];
        //内容图
        [self.contentImage setImage:[contentBgImage stretchableImageWithLeftCapWidth:18 topCapHeight:38]];
        self.contentBg.frame = CGRectMake(CGRectGetMinX(_headIcon.frame) - 10 - 140*autoSizeScaleX, (15+offHeight)*autoSizeScaleY, 140*autoSizeScaleX, 140*autoSizeScaleX);
        self.contentImage.frame = CGRectMake(CGRectGetMinX(_headIcon.frame) - 10 - 140*autoSizeScaleX, (15+offHeight)*autoSizeScaleY, 140*autoSizeScaleX, 140*autoSizeScaleX);
    }
    [self setFrame:CGRectMake(0, 0, kFWFullScreenWidth,(offHeight+156)*autoSizeScaleY)];
    [self handleContentImage:dto andOffHeight:offHeight];
}
-(void)playVideo{
//播放视频
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoWillPlay:)]) {
        [self.delegate videoWillPlay:_videoMessage];
    }

}
- (void)handleContentImage:(XNBaseMessage *)dto andOffHeight:(CGFloat)offHeight{
    
    XNVideoMessage *videoMessage = (XNVideoMessage*)dto;
    
    if (videoMessage.imageLocalPath.length) {
        [self configureImageWithLocalPath:videoMessage andOffheight:offHeight];
    } else {
        
        NSString *imageURLStr = [videoMessage.imageThumbPath stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        UIImage *image = [[NTalkerSDImageCache sharedImageCache] imageFromDiskCacheForKey:imageURLStr];
        
        if (image) {
            [self adjustSizeWithImage:image videoMessage:videoMessage offheight:offHeight];
        } else {
            _playImageView.hidden = YES;
            UIImage *originImage = [UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_video_downloadFailed.png"];
            [self.contentImage NTalkersd_setImageWithURL:[NSURL URLWithString:imageURLStr]
                                 placeholderImage:originImage
                                        completed:^(UIImage *image, NSError *error, NTalkerSDImageCacheType cacheType, NSURL *imageURL) {
                                            if (!error) {
                                                [self adjustSizeWithImage:image videoMessage:videoMessage offheight:offHeight];
                                                _playImageView.hidden = NO;
                                                
                                                if (self.delegate && [self.delegate respondsToSelector:@selector(reloadTableView)]) {
                                                    [self.delegate reloadTableView];
                                                }
                                            }
                                        }];
        }
        
    }
    
}

- (void)configureImageWithURL:(XNVideoMessage *)videoMessage andOffheight:(CGFloat)offHeight
{
    NSString *imageURLStr = [videoMessage.imageThumbPath stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    [[NTalkerSDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imageURLStr]
                                                           options:NTalkerSDWebImageRetryFailed
                                                          progress:nil
                                                         completed:^(UIImage *image, NSError *error, NTalkerSDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                             
                                                             if (finished) {
                                                                 [self adjustSizeWithImage:image videoMessage:videoMessage offheight:offHeight];
                                                             }
                                                             
                                                         }];
}

- (void)configureImageWithLocalPath:(XNVideoMessage *)videoMessage andOffheight:(CGFloat)offHeight
{
    NSString *imagePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"XN_File"] stringByAppendingPathComponent:[videoMessage.imageLocalPath lastPathComponent]];
    
    NSError *error;
    NSData *imageData = [[NSData alloc] initWithContentsOfFile:imagePath options:NSDataReadingUncached error:&error];
    UIImage *image = [UIImage imageWithData:imageData];
    if (!image) {
        image = [UIImage imageNamed:@"NTalkerUIKitResource.bundle/NTalker_LinkCard_Image.png"];
    }
    
    [self adjustSizeWithImage:image videoMessage:videoMessage offheight:offHeight];
    
}

- (void)adjustSizeWithImage:(UIImage *)image videoMessage:(XNVideoMessage *)videoMessage offheight:(CGFloat)offHeight
{
    CGSize imageSize = image.size;
    CGSize newImageSize;
    
    self.contentImage.image = image;
    
    //缩放
    if (imageSize.height>imageSize.width) {
        if (imageSize.height>140) {
            newImageSize = CGSizeMake(imageSize.width/imageSize.height*140.0, 140.0);
        }
        else{
            newImageSize = imageSize;
            
        }
    }
    
    
    CGRect frame= self.contentBg.frame;
    
    self.contentBg.frame = CGRectMake(CGRectGetMinX(_headIcon.frame) - 10 - newImageSize.width*autoSizeScaleX, frame.origin.y, newImageSize.width*autoSizeScaleX, newImageSize.height*autoSizeScaleX);
    self.contentImage .frame = CGRectMake(CGRectGetMinX(_headIcon.frame) - 10 - newImageSize.width*autoSizeScaleX, frame.origin.y, newImageSize.width*autoSizeScaleX, newImageSize.height*autoSizeScaleX);
    CGRect indicatorFrame = self.indicatorView.frame;
    indicatorFrame.origin.x = (226-newImageSize.width)*autoSizeScaleX;
    indicatorFrame.origin.y = (newImageSize.height-25)/2*autoSizeScaleX+frame.origin.y;
    [self.indicatorView setFrame:indicatorFrame];
    
    self.playImageView.frame = CGRectMake((self.contentImage.frame.size.width-30)/2, (self.contentImage.frame.size.height-30)/2,30, 30);
    
    CGRect otherFrame = self.indicatorView.frame;
    otherFrame.origin.x=(140-newImageSize.width)*autoSizeScaleX;
    self.failedBtn.hidden=YES;
    self.indicatorView.hidden=YES;
    if (videoMessage.sendStatus == SS_SENDING || videoMessage.sendStatus == SS_TOSEND) {
        [self.indicatorView setFrame:CGRectMake(CGRectGetMinX(self.contentImage.frame) - 25*autoSizeScaleX, (15+offHeight+57)*autoSizeScaleY, 25*autoSizeScaleX, 25*autoSizeScaleX)];
        [self.indicatorView startAnimating];
        self.indicatorView.hidden=NO;
        [self.sendFailedArray removeObject:videoMessage];
    } else if (videoMessage.sendStatus == SS_SENDFAILED){
        [self.failedBtn setFrame:CGRectMake(CGRectGetMinX(self.contentImage.frame) - 25-10, (15+offHeight+57)*autoSizeScaleY, 25, 25)];
        self.failedBtn.hidden=NO;
        [self.sendFailedArray addObject:videoMessage];
        self.failedBtn.tag = [[videoMessage.msgid substringWithRange:NSMakeRange(5, videoMessage.msgid.length - 6)] integerValue];
        [self.indicatorView stopAnimating];
    } else {
        [self.indicatorView stopAnimating];
    }
    [self setFrame:CGRectMake(0, 0, kFWFullScreenWidth,frame.origin.y+(newImageSize.height+1)*autoSizeScaleY)];
}

//图片缩放
-(CGSize)changeImageSizeByOldSize:(CGSize)oldSize{
    CGSize newImageSize;
    
    if (oldSize.height>oldSize.width) {
        if (oldSize.height>140) {
            newImageSize = CGSizeMake(oldSize.width/oldSize.height*140.0, 140.0);
        }
        else{
            newImageSize = oldSize;
            
        }
    }else{
        
        if (oldSize.width>140) {
            newImageSize = CGSizeMake(140, oldSize.height/oldSize.width*140.0);
        }else {
            newImageSize = oldSize;
            
        }
        
    }
    return newImageSize;
}

#pragma mark ==================重发消息====================

- (void)resendFailedVideoMessage:(UIButton *)sender
{
    if (!self.delegate || ![self.delegate respondsToSelector:@selector(resendVideoMsg:)]) {
        return;
    }
    XNVideoMessage *videoMessage = nil;
    for (XNVideoMessage *message in _sendFailedArray) {
        if ([message isKindOfClass:[XNVideoMessage class]]) {
            
            if (!message.msgid.length) continue;
            
            NSInteger msgIdTag = [[message.msgid substringWithRange:NSMakeRange(5, message.msgid.length - 6)] integerValue];
            
            if (sender.tag == msgIdTag) {
                videoMessage = message;
                break;
            }
        }
    }
    
    if (!videoMessage) {
        return;
    }
   [self.delegate resendVideoMsg:videoMessage];
}
@end
