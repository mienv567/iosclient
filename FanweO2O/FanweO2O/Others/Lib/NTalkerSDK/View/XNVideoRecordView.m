//
//  XNVideoRecordView.m
//  TestVideoRecord
//
//  Created by Ntalker on 16/8/30.
//  Copyright © 2016年 NTalker. All rights reserved.
//

#import "XNVideoRecordView.h"
#import <AVFoundation/AVFoundation.h>
#import "XNRecordEngine.h"


#define KSCREENSIZE [UIScreen mainScreen].bounds.size

@interface XNVideoRecordView ()<XNRecordEngineDelegate>

@property (strong, nonatomic) UIButton *recordButton;

@property (strong, nonatomic) UIButton *cancelButton;

@property (strong, nonatomic) UIView *transparentView;

@property (strong, nonatomic) XNRecordEngine *recordEngine;

@property (strong, nonatomic) UIView *progressView;

@property (strong, nonatomic) CADisplayLink *displayLink;
//录制的时间
@property (assign, nonatomic) CGFloat currentTime;

@property (weak, nonatomic) id<XNVideoRecordViewDelegate> delegate;

//视频是否超时;
@property (assign, nonatomic) BOOL isOutTime;

@end

@implementation XNVideoRecordView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<XNVideoRecordViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        [self addSubview:self.transparentView];
        [self addSubview:self.recordButton];
        [self addSubview:self.progressView];
        [self addSubview:self.cancelButton];
        
        [self.recordEngine videoPreviewLayer].frame = self.bounds;
        [self.layer insertSublayer:[self.recordEngine videoPreviewLayer] atIndex:0];
        
        [self.recordEngine startUp];
    }
    return self;
}

- (CGFloat)recordMaxTime
{
    if (_recordMaxTime > 7.0 || _recordMaxTime <= 1.0) {
        _recordMaxTime = 7.0;
    }
    return _recordMaxTime;
}

- (CGFloat)recordMinTime
{
    if (_recordMinTime < 1.0) {
        _recordMinTime = 1.0;
    }
    return _recordMinTime;
}

- (XNRecordEngine *)recordEngine
{
    if (_recordEngine == nil) {
        _recordEngine = [[XNRecordEngine alloc] init];
//        _recordEngine.recordMaxTime = 8.0;
        _recordEngine.delegate = self;
    }
    return _recordEngine;
}

- (UIView *)transparentView
{
    if (!_transparentView) {
        _transparentView = [[UIView alloc] initWithFrame:CGRectMake(0, KSCREENSIZE.height - 100, KSCREENSIZE.width, 100)];
        _transparentView.backgroundColor = [self colorWithHexString:@"000000" alpha:0.4];
    }
    return _transparentView;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20, KSCREENSIZE.height - 80, 40, 40);
        [button setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_video_recordCancel.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(recordCanceled:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton = button;
    }
    return _cancelButton;
}

- (UIButton *)recordButton
{
    if (!_recordButton) {
        _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordButton.frame = CGRectMake((KSCREENSIZE.width - 70)/2, KSCREENSIZE.height - 85, 70, 70);
        [_recordButton setBackgroundImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_video_record.png"] forState:UIControlStateNormal];
        [_recordButton setTitle:NSLocalizedStringFromTable(@"pressToRecord", @"XNLocalizable", nil) forState:UIControlStateNormal];
        [_recordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_recordButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        
        [_recordButton addTarget:self action:@selector(recordStart:) forControlEvents:UIControlEventTouchDown];
        [_recordButton addTarget:self action:@selector(recordFinish:) forControlEvents:UIControlEventTouchUpInside];
        [_recordButton addTarget:self action:@selector(recordFinish:) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _recordButton;
}

- (UIView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, KSCREENSIZE.height - 105, 0, 5)];
        _progressView.backgroundColor = [self colorWithHexString:@"25EC18" alpha:1.0];
    }
    return _progressView;
}

#pragma mark =========================响应事件=========================

- (void)recordStart:(UIButton *)sender
{
    self.cancelButton.hidden = YES;
    _currentTime = 0;
    [self.recordEngine startRecord];
    
    if (!_displayLink) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLink:)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    
}

- (void)recordFinish:(UIButton *)sender
{
    if (!sender.userInteractionEnabled && sender) {
        return;
    }
    
    sender.userInteractionEnabled = NO;
    
    if (_isOutTime) {
        return;
    }
    if (!sender) {
        _isOutTime = YES;
    }
    
    self.cancelButton.hidden = NO;
    if (_currentTime < self.recordMinTime) {
        sender.userInteractionEnabled = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoRecordIsTooShort)]) {
            [self.delegate videoRecordIsTooShort];
        }
        
        [self.recordEngine cancelRecord];
    } else {
        [self.recordEngine stopRecord];
    }
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    
    //还原progressView
    CGRect frame = self.progressView.frame;
    frame.size = CGSizeMake(0, frame.size.height);
    self.progressView.frame = frame;
}

- (void)recordCanceled:(UIButton *)sender
{
    self.cancelButton.hidden = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoRecordDidCanceled)]) {
        [self.delegate videoRecordDidCanceled];
    }
}

- (void)videoRecordDidCompleted:(NSString *)videoPath
{
    _isOutTime = NO;
    CGRect frame = self.progressView.frame;
    frame.size.width = 0;
    self.progressView.frame = frame;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoRecordDidFinished:)]) {
        [self.delegate videoRecordDidFinished:videoPath];
    }
}

- (void)recordProgress:(CGFloat)progress
{
    _currentTime = progress;
    if (progress >= self.recordMaxTime) {
        [self recordFinish:nil];
    }
}

- (void)displayLink:(CADisplayLink *)displayLink
{
    CGRect frame = self.progressView.frame;
    CGFloat width = frame.size.width + ((displayLink.duration)/self.recordMaxTime) * KSCREENSIZE.width;
    frame.size = CGSizeMake(width, frame.size.height);
    self.progressView.frame = frame;
}

- (void)viewWillReappear
{
    self.recordButton.userInteractionEnabled = YES;
}

#pragma mark =========================util==================================

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

@end
