//
//  MallIndexModel.h
//  FanweO2O
//
//  Created by hym on 2016/12/9.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MallIndexModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon_name;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *bg_color;
@property (nonatomic, copy) NSString *ctl;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSDictionary *data;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSMutableArray *recommend_deal_cate;

@end

@interface MallIndexMainModel : NSObject

@property (nonatomic, strong) NSMutableArray *list;

@end

@interface  BottomModel: NSObject

@property (nonatomic, strong)  NSString *id;
@property (nonatomic, strong)  NSString *name;
@property (nonatomic, strong)  NSString *type;
@property (nonatomic, strong)  NSString *url;

@end
