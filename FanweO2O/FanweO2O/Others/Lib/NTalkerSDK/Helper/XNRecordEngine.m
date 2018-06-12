//
//  XNRecordEngine.m
//  TestVideoRecord
//
//  Created by Ntalker on 16/8/30.
//  Copyright © 2016年 NTalker. All rights reserved.
//

#import "XNRecordEngine.h"
#import <AVFoundation/AVFoundation.h>
#import "XNRecordEncode.h"

@interface XNRecordEngine ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate,XNRecordEncodeDelegate>

@property (strong, nonatomic) XNRecordEncode *recordEncode;

@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureDeviceInput *backCameraInput;
@property (strong, nonatomic) AVCaptureDeviceInput *frontCameraInput;
@property (strong, nonatomic) AVCaptureDeviceInput *audioInput;
@property (strong, nonatomic) AVCaptureVideoDataOutput *videoOutput;
@property (strong, nonatomic) AVCaptureAudioDataOutput *audioOutput;
@property (strong, nonatomic) AVCaptureConnection *videoConnection;
@property (strong, nonatomic) AVCaptureConnection *audioConnection;

@property (strong, nonatomic) dispatch_queue_t captureQueue;

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (assign, nonatomic) BOOL isRecording;

@property (strong, nonatomic) NSString *videoName;

@property (assign, nonatomic) CMTime startTime;

@property (assign, nonatomic) BOOL isFinishing;

@end

#define KRECORDENCODE @"RECORDENCODE"

@implementation XNRecordEngine


#pragma mark ========================视频相关的get方法==================================

- (dispatch_queue_t)captureQueue
{
    if (_captureQueue == nil) {
        dispatch_queue_t captureQueue = dispatch_queue_create("cn.xiaoneng.videorecord", DISPATCH_QUEUE_SERIAL);
        _captureQueue = captureQueue;
        
    }
    return _captureQueue;
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *arr = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in arr) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice *)frontCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *)backCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

- (AVCaptureDeviceInput *)backCameraInput
{
    if (_backCameraInput == nil) {
        NSError *error = nil;
        AVCaptureDeviceInput *backCameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:&error];
        _backCameraInput = backCameraInput;
    }
    return _backCameraInput;
}

- (AVCaptureDeviceInput *)audioInput
{
    if (_audioInput == nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        NSError *error = nil;
        AVCaptureDeviceInput *audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
        _audioInput = audioInput;
    }
    return _audioInput;
}

- (AVCaptureVideoDataOutput *)videoOutput
{
    if (_videoOutput == nil) {
        _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        [_videoOutput setSampleBufferDelegate:self queue:self.captureQueue];
        NSDictionary* setcapSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange], kCVPixelBufferPixelFormatTypeKey,
                                        nil];
        _videoOutput.videoSettings = setcapSettings;
    }
    return _videoOutput;
}

- (AVCaptureAudioDataOutput *)audioOutput
{
    if (_audioOutput == nil) {
        AVCaptureAudioDataOutput *audioOutput = [[AVCaptureAudioDataOutput alloc] init];
        [audioOutput setSampleBufferDelegate:self queue:self.captureQueue];
        _audioOutput = audioOutput;
    }
    return _audioOutput;
}

- (AVCaptureConnection *)videoConnection
{
    if (!_videoConnection) {
        AVCaptureConnection *videoConnection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
        _videoConnection = videoConnection;
    }
    return _videoConnection;
}

- (AVCaptureSession *)captureSession
{
    if (!_captureSession) {
        AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
        
        if ([captureSession canAddInput:self.backCameraInput]) {
            [captureSession addInput:self.backCameraInput];
        }
        
        if ([captureSession canAddInput:self.audioInput]) {
            [captureSession addInput:self.audioInput];
        }
        
        if ([captureSession canAddOutput:self.videoOutput]) {
            [captureSession addOutput:self.videoOutput];
        }
        
        if ([captureSession canAddOutput:self.audioOutput]) {
            [captureSession addOutput:self.audioOutput];
        }
        
        self.videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
        
        _captureSession = captureSession;
    }
    return _captureSession;
}

- (AVCaptureVideoPreviewLayer *)videoPreviewLayer
{
    if (!_videoPreviewLayer) {
        AVCaptureVideoPreviewLayer *videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _videoPreviewLayer = videoPreviewLayer;
    }
    return _videoPreviewLayer;
}

#pragma mark ========================XNRecordEncodeDelegate================

- (void)recordWillCompleted
{
    _isRecording = NO;
}

#pragma mark ===============================================================

- (NSInteger)cx
{
    if (_cx < 320) {
        _cx = 320;
    }
    return _cx;
}

- (NSInteger)cy
{
    if (_cy < 568) {
        _cy = 568;
    }
    return _cy;
}

#pragma mark ===============================================================

//开始录制
- (void)startUp
{
    _isRecording = NO;
    [self.captureSession startRunning];
}

//开始写入
- (void)startRecord
{
    self.recordEncode = nil;
    
    self.videoName = [self fileNameWithType:@"mov"];
    _isRecording = YES;
    _isFinishing = NO;
    _startTime = CMTimeMake(0, 0);
}

//停止写入
- (void)stopRecord
{
    _isFinishing = YES;
}

- (void)cancelRecord
{
    self.recordEncode = nil;
    _isRecording = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [[self videoCacheFolder] stringByAppendingPathComponent:_videoName];
    [fileManager removeItemAtPath:path error:nil];
}

#pragma mark ===============================================================

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    BOOL isVideo = YES;
    
    @synchronized (self) {
        if (!_isRecording) {
            //不是正在录制,不做操作
            return;
        }
        if (captureOutput != self.videoOutput) {
            isVideo = NO;
        }
        
        if ((!_recordEncode && !isVideo)) {
            CMFormatDescriptionRef fmt = CMSampleBufferGetFormatDescription(sampleBuffer);
            const AudioStreamBasicDescription *asbd = CMAudioFormatDescriptionGetStreamBasicDescription(fmt);
            Float64 samplerate = asbd->mSampleRate;
            int channels = asbd->mChannelsPerFrame;
            NSString *videoPath = [[self videoCacheFolder] stringByAppendingPathComponent:_videoName];
            self.recordEncode = [[XNRecordEncode alloc] initWithPath:videoPath width:self.cx height:self.cy channel:channels samples:samplerate];
            self.recordEncode.delegate = self;
        }
        
        CMTime dur = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
        if (self.startTime.value == 0) {
            self.startTime = dur;
        }
        CMTime sub = CMTimeSubtract(dur, self.startTime);
        CGFloat currentRecordTime = CMTimeGetSeconds(sub);
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(recordProgress:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate recordProgress:currentRecordTime];
            });
        }
        
        if (!_isRecording) {
            return;
        }
        [self.recordEncode encodeFrame:sampleBuffer isVideo:isVideo];
        
        if (_isFinishing) {
            _isRecording = NO;
            __weak typeof(self) weakSelf = self;
            [self.recordEncode finishRecord:^{
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(videoRecordDidCompleted:)]) {
                    weakSelf.recordEncode = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.delegate videoRecordDidCompleted:[[weakSelf videoCacheFolder] stringByAppendingPathComponent:weakSelf.videoName]];
                    });
                }
            }];
        }
        
    }
}

- (NSString *)videoCacheFolder
{
    NSString *cacheDictionary = [NSTemporaryDirectory() stringByAppendingPathComponent:@"XN_File"];
    BOOL isDic = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:cacheDictionary isDirectory:&isDic];
    if (!isDic || !exist) {
        [fileManager createDirectoryAtPath:cacheDictionary
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
    return cacheDictionary;
}

- (NSString *)fileNameWithType:(NSString *)type
{
    NSString *timeIntervalStr = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]*1000];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",timeIntervalStr?:@"",type?:@""];
    
    return fileName;
}

- (void)dealloc
{
    [self.captureSession stopRunning];
}

@end
