/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+NTalkerWebCache.h"
#import "objc/runtime.h"
#import "UIView+NTalkerWebCacheOperation.h"

static char imageURLKey;

@implementation UIImageView (NTalkerWebCache)

- (void)NTalkersd_setImageWithURL:(NSURL *)url {
    [self NTalkersd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)NTalkersd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self NTalkersd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)NTalkersd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(NTalkerSDWebImageOptions)options {
    [self NTalkersd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)NTalkersd_setImageWithURL:(NSURL *)url completed:(NTalkerSDWebImageCompletionBlock)completedBlock {
    [self NTalkersd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)NTalkersd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(NTalkerSDWebImageCompletionBlock)completedBlock {
    [self NTalkersd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
}

- (void)NTalkersd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(NTalkerSDWebImageOptions)options completed:(NTalkerSDWebImageCompletionBlock)completedBlock {
    [self NTalkersd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock];
}

- (void)NTalkersd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(NTalkerSDWebImageOptions)options progress:(NTalkerSDWebImageDownloaderProgressBlock)progressBlock completed:(NTalkerSDWebImageCompletionBlock)completedBlock {
    [self NTalkersd_cancelCurrentImageLoad];
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    if (!(options & NTalkerSDWebImageDelayPlaceholder)) {
        dispatch_main_async_safe(^{
            self.image = placeholder;
        });
    }
    
    if (url) {
        __weak UIImageView *wself = self;
        id <NTalkerSDWebImageOperation> operation = [NTalkerSDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, NTalkerSDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                if (!wself) return;
                if (image) {
                    wself.image = image;
                    [wself setNeedsLayout];
                } else {
                    if ((options & NTalkerSDWebImageDelayPlaceholder)) {
                        wself.image = placeholder;
                        [wself setNeedsLayout];
                    }
                }
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
            });
        }];
        [self NTalkersd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:@"SDWebImageErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, NTalkerSDImageCacheTypeNone, url);
            }
        });
    }
}

- (void)NTalkersd_setImageWithPreviousCachedImageWithURL:(NSURL *)url andPlaceholderImage:(UIImage *)placeholder options:(NTalkerSDWebImageOptions)options progress:(NTalkerSDWebImageDownloaderProgressBlock)progressBlock completed:(NTalkerSDWebImageCompletionBlock)completedBlock {
    NSString *key = [[NTalkerSDWebImageManager sharedManager] cacheKeyForURL:url];
    UIImage *lastPreviousCachedImage = [[NTalkerSDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    
    [self NTalkersd_setImageWithURL:url placeholderImage:lastPreviousCachedImage ?: placeholder options:options progress:progressBlock completed:completedBlock];
}

- (NSURL *)NTalkersd_imageURL {
    return objc_getAssociatedObject(self, &imageURLKey);
}

- (void)NTalkersd_setAnimationImagesWithURLs:(NSArray *)arrayOfURLs {
    [self NTalkersd_cancelCurrentAnimationImagesLoad];
    __weak UIImageView *wself = self;

    NSMutableArray *operationsArray = [[NSMutableArray alloc] init];

    for (NSURL *logoImageURL in arrayOfURLs) {
        id <NTalkerSDWebImageOperation> operation = [NTalkerSDWebImageManager.sharedManager downloadImageWithURL:logoImageURL options:0 progress:nil completed:^(UIImage *image, NSError *error, NTalkerSDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                __strong UIImageView *sself = wself;
                [sself stopAnimating];
                if (sself && image) {
                    NSMutableArray *currentImages = [[sself animationImages] mutableCopy];
                    if (!currentImages) {
                        currentImages = [[NSMutableArray alloc] init];
                    }
                    [currentImages addObject:image];

                    sself.animationImages = currentImages;
                    [sself setNeedsLayout];
                }
                [sself startAnimating];
            });
        }];
        [operationsArray addObject:operation];
    }

    [self NTalkersd_setImageLoadOperation:[NSArray arrayWithArray:operationsArray] forKey:@"UIImageViewAnimationImages"];
}

- (void)NTalkersd_cancelCurrentImageLoad {
    [self NTalkersd_cancelImageLoadOperationWithKey:@"UIImageViewImageLoad"];
}

- (void)NTalkersd_cancelCurrentAnimationImagesLoad {
    [self NTalkersd_cancelImageLoadOperationWithKey:@"UIImageViewAnimationImages"];
}

@end
