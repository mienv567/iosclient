/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+NTalkerHighlightedWebCache.h"
#import "UIView+NTalkerWebCacheOperation.h"

#define NTalkerUIImageViewHighlightedWebCacheOperationKey @"highlightedImage"

@implementation UIImageView (NTalkerHighlightedWebCache)

- (void)NTalkersd_setHighlightedImageWithURL:(NSURL *)url {
    [self NTalkersd_setHighlightedImageWithURL:url options:0 progress:nil completed:nil];
}

- (void)NTalkersd_setHighlightedImageWithURL:(NSURL *)url options:(NTalkerSDWebImageOptions)options {
    [self NTalkersd_setHighlightedImageWithURL:url options:options progress:nil completed:nil];
}

- (void)NTalkersd_setHighlightedImageWithURL:(NSURL *)url completed:(NTalkerSDWebImageCompletionBlock)completedBlock {
    [self NTalkersd_setHighlightedImageWithURL:url options:0 progress:nil completed:completedBlock];
}

- (void)NTalkersd_setHighlightedImageWithURL:(NSURL *)url options:(NTalkerSDWebImageOptions)options completed:(NTalkerSDWebImageCompletionBlock)completedBlock {
    [self NTalkersd_setHighlightedImageWithURL:url options:options progress:nil completed:completedBlock];
}

- (void)NTalkersd_setHighlightedImageWithURL:(NSURL *)url options:(NTalkerSDWebImageOptions)options progress:(NTalkerSDWebImageDownloaderProgressBlock)progressBlock completed:(NTalkerSDWebImageCompletionBlock)completedBlock {
    [self NTalkersd_cancelCurrentHighlightedImageLoad];

    if (url) {
        __weak UIImageView      *wself    = self;
        id<NTalkerSDWebImageOperation> operation = [NTalkerSDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, NTalkerSDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe (^
                                     {
                                         if (!wself) return;
                                         if (image) {
                                             wself.highlightedImage = image;
                                             [wself setNeedsLayout];
                                         }
                                         if (completedBlock && finished) {
                                             completedBlock(image, error, cacheType, url);
                                         }
                                     });
        }];
        [self NTalkersd_setImageLoadOperation:operation forKey:NTalkerUIImageViewHighlightedWebCacheOperationKey];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:@"SDWebImageErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, NTalkerSDImageCacheTypeNone, url);
            }
        });
    }
}

- (void)NTalkersd_cancelCurrentHighlightedImageLoad {
    [self NTalkersd_cancelImageLoadOperationWithKey:NTalkerUIImageViewHighlightedWebCacheOperationKey];
}

@end
