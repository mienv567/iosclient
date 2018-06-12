//
//  MyTool.m
//  managemall
//
//  Created by GuoMS on 14-7-26.
//  Copyright (c) 2014年 GuoMs. All rights reserved.
//

#import "MyTool.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>

@implementation MyTool

#pragma mark 根据rgb值返回颜色 "#ffaa55"
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
#pragma mark 返回当前日期字符串
+ (NSString *)dateToString:(NSString*)str {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:kCFDateFormatterFullStyle];
    [dateFormatter setDateFormat:str];//
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}

#pragma marks ----画虚线
+(UIImageView *)dottedLine:(CGRect)frame{
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
    
    
    UIGraphicsBeginImageContext(imageView1.frame.size);   //开始画线
    [imageView1.image drawInRect:CGRectMake(0, 0, imageView1.frame.size.width, imageView1.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    
    
    CGFloat lengths[] = {2,2};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, RGB(200, 200, 200).CGColor);
    
    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(line, 0.0, frame.size.height);    //开始画线
    CGContextAddLineToPoint(line, frame.size.width, frame.size.height);
    CGContextStrokePath(line);
    
    imageView1.image = UIGraphicsGetImageFromCurrentImageContext();
    
    return imageView1;
}

#pragma mark 根据颜色返回图片
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark 判断字符串是否由字符串组成
+ (BOOL)isAllNum:(NSString *)string{
    //    NSString *string = @"1234abcd";
    unichar c;
    for (int i=0; i<string.length; i++) {
        c=[string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}

#pragma mark 加载图片
+ (void)downloadImage:(NSString *)url place:(UIImage *)place imageView:(UIImageView *)imageView
{
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:place options:SDWebImageLowPriority | SDWebImageRetryFailed];
}

#pragma mark 判断字符串是否为整数型
+ (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark 解决字符串乱码问题
+ (NSString*)returnUF8String:(NSString*)str
{
    if ([str canBeConvertedToEncoding:NSShiftJISStringEncoding])
    {
        str = [NSString stringWithCString:[str cStringUsingEncoding:
                                               NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
    }
    return str;
}

//判断是否为方维验证字符串
+ (BOOL)isFanwePwd:(NSString*)string{
    if([self isPureInt:string]){
        if([string length]>7){
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

//float保留的位数,并返回string
+ (NSString *)floatReservedString:(float)floatNum markStr:(NSString *)markStr{
    int tmpNum = (int)floatNum;
    if (floatNum == tmpNum) {
        return [NSString stringWithFormat:@"%@%.f",markStr,floatNum];
    }else{
        return [NSString stringWithFormat:@"%@%.2f",markStr,floatNum];
    }
}

//float保留的位数,并返回string
+ (NSString *)floatReservedString:(float)floatNum markBackStr:(NSString *)markBackStr{
    int tmpNum = (int)floatNum;
    if (floatNum == tmpNum) {
        return [NSString stringWithFormat:@"%.f%@",floatNum,markBackStr];
    }else{
        return [NSString stringWithFormat:@"%.2f%@",floatNum,markBackStr];
    }
}

//json转NSString
+ (NSString*)dataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

//将NSDictionary或NSArray转化为JSON串
+ (NSData *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

//获取随机色
+ (UIColor *)getRandomColor
{
    return [UIColor colorWithRed:(float)(1+arc4random()%99)/100 green:(float)(1+arc4random()%99)/100 blue:(float)(1+arc4random()%99)/100 alpha:1];
}

/**
 *颜色转图片
 */
+(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (BOOL)isNetConnected{
    BOOL netState;
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
            netState = NO;
            break;
        case AFNetworkReachabilityStatusNotReachable:
            netState = NO;
            [[HUDHelper sharedInstance] tipMessage:@"哎呀！网络不大给力！"];
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
        {
            netState = YES;
            break;
        }
        case AFNetworkReachabilityStatusReachableViaWiFi:
            netState = YES;
            break;
            
        default:
            break;
    }
    return netState;
}

// 是否打开闪光灯
+ (void)turnOnFlash:(BOOL)isOpen
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([device hasTorch])
    {
        if (isOpen)
        {
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOn];
            [device unlockForConfiguration];
        }
        else
        {
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOff];
            [device unlockForConfiguration];
        }
    }
}

+ (void )setLabelSpacing:(UILabel*) cLabel lfSpacing:(CGFloat ) lfSpacing strContent:(NSString*)strContent {
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:strContent];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:lfSpacing];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [strContent length])];
    [cLabel setAttributedText:attributedString1];
    [cLabel sizeToFit];
}

/** 字典返回 转为字符串*/
+ (NSString *)dicObject:(id)obj{
    if (obj == [NSNull null]) {
        return @"";
    }
    else{
        return [NSString stringWithFormat:@"%@",obj];
    }
}

@end
