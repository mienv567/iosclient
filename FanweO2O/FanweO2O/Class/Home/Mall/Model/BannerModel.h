//
//  BannerModel.h
//  FanweO2O
//
//  Created by hym on 2016/12/12.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
//"id": "59",
//"name": "广告2",
//"img": "http://o2owap.fanwe.net/public/attachment/201610/21/09/58096d5116024_1500x460.jpg",
//"type": "0",
//"data": {
//    "url": ""
//},
//"ctl": "url"


@interface BannerModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSDictionary *data;

@property (nonatomic, copy) NSString *ctl;

@end
