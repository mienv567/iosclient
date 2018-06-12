//
//  shareModel.m
//  ZCTest
//
//  Created by GuoMs on 16/1/25.
//  Copyright © 2016年 guoms. All rights reserved.
//

#import "shareModel.h"

@implementation shareModel

- (void)SetShareWithString:(NSString *)shareString WithDict:(NSDictionary *)dict WithController:(UIViewController *)VController
{
    if ([shareString isEqualToString:@"sina"])
    {
//        [UMSocialData defaultData].shareText = [NSString stringWithFormat:@"%@%@",[dict toString:@"share_title"],[dict toString:@"share_url"]];
//        [UMSocialData defaultData].extConfig.sinaData.urlResource.url = [dict toString:@"share_url"];
//        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:[dict toString:@"share_imageUrl"]];
//        
//        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:[dict toString:@"share_imageUrl"]];
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@%@",[dict toString:@"share_content"],[dict toString:@"share_url"]] image:nil location:nil urlResource:urlResource presentedController:VController completion:^(UMSocialResponseEntity *shareResponse)
//         {
//             if (shareResponse.responseCode == UMSResponseCodeSuccess)
//             {
//                 NSLog(@"分享成功!");
//             }
//         }];
        
    }else if ([shareString isEqualToString:@"weixin_circle"])
    {
//        [UMSocialData defaultData].extConfig.title = [dict toString:@"share_title"];
//        [UMSocialData defaultData].extConfig.wechatTimelineData.urlResource.url = [dict toString:@"share_url"];
//        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:[dict toString:@"share_imageUrl"]];
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[dict toString:@"share_content"] image:nil location:nil urlResource:urlResource presentedController:VController completion:^(UMSocialResponseEntity *shareResponse)
//         {
//             if (shareResponse.responseCode == UMSResponseCodeSuccess)
//             {
//                 NSLog(@"分享成功!");
//             }
//         }];
        
    }else if ([shareString isEqualToString:@"weixin"])
    {
//        [UMSocialData defaultData].extConfig.title = [dict toString:@"share_title"];
//        [UMSocialData defaultData].extConfig.wechatSessionData.url = [dict toString:@"share_url"];
//        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:[dict toString:@"share_imageUrl"]];
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[dict toString:@"share_content"] image:nil location:nil urlResource:urlResource presentedController:VController completion:^(UMSocialResponseEntity *shareResponse){
//            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
//                NSLog(@"分享成功!");
//            }
//        }];
        
    }else if ([shareString isEqualToString:@"qq"])
    {
//        [UMSocialData defaultData].extConfig.title = [dict toString:@"share_title"];
//        [UMSocialData defaultData].extConfig.qqData.url = [dict toString:@"share_url"];
//        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
//                                            [dict toString:@"share_imageUrl"]];
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:[dict toString:@"share_content"] image:nil location:nil urlResource:urlResource presentedController:VController completion:^(UMSocialResponseEntity *shareResponse){
//            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
//                NSLog(@"分享成功！");
//            }
//        }];
//        
    }else if ([shareString isEqualToString:@"qzone"])
    {
//        [UMSocialData defaultData].extConfig.title = [dict toString:@"share_title"];
//        [UMSocialData defaultData].extConfig.qzoneData.url = [dict toString:@"share_url"];
//        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
//                                            [dict toString:@"share_imageUrl"]];
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:[dict toString:@"share_content"] image:nil location:nil urlResource:urlResource presentedController:VController completion:^(UMSocialResponseEntity *shareResponse){
//            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
//                NSLog(@"分享成功!");
//            }
//        }];
    }
    
}


@end
