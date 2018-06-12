//
//  XDJProgressHUD.m
//  HaoAiDai
//
//  Created by Crius on 15/8/25.
//  Copyright (c) 2015年 Crius. All rights reserved.
//

#import "XDJProgressHUD.h"
//#import "NSString+Extensions.h"

//#import "XDJDefine.h"

MBProgressHUD* _showTipsView(NSString* text, float duration_time, UIView* view) {
    if (!view) {
        return nil;
    }
    [MBProgressHUD hideHUDForView:view animated:NO];

    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.labelFont = [UIFont systemFontOfSize:16];
    hud.margin = 15;
    hud.userInteractionEnabled = NO;
    [hud show:YES];
    [hud hide:YES afterDelay:duration_time];
    
    return hud;
}

MBProgressHUD* _showResultView(NSString* text, float duration_time, UIView* view, UIImage *image) {
    [MBProgressHUD hideHUDForView:view animated:NO];
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:view];
    [view addSubview:hud];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelFont = [UIFont systemFontOfSize:20];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.userInteractionEnabled = NO;
    hud.labelText = text;
    [hud show:YES];
    [hud hide:YES afterDelay:duration_time];
    return hud;
}
MBProgressHUD* _showLongTipsView(NSString* text, float duration_time, UIView* view) {
    [MBProgressHUD hideHUDForView:view animated:NO];
//    if ([NSString isBlank:text]) {
//        return nil;
//    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:16];
    hud.margin = 15;
    hud.userInteractionEnabled = NO;
    [hud show:YES];
    [hud hide:YES afterDelay:duration_time];
    
    return hud;
}

@implementation XDJProgressHUD

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.opacity = 0.6;
        self.labelText = @"正在加载";
    }
    return self;
}

@end

@interface XDJRoundProgressHUD ()

@end

#define margin 10  // 间隔
#define progress_font_scale (MIN(self.frame.size.width, self.frame.size.height) / 100.0)

@implementation XDJRoundProgressHUD

- (void)setProgress:(float)progress {
    if (progress > 1.0) {
        [self removeFromSuperview];
    } else {
        [super setProgress:progress];
        [self setNeedsDisplay];
    }
}

- (void)setCenterProgressText:(NSString *)text withAttributes:(NSDictionary *)attributes {
    CGFloat xCenter = self.width * 0.5;
    CGFloat yCenter = self.height * 0.5;
    
    CGSize strSize = [text sizeWithAttributes:attributes];
    CGFloat strX = xCenter - strSize.width * 0.5;
    CGFloat strY = yCenter - strSize.height * 0.5;
    [text drawAtPoint:CGPointMake(strX, strY) withAttributes:attributes];
}

- (void)setProgressTintColor:(UIColor *)progressTintColor {
    [super setProgressTintColor:progressTintColor];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    [[UIColor whiteColor] set];
    
    CGFloat radius = MIN(rect.size.width * 0.5, rect.size.height * 0.5) - margin;
    
    CGFloat w = radius * 2 + margin;
    CGFloat h = w;
    CGFloat x = (rect.size.width - w) * 0.5;
    CGFloat y = (rect.size.height - h) * 0.5;
    CGContextAddEllipseInRect(ctx, CGRectMake(x, y, w, h));
    CGContextFillPath(ctx);
    
    [self.progressTintColor set];
    CGFloat startAngle = M_PI * 0.5 - self.progress * M_PI;
    CGFloat endAngle = M_PI * 0.5 + self.progress * M_PI;
    CGContextAddArc(ctx, xCenter, yCenter, radius, startAngle, endAngle, 0);
    CGContextFillPath(ctx);
    
    NSString *progressStr = [NSString stringWithFormat:@"%.0f%s", self.progress * 100, "\%"];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:18 * progress_font_scale];
    attributes[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [self setCenterProgressText:progressStr withAttributes:attributes];
}

@end

@implementation XDJBarProgressHUD

- (void)setProgress:(float)progress {
    [super setProgress:progress];
}

- (void)setProgressColor:(UIColor *)progressColor {
    [super setProgressColor:progressColor];
}

- (void)setProgressRemainingColor:(UIColor *)progressRemainingColor {
    [super setProgressRemainingColor:progressRemainingColor];
}

- (void)drawRect:(CGRect)rect {
    NSString *progressStr = [NSString stringWithFormat:@"%.2f%s", self.progress * 100, "\%"];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:15 ];
//    attributes[NSForegroundColorAttributeName] = common_blue_color;
    
    CGSize strSize = [progressStr sizeWithAttributes:attributes];
    CGFloat strX = rect.size.width - strSize.width;
    CGFloat strY = rect.size.height/2.0f - strSize.height * 0.5;
    [progressStr drawAtPoint:CGPointMake(strX, strY) withAttributes:attributes];
    
    CGRect progressRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width - strSize.width - 5,rect.size.height);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.progressRemainingColor.CGColor);
    
    // Draw background
    // 绘制的半径
    float radius = (progressRect.size.height/2.0f);
    CGContextMoveToPoint(context, 0, progressRect.size.height/2.0f);
    CGContextAddArcToPoint(context, 0, 0, radius, 0, radius);  //  a -> b b ->c
    CGContextAddLineToPoint(context, progressRect.size.width - radius, 0);
    CGContextAddArcToPoint(context, progressRect.size.width, 0, progressRect.size.width, progressRect.size.height/2.0f, radius);
    CGContextAddArcToPoint(context, progressRect.size.width, progressRect.size.height, progressRect.size.width - radius, progressRect.size.height, radius);
    CGContextAddLineToPoint(context, radius, progressRect.size.height);
    CGContextAddArcToPoint(context, 0, progressRect.size.height , 0, radius, radius);
    CGContextFillPath(context);
    
    CGContextSetFillColorWithColor(context, self.progressColor.CGColor);
    float amount = self.progress * progressRect.size.width > progressRect.size.width ? progressRect.size.width : self.progress * progressRect.size.width;
    
    if (amount >= radius && amount <= progressRect.size.width) {
        CGContextMoveToPoint(context, 0, progressRect.size.height/2.0);
        CGContextAddArcToPoint(context, 0, 0, radius, 0, radius);
        CGContextAddLineToPoint(context, amount-radius, 0);
        CGContextAddArcToPoint(context, amount, 0, amount, progressRect.size.height/2.0f, radius);
        CGContextAddArcToPoint(context, amount, progressRect.size.height, amount-radius, progressRect.size.height, radius);
        CGContextAddLineToPoint(context, radius, progressRect.size.height);
        CGContextAddArcToPoint(context, 0, progressRect.size.height , 0, progressRect.size.height/2.0f, radius);
        CGContextFillPath(context);
    }
}

@end
