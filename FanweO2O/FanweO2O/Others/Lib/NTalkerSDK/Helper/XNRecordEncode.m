 //
//  XNRecordEncode.m
//  TestVideoRecord
//
//  Created by Ntalker on 16/8/31.
//  Copyright © 2016年 NTalker. All rights reserved.
//

#import "XNRecordEncode.h"
#import "XNUtilityHelper.h"
@interface XNRecordEncode ()

@property (strong, atomic) AVAssetWriter *writer;
@property (strong, atomic) AVAssetWriterInput *videoInput;
@property (strong, atomic) AVAssetWriterInput *audioInput;
@property (strong, nonatomic) NSString *videoPath;
@property (assign, nonatomic) CMTime recordTime;

@property (assign, nonatomic) BOOL isCompleting;

@end

@implementation XNRecordEncode

- (instancetype)initWithPath:(NSString *)path width:(NSInteger)width height:(NSInteger)height channel:(int)ch samples:(Float64)rate
{
    self = [super init];
    if (self) {
        
        _videoPath = path;
        NSURL *videoURL = [NSURL fileURLWithPath:_videoPath];
        _writer = [AVAssetWriter assetWriterWithURL:videoURL fileType:AVFileTypeMPEG4 error:nil];
        _writer.shouldOptimizeForNetworkUse = YES;
        
        [self configureVideoInput:width height:height];
        
        if (ch != 0 && rate != 0) {
            [self configureAudioInput:ch samples:rate];
        }
        
    }
    return self;
}

- (void)configureVideoInput:(NSInteger)width height:(NSInteger)height
{
    NSDictionary* settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              AVVideoCodecH264, AVVideoCodecKey,
                              [NSNumber numberWithInteger: width], AVVideoWidthKey,
                              [NSNumber numberWithInteger: height], AVVideoHeightKey,
                              nil];
    _videoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:settings];
    _videoInput.expectsMediaDataInRealTime = YES;
    [_writer addInput:_videoInput];
}

- (void)configureAudioInput:(int)ch samples:(Float64)rate
{
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [ NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
                              [ NSNumber numberWithInt: ch], AVNumberOfChannelsKey,
                              [ NSNumber numberWithFloat: rate], AVSampleRateKey,
                              [ NSNumber numberWithInt: 128000], AVEncoderBitRateKey,
                              nil];
    _audioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:settings];
    _audioInput.expectsMediaDataInRealTime = YES;
    [_writer addInput:_audioInput];
}

- (BOOL)encodeFrame:(CMSampleBufferRef) sampleBuffer isVideo:(BOOL)isVideo
{
    if (CMSampleBufferDataIsReady(sampleBuffer)) {
        
        if (_writer.status == AVAssetWriterStatusUnknown) {
            
            _recordTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
            
            [_writer startWriting];
            [_writer startSessionAtSourceTime:_recordTime];
        }
        
        if (_writer.status == AVAssetWriterStatusFailed || _writer.status == AVAssetWriterStatusCancelled || _writer.status == AVAssetWriterStatusCompleted) {
            return NO;
        }
        
        if (isVideo) {
            
            if (_videoInput.readyForMoreMediaData && !_isCompleting) {
                [_videoInput appendSampleBuffer:sampleBuffer];
                
                return YES;
            }
        }else {
            
            if (_audioInput.readyForMoreMediaData && !_isCompleting) {
                [_audioInput appendSampleBuffer:sampleBuffer];
                return YES;
            }
        }
    }
    return NO;
}

- (void)finishRecord:(void(^)(void))handle
{
    _isCompleting = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordWillCompleted)]) {
        [self.delegate recordWillCompleted];
    }
    if (_writer.status == AVAssetWriterStatusWriting) {
        [_writer finishWritingWithCompletionHandler:handle];
    }
}

- (void)dealloc
{
    _writer = nil;
    _videoInput = nil;
    _audioInput = nil;
    _videoPath = nil;
}

@end
