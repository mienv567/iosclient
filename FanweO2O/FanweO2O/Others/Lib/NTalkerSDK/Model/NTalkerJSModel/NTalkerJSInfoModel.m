//
//  NTalkerJSInfoModel.m
//  CustomerServerSDK2
//
//  Created by NTalker-zhou on 15/12/17.
//  Copyright © 2015年 黄 倩. All rights reserved.
//

#import "NTalkerJSInfoModel.h"
#import "XNUtilityHelper.h"
#import "XNSDKCore.h"

@implementation NTalkerJSInfoModel

- (int)openChatWindow:(NSString *)params {
    
  
    
//    DLog(@"Js调用了OC的方法，openChatWindow 参数为：%@", params);
    
    NSDictionary *ntalkerParam =[self dictionaryWithJsonString:params];
    
    [[NSNotificationCenter  defaultCenter]postNotificationName:@"SendParamsFromJSToOpenSDK" object:ntalkerParam];
    
//    DLog(@"openChatWindow 字典参数为：%@", ntalkerParam);
//    DLog(@"openChatWindow -siteid为：%@", ntalkerParam[@"siteid"]);
    
    if (!([ntalkerParam[@"siteid"] length]>0)) {
        return 604;
    }
    
    return 0;
    
}
//获取ID
- (NSString *)getIdentityID{
    NSString *result =  [[XNSDKCore sharedInstance] cidFromLocalStore];
    return result;
}

//json转字典
-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
//        DLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
