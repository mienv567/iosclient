//
//  FanweMessage.m
//  FanweApp
//
//  Created by mac on 16/2/15.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "FanweMessage.h"

@implementation FanweMessage

+(void) alert:(NSString *) message
{
    if (message && ![message isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}

+ (void)alertHUD:(NSString *) message
{
    if (message && ![message isEqualToString:@""])
    {
        [[HUDHelper sharedInstance] tipMessage:message];
    }
}

@end
