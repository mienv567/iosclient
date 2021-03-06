//
//  ZFModalTransitionAnimator.h
//
//  Created by zwr on 5/10/14.
//  Copyright (c) 2014 zoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

typedef NS_ENUM(NSUInteger, ZFModalTransitonDirection) {
    ZFModalTransitonDirectionBottom,
    ZFModalTransitonDirectionLeft,
    ZFModalTransitonDirectionRight,
    ZFModalTransitonDirectionTop,

};

@interface ZFDetectScrollViewEndGestureRecognizer : UIPanGestureRecognizer
@property (nonatomic, weak) UIScrollView *scrollview;
@end

@interface ZFModalTransitionAnimator : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign, getter=isDragable) BOOL dragable;
@property BOOL bounces;
@property ZFModalTransitonDirection direction;
@property CGFloat behindViewScale;
@property CGFloat behindViewAlpha;
@property CGFloat transitionDuration;

- (id)initWithModalViewController:(UIViewController *)modalViewController;
- (void)setContentScrollView:(UIScrollView *)scrollView;

@end
