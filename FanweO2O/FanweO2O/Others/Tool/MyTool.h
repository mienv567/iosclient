//
//  MyTool.h
//  managemall
//
//  Created by GuoMS on 14-7-26.
//  Copyright (c) 2014年 GuoMs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTool : NSObject

//十六进制转换为uicolor
+ (UIColor *) colorWithHexString: (NSString *)color;

//画虚线
+(UIImageView *)dottedLine:(CGRect)frame;

//根据颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;
//获取时间
+ (NSString *)dateToString:(NSString*)str;
//判断字符串是否由数字组成
+ (BOOL)isAllNum:(NSString *)string;

// 判断字符串是否为整数型
+ (BOOL)isPureInt:(NSString *)string;

//判断是否为方维验证字符串
+ (BOOL)isFanwePwd:(NSString*)string;

//解决字符串乱码问题
+ (NSString*)returnUF8String:(NSString*)str;

//float保留的位数,并返回string
+ (NSString *)floatReservedString:(float)floatNum markStr:(NSString *)markStr;

//float保留的位数,并返回string
+ (NSString *)floatReservedString:(float)floatNum markBackStr:(NSString *)markBackStr;

//下载图片
+ (void)downloadImage:(NSString *)url place:(UIImage *)place imageView:(UIImageView *)imageView;

//json转NSString
+ (NSString*)dataTOjsonString:(id)object;

//将NSDictionary或NSArray转化为JSON串
+ (NSData *)toJSONData:(id)theData;

//获取随机色
+ (UIColor *)getRandomColor;

//颜色转图片
+ (UIImage*)createImageWithColor:(UIColor*) color;

// 判断网络是否连接状态
+ (BOOL)isNetConnected;

// 是否打开闪光灯
+ (void)turnOnFlash:(BOOL)isOpen;

/**
 *  设置lable行间距
 *
 *  @param cLabel label
 *  @param lfSpacing 行间距
 *  @param strContent 内容
 */
+ (void )setLabelSpacing:(UILabel*) cLabel lfSpacing:(CGFloat ) lfSpacing strContent:(NSString*)strContent;

+ (NSString *)dicObject:(id)obj;
@end
