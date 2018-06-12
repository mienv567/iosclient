//
//  XNVideoPlayerView.m
//  TestVideoII
//
//  Created by Ntalker on 16/8/5.
//  Copyright © 2016年 NTalker. All rights reserved.
//

#import "XNVideoPlayerView.h"
#import <AVFoundation/AVFoundation.h>

@interface XNVideoPlayerView ()

@property (strong, nonatomic) UIButton *finishedButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIView *transparentView;

@property (strong, nonatomic) AVPlayer *player;

@property (strong, nonatomic) NSURL *videoURL;

@end

#define KSCREENSIZE [UIScreen mainScreen].bounds.size

@implementation XNVideoPlayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        
        self.backgroundColor = [UIColor blackColor];
        
        [self configureSubiew];
        
    }
    return self;
}

- (void)setE_fromType:(E_PlayerFromType)e_fromType
{
    _e_fromType = e_fromType;
    if (e_fromType == e_play) {
        self.finishedButton.hidden = YES;
        self.cancelButton.hidden = YES;
        self.transparentView.hidden = YES;
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf:)];
        [self addGestureRecognizer:tap];
    }
}

#pragma mark // 绘制界面

- (void)configureSubiew
{
    self.transparentView = [[UIView alloc] initWithFrame:CGRectMake(0, KSCREENSIZE.height - 100, KSCREENSIZE.width, 100)];
    self.transparentView.backgroundColor = [self colorWithHexString:@"000000" alpha:0.4];
    [self addSubview:_transparentView];
    
    UIButton *cancelBtn = nil;
    [self addButton:&cancelBtn
              frame:CGRectMake(20, KSCREENSIZE.height - 60, 60, 40)
     nomalImageName:nil
         nomalTitle:NSLocalizedStringFromTable(@"cancel", @"XNLocalizable", nil)
             action:@selector(cancelButtonClicked:)
             inView:self];
    self.cancelButton = cancelBtn;
    
    UIButton *finishBtn = nil;
    [self addButton:&finishBtn
              frame:CGRectMake(KSCREENSIZE.width - 80, KSCREENSIZE.height - 60, 60, 40)
     nomalImageName:nil
         nomalTitle:NSLocalizedStringFromTable(@"send", @"XNLocalizable", nil)
             action:@selector(sendButtonClicked:)
             inView:self];
    self.finishedButton = finishBtn;
}

- (void)startVideoPlay:(NSURL *)videoURL
{
    NSString *str = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"XN_File"] stringByAppendingPathComponent:[videoURL.absoluteString lastPathComponent]];
    
    NSURL *URL = [NSURL fileURLWithPath:str];
    
    AVAsset *asset = [AVAsset assetWithURL:URL];
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
//        CGAffineTransform t = videoTrack.preferredTransform;//这里的矩阵有旋转角度，转换一下即可
    }
    
    self.videoURL = URL;
    _player=[AVPlayer playerWithURL:URL];
    AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:_player];
    playerLayer.frame = self.frame;
    [self.layer addSublayer:playerLayer];
    [_player play];
    
    [self bringSubviewToFront:_transparentView];
    [self bringSubviewToFront:_cancelButton];
    [self bringSubviewToFront:_finishedButton];
}

#pragma mark // Notification

-(void)playbackFinished:(NSNotification *)sender
{
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player play];
}

- (void)applicationEnterBackground:(NSNotification *)sender
{
    if (_player.rate == 1.0) {
        [self.player pause];
    }
}

- (void)applicationBecomeActive:(NSNotification *)sender
{
    if (_player.rate == 0) {
        [self.player play];
    }
}


- (void)itemFailedToPlayToEndTimeNotification:(NSNotification *)sender
{
    
}

- (void)itemTimeJumpedNotification:(NSNotification *)sender
{
    
}

- (void)itemPlaybackStalledNotification:(NSNotification *)sender
{
    
}

- (void)itemNewAccessLogEntryNotification:(NSNotification *)sender
{
    
}

- (void)itemNewErrorLogEntryNotification:(NSNotification *)sender
{
    
}

- (void)itemFailedToPlayToEndTimeErrorKey:(NSNotification *)sender
{
    
}

#pragma mark // 点击事件

- (void)sendButtonClicked:(UIButton *)sender
{
    NSURL *imageURL = [self thumbnailImageForVideo:_videoURL atTime:0.1];
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayerSenderButtonClicked:imageURL:)]) {
        [self.delegate videoPlayerSenderButtonClicked:_videoURL imageURL:imageURL];
    }
}

- (void)cancelButtonClicked:(UIButton *)sender
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error = nil;
    [manager removeItemAtURL:_videoURL error:&error];
    
    [_player replaceCurrentItemWithPlayerItem:nil];
    if (_delegate && [_delegate respondsToSelector:@selector(videoPlayDidCanceled)]) {
        [_delegate videoPlayDidCanceled];
    }
    [self removeFromSuperview];
    
}

- (void)tapSelf:(UITapGestureRecognizer *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayDidCanceled)]) {
        [self.delegate videoPlayDidCanceled];
        [_player replaceCurrentItemWithPlayerItem:nil];
    }
}

#pragma mark // 其他

- (UIColor *)colorWithHexString: (NSString *) stringToConvert alpha:(CGFloat)a
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
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
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:a];
}

- (void)addButton:(UIButton **)btn
            frame:(CGRect)frame
   nomalImageName:(NSString *)nomalImageName
       nomalTitle:(NSString *)nomalTitle
           action:(SEL)action
           inView:(UIView *)superView
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    if (nomalTitle.length) {
        [button setTitle:nomalTitle forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if (nomalImageName.length) {
        [button setImage:[UIImage imageNamed:nomalImageName] forState:UIControlStateNormal];
    }
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:button];
    
    if (btn) {
        *btn = button;
    }
}

- (NSURL *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    NSURL *imageURL = [NSURL URLWithString:[videoURL.absoluteString stringByReplacingOccurrencesOfString:videoURL.pathExtension withString:@"jpg"]];
    
    [UIImageJPEGRepresentation(thumbnailImage, 0.1) writeToURL:imageURL atomically:YES];
    
    return imageURL;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
