//
//  XNVideoPlayerController.m
//  NTalkerUIKitSDK
//
//  Created by NTalker-zhou on 16/8/9.
//  Copyright © 2016年 NTalker. All rights reserved.
//

#import "XNVideoPlayerController.h"
#import "XNVideoPlayerView.h"
#import "XNFirstHttpService.h"
#import "XNHttpManager.h"
#import "XNVideoMessage.h"

@interface XNVideoPlayerController ()<XNVideoPlayerViewDelegate>

@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

@end

#define KSCREENSIZE [UIScreen mainScreen].bounds.size

@implementation XNVideoPlayerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoPlayerWillStop:)];
    [self.view addGestureRecognizer:tap];
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((KSCREENSIZE.width - 50)/2, (KSCREENSIZE.height - 50)/2, 50, 50)];
    self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [self.view addSubview:_indicatorView];
    [self.indicatorView startAnimating];
    
    NSString *videoURLStr = [_videoMessage.videoPath stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    
    if (self.videoMessage.videoLocalPath.length) {
        NSString *videoPath = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"XN_File"] stringByAppendingPathComponent:[self.videoMessage.videoLocalPath lastPathComponent]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:videoPath]) {
            [self.indicatorView stopAnimating];
            XNVideoPlayerView *videoPlayerView = [[XNVideoPlayerView alloc] initWithFrame:self.view.bounds];
            videoPlayerView.delegate = self;
            videoPlayerView.e_fromType = e_play;
            [self.view addSubview:videoPlayerView];
            [videoPlayerView startVideoPlay:[NSURL fileURLWithPath:videoPath]];
        } else {
            [[[XNHttpManager sharedManager] getFirstHttpService] sendDownloadVideoRequest:videoURLStr param:nil completeHandle:^(NSURL *videoURL) {
                
                [self.indicatorView stopAnimating];
                
                XNVideoPlayerView *videoPlayerView = [[XNVideoPlayerView alloc] initWithFrame:self.view.bounds];
                videoPlayerView.delegate = self;
                videoPlayerView.e_fromType = e_play;
                [self.view addSubview:videoPlayerView];
                [videoPlayerView startVideoPlay:videoURL];
                
            }];
        }
    } else {
        [[[XNHttpManager sharedManager] getFirstHttpService] sendDownloadVideoRequest:videoURLStr param:nil completeHandle:^(NSURL *videoURL) {
            
            [self.indicatorView stopAnimating];
            
            XNVideoPlayerView *videoPlayerView = [[XNVideoPlayerView alloc] initWithFrame:self.view.bounds];
            videoPlayerView.delegate = self;
            videoPlayerView.e_fromType = e_play;
            [self.view addSubview:videoPlayerView];
            [videoPlayerView startVideoPlay:videoURL];
            
        }];
    }
}

- (void)videoPlayerWillStop:(UITapGestureRecognizer *)tap
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)videoPlayDidCanceled
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
