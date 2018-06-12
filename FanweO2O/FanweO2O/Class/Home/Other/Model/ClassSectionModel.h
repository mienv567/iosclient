//
//  ClassSectionModel.h
//  FanweO2O
//
//  Created by hym on 2017/1/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassSectionModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *imageSelect;
@property (nonatomic, assign) BOOL hsSelect;            //
@property (nonatomic, assign) BOOL hsChange;            //选择时，其它按钮颜色是否需要改变
@property (nonatomic, assign) NSInteger tag;
@end
