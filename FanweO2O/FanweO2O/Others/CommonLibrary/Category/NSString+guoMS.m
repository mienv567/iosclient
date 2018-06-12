//
//  NSString+guoMS.m
//  微博微微
//
//  Created by GuoMS on 14-6-16.
//  Copyright (c) 2014年 MAC. All rights reserved.
//

#import "NSString+guoMS.h"

@implementation NSString (guoMS)
- (NSString*)fileAppend:(NSString*)append
{
    //1.获取文件的扩展名
    NSString *ext =  [self pathExtension];
    //2.删除后面的扩展名
    NSString *imgName = [self stringByDeletingPathExtension];
    //3.拼接扩展名
    imgName = [imgName stringByAppendingString:append];
    //4.拼接扩展名
    return [imgName stringByAppendingPathExtension:ext];
}


- (NSString*)deleteCharacters;
{
 //IOS7下会报错
//    NSMutableString *text = [[NSMutableString alloc]init];
//    [text appendString:self];
//    [text deleteCharactersInRange:range];
    
    NSString *str =self;
    str = [str substringWithRange:NSMakeRange(0, [str length]-1)];
    
    return  str;
}
@end
