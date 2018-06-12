//
//  DataTool.m
//  FanweO2O
//
//  Created by ycp on 17/3/27.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "DataTool.h"

@implementation DataTool
+(instancetype)shareDataTool{
    static DataTool *tool =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!tool) {
            tool =[[self alloc] init];
        }
    });
    return tool;
    
}
- (instancetype)init
{
    self =[super init];
    if (self) {
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer =[AFHTTPResponseSerializer serializer];
        self.requestSerializer.timeoutInterval = 30;
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    }
    return  self;
}
@end
