//
//  XNDeviceManager.m
//  NTalkerUIKitSDK
//
//  Created by NTalker-zhou on 17/3/21.
//  Copyright © 2017年 NTalker. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "XNDeviceManager.h"


static XNDeviceManager *xnDeviceManager;

@interface XNDeviceManager ()



@end

@implementation XNDeviceManager

+(XNDeviceManager *)sharedInstance{
    static dispatch_once_t onceToken;
    _dispatch_once(&onceToken, ^{
        if (!xnDeviceManager) {
           xnDeviceManager = [[XNDeviceManager alloc] init];
        }
    });
    return xnDeviceManager ;
}
-(instancetype)init{
    if (self = [super init]) {
        [self setUpProximitySensor];
        [self registDeviceNotification];
    }
    return self;

}
-(void)setUpProximitySensor{
    UIDevice *device = [UIDevice currentDevice];
    [device setProximityMonitoringEnabled:YES];
    _isSupportProximitySensor = device.proximityMonitoringEnabled;
}
-(void)registDeviceNotification{
    [self removeRegisterNotifications];
    if (_isSupportProximitySensor) {
        static NSString * deviceProximityNotify = @"UIDeviceProximityStateDidChangeNotification";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximitySensorStateChanged:) name:deviceProximityNotify object:nil];
    }
}
-(void)removeRegisterNotifications{
    static NSString * deviceProximityNotify = @"UIDeviceProximityStateDidChangeNotification";
    if (_isSupportProximitySensor) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:deviceProximityNotify object:nil];
    }
}
-(void)proximitySensorStateChanged:(NSNotification *)notification{
    BOOL set = NO;
    if ([[UIDevice currentDevice] proximityState] == YES) {
        set = YES;
    }
    _isNearToUser = set;
    if ([self.delegate respondsToSelector:@selector(proximitySensorChanged:)]) {
        [self.delegate proximitySensorChanged:_isNearToUser];
    }


}
-(BOOL)allowProximitySensor{
    BOOL set = NO;
    if (_isSupportProximitySensor) {
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        set = YES;
    }
    return set;
}

-(BOOL)cancelProximitySensor{
    BOOL set = NO;
    if (_isSupportProximitySensor) {
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        _isNearToUser = NO;
        set = YES;
    }
    return set;
}

@end
