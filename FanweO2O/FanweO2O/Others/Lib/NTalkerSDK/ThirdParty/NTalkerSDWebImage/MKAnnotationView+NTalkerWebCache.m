//
//  MKAnnotationView+WebCache.m
//  SDWebImage
//
//  Created by Olivier Poitrey on 14/03/12.
//  Copyright (c) 2012 Dailymotion. All rights reserved.
//

#import "MKAnnotationView+NTalkerWebCache.h"
#import "objc/runtime.h"
#import "UIView+NTalkerWebCacheOperation.h"

static char imageURLKey;

@implementation MKAnnotationView (NTalkerWebCache)

- (NSURL *)NTalkersd_imageURL {
    return objc_getAssociatedObject(self, &imageURLKey);
}

- (void)NTalkersd_setImageWithURL:(NSURL *)url {
    [self NTalkersd_setImageWithURL:url placeholderImage:nil options:0 completed:nil];
}

- (void)NTalkersd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self NTalkersd_setImageWithURL:url placeholderImage:placeholder options:0 completed:nil];
}

- (void)NTalkersd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(NTalkerSDWebImageOptions)options {
    [self NTalkersd_setImageWithURL:url placeholderImage:placeholder options:options completed:nil];
}

- (void)NTalkersd_setImageWithURL:(NSURL *)url completed:(NTalkerSDWebImageCompletionBlock)completedBlock {
    [self NTalkersd_setImageWithURL:url placeholderImage:nil options:0 completed:completedBlock];
}

- (void)NTalkersd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(NTalkerSDWebImageCompletionBlock)completedBlock {
    [self NTalkersd_setImageWithURL:url placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)NTalkersd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(NTalkerSDWebImageOptions)options completed:(NTalkerSDWebImageCompletionBlock)completedBlock {
    [self NTalkersd_cancelCurrentImageLoad];

    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.image = placeholder;

    if (url) {
        __weak MKAnnotationView *wself = self;
        id <NTalkerSDWebImageOperation> operation = [NTalkerSDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, NTalkerSDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                __strong MKAnnotationView *sself = wself;
                if (!sself) return;
                if (image) {
                    sself.image = image;
                }
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
            });
        }];
        [self NTalkersd_setImageLoadOperation:operation forKey:@"MKAnnotationViewImage"];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:@"SDWebImageErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, NTalkerSDImageCacheTypeNone, url);
            }
        });
    }
}

- (void)NTalkersd_cancelCurrentImageLoad {
    [self NTalkersd_cancelImageLoadOperationWithKey:@"MKAnnotationViewImage"];
}

@end
