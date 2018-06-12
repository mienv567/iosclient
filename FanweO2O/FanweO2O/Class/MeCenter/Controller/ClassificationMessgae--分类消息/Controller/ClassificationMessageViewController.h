//
//  ClassificationMessageViewController.h
//  FanweO2O
//
//  Created by ycp on 17/3/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassificationMessageViewController : UIViewController
@property (nonatomic,copy)NSString *type; //物流消息 通知消息 资产消息 验证消息;
@property (nonatomic,copy)NSString *typeName;

@end
