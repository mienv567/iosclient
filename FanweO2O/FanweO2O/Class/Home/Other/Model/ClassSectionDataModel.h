//
//  ClassSectionDataModel.h
//  FanweO2O
//
//  Created by hym on 2017/1/6.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassBcate_type : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger cate_id;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger count;

@end

@interface ClassBcate_list : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon_img;
@property (nonatomic, copy) NSString *iconfont;
@property (nonatomic, copy) NSString *iconcolor;
@property (nonatomic, strong) NSArray *bcate_type;

@property (nonatomic, strong) ClassBcate_type *hsSelectModel;

@end

@interface ClassQuan_sub : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger pid;

@end

@interface ClassQuan_list : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *quan_sub;
@property (nonatomic, strong) ClassQuan_sub *hsSelectModel;
@end


@interface ClassNavs : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;

@end

@interface ClassBrand_list : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@end

@interface ClassSectionDataModel : NSObject

@property (nonatomic, strong) NSArray *bcate_list;

@property (nonatomic, strong) NSArray *quan_list;

@property (nonatomic, strong) NSArray *brand_list;

@property (nonatomic, strong) NSArray *navs;

@end



