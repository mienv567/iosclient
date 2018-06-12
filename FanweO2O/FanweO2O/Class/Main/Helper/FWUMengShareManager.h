//
//  FWUMengShareManager.h
//  FanweApp
//
//  Created by mac on 2017/3/13.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UShareUI/UShareUI.h>
#import "FanweMessage.h"
#import "shareModel.h"

typedef void (^FWUMengSuccBlock)(UMSocialShareResponse *response);

@interface FWUMengShareManager : NSObject

+ (instancetype)sharedInstance;

// 弹出分享面板
- (void)showShareViewInControllr:(UIViewController *)vc shareModel:(shareModel *)shareModel succ:(FWUMengSuccBlock)succ failed:(FWErrorBlock)failed;

// 根据分享类型进行分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType shareModel:(shareModel *)shareModel succ:(FWUMengSuccBlock)succ failed:(FWErrorBlock)failed;

@end
