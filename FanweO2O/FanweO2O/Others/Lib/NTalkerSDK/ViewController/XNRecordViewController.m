//
//  XNRecordViewController.m
//  NTalkerUIKitSDK
//
//  Created by Ntalker on 16/8/8.
//  Copyright © 2016年 NTalker. All rights reserved.
//

#import "XNRecordViewController.h"
#import "XNVideoRecordView.h"
#import "XNVideoPlayerView.h"
#import <AVFoundation/AVFoundation.h>


#define KSCREENSIZE [UIScreen mainScreen].bounds.size

@interface XNRecordViewController ()<XNVideoRecordViewDelegate,XNVideoPlayerViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) XNVideoRecordView *videoRecordView;

@end

@implementation XNRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureRecordView];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)configureRecordView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.videoRecordView = [[XNVideoRecordView alloc] initWithFrame:self.view.bounds delegate:self];
        [self.view addSubview:_videoRecordView];
    });
}

- (void)videoRecordDidFinished:(NSString *)videoPath
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.videoRecordView.alpha = 0;
                     } completion:^(BOOL finished) {
                         XNVideoPlayerView *videoPlayerView = [[XNVideoPlayerView alloc] initWithFrame:self.view.bounds];
                         videoPlayerView.delegate = self;
                         [self.view addSubview:videoPlayerView];
                         
                         [videoPlayerView startVideoPlay:[NSURL fileURLWithPath:videoPath]];
                     }];
}

- (void)videoRecordDidCanceled
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)videoPlayDidCanceled
{
    self.videoRecordView.alpha = 1.0;
    [self.videoRecordView viewWillReappear];
}

/*
 AVAuthorizationStatusNotDetermined = 0,
	AVAuthorizationStatusRestricted,
	AVAuthorizationStatusDenied,
	AVAuthorizationStatusAuthorized
 */
- (void)obtainAuthorization
{
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                     completionHandler:^(BOOL granted) {
                                         if (granted) {
                                             
                                             [self configureRecordView];
                                         } else {
                                             [self authorizationObtainFailed];
                                         }
                                     }];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            
            [self configureRecordView];
            
            break;
        }
        default:
        {
            [self authorizationObtainFailed];
            break;
        }
    }
}


- (void)videoRecordIsTooShort
{
    [self showToastWithContent:NSLocalizedStringFromTable(@"recordTooShortTip", @"XNLocalizable", nil) andRect:CGRectMake((KSCREENSIZE.width - 120)/2, (KSCREENSIZE.height - 25)/2, 120, 25) andTime:1.0 andObject:self];
}

- (void)authorizationObtainFailed
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"noPermissions", @"XNLocalizable", nil) message:NSLocalizedStringFromTable(@"openPermissions", @"XNLocalizable", nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"ok", @"XNLocalizable", nil) otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
            
        default:
            break;
    }
}

- (void)videoPlayerSenderButtonClicked:(NSURL *)videoURL imageURL:(NSURL *)imageURL
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordDidFinishedWithVideoURL:displayImageURL:recordViewController:)]) {
        [self.delegate recordDidFinishedWithVideoURL:videoURL displayImageURL:imageURL recordViewController:self];
    }
}

#pragma mark // util

- (void)showToastWithContent:(NSString *)content andRect:(CGRect)rect andTime:(float)time andObject:(UIViewController *)selfController
{
    if ([selfController.view viewWithTag:1234554321]) {
        UIView * tView = [selfController.view viewWithTag:1234554321];
        [tView removeFromSuperview];
    }
    
    UIImageView * toastView = [[UIImageView alloc] initWithFrame:rect];
    
    [toastView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.75f]];
    
    [toastView.layer setCornerRadius:5.0f];
    [toastView.layer setMasksToBounds:YES];
    [toastView setAlpha:1.0f];
    [toastView setTag:1234554321];
    [selfController.view addSubview:toastView];
    
    CGSize labelSize = [content sizeWithFont:[UIFont systemFontOfSize:17.0f]
                           constrainedToSize: CGSizeMake(rect.size.width ,MAXFLOAT)
                               lineBreakMode: NSLineBreakByWordWrapping];
    if (labelSize.height > rect.size.height) {
        [toastView setFrame:CGRectMake(toastView.frame.origin.x, (KSCREENSIZE.height - 44 * 2- labelSize.height)/2, toastView.frame.size.width, labelSize.height)];
    }
    
    UILabel * contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, toastView.frame.size.width - 20, toastView.frame.size.height)];
    [contentLabel setText:content];
    [contentLabel setTextColor:[UIColor whiteColor]];
    [contentLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [contentLabel setTextAlignment:NSTextAlignmentCenter];
    [contentLabel setBackgroundColor:[UIColor clearColor]];
    [contentLabel setNumberOfLines:0];
    [contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [toastView addSubview:contentLabel];
    
    if (time>0.01) {
        [self performSelector:@selector(removeToastView:) withObject:selfController afterDelay:time];
    }
    
}

- (void)removeToastView:(id)sender
{
    UIViewController * selfController = (UIViewController *)sender;
    UIView * toastView = [selfController.view viewWithTag:1234554321];
    [toastView removeFromSuperview];
    toastView = nil;
}

- (void)dealloc
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

@end
