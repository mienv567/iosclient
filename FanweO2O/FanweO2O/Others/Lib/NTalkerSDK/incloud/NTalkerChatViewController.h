//
//  UIXNChatViewController.h
//  CustomerServerSDK2
//
//  Created by NTalker on 15/4/3.
//  Copyright (c) 2015年 NTalker. All rights reserved.
//


#import <UIKit/UIKit.h>

@class XNGoodsInfoModel;
/**咨询聊窗类*/
@interface NTalkerChatViewController : UIViewController
/** 客服配置id【必填】*/
@property (nonatomic, strong) NSString *settingid;
/**进入咨询界面的方式（YES:push方式  NO:present方式）*/
@property (nonatomic, assign) BOOL pushOrPresent;
/**客服ID*/
@property (nonatomic, strong) NSString *kefuId;
/**请求固定的客服(不建议使用)*/
@property (nonatomic, strong) NSString *kefuName;
/**商品信息模型*/
@property (nonatomic, strong) XNGoodsInfoModel *productInfo;
/**erp信息*/
@property (nonatomic, strong) NSString *erpParams;
/**咨询发起页标题*/
@property (nonatomic, strong) NSString *pageTitle;
/**咨询发起页URL*/
@property (nonatomic, strong) NSString *pageURLString;
/**请求客服的方式,0:组内客服,-1:组间客服,1:固定客服*/
@property (nonatomic, strong) NSString *isSingle;
/**将自定义文本类消息（比如订单信息）加入发送队列*/
+(void)sendExtendTextMessage:(NSString*)extendString;

@end
