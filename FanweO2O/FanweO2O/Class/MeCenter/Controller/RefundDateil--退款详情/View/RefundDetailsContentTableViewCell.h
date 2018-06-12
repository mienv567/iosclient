//
//  RefundDetailsContentTableViewCell.h
//  FanweO2O
//
//  Created by ycp on 17/3/13.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefundDetailsContentModel.h"
@interface RefundDetailsContentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *refDateilHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHightChange;// 线高
@property (weak, nonatomic) IBOutlet UIView *topView; //头部view
@property (weak, nonatomic) IBOutlet UILabel *storeName;//店名
@property (weak, nonatomic) IBOutlet UIImageView *storeImageView; //店图片
@property (weak, nonatomic) IBOutlet UILabel *storeTitle; //商品名
@property (weak, nonatomic) IBOutlet UILabel *storeContent; //商品内容
@property (weak, nonatomic) IBOutlet UILabel *price; //价格
@property (weak, nonatomic) IBOutlet UILabel *count; //商品数量
@property (weak, nonatomic) IBOutlet UILabel *redundInfo; //退款信息
@property (weak, nonatomic) IBOutlet UIImageView *redundIcon; //退款小图标
@property (weak, nonatomic) IBOutlet UILabel *redundStraus;//退款状态
@property (weak, nonatomic) IBOutlet UILabel *timer;//时间
@property (weak, nonatomic) IBOutlet UILabel *money;//退款金额
@property (weak, nonatomic) IBOutlet UILabel *moneyToFollow; //金额去向
@property (weak, nonatomic) IBOutlet UILabel *refundDateil; //退款备注
@property (weak, nonatomic) IBOutlet UILabel *redundTotalMoney; //退款总数
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,strong)RefundDetailsContentModel *model;
@property (nonatomic,strong)UIColor  *color1 ,*color2;//1:红色 2:灰色




@end
