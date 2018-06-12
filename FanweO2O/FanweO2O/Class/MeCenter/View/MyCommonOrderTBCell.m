//
//  MyCommonOrderTBCell.m
//  FanweO2O
//
//  Created by hym on 2017/3/1.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MyCommonOrderTBCell.h"
#import "UIView+BlocksKit.h"
#import "MyOrderModel.h"
#import "MyOrderStoreInfoView.h"
#import "MyOrderStoreInfoCollectionView.h"
#import "FWO2OJump.h"
#import "MyOrderDetailsVC.h"
static NSString *const ID = @"MyCommonOrderTBCell";

@interface MyCommonOrderTBCell ()



@property (weak, nonatomic) IBOutlet UIView *viewStoreContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutStoreHeight;


@property (weak, nonatomic) IBOutlet UIView *viewTotalContainer;
@property (weak, nonatomic) IBOutlet UILabel *lbTotalAccount;
@property (weak, nonatomic) IBOutlet UILabel *lbTotalPrice;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTotalHeight;

@property (weak, nonatomic) IBOutlet UIView *viewButtonContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutButtonHeight;

@end

@implementation MyCommonOrderTBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.viewStoreContainer setBackgroundColor:kBackGroundColor];
    

    
    [self.lbTotalPrice setTextColor:RGB(255, 34, 68)];
   
    UIView *line = [UIView new];
    [line setBackgroundColor:RGB(231, 231, 231)];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview {
    
    MyCommonOrderTBCell *cell = [newTableview dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
    
}

- (void)setOrderItem:(MyOrderItemModel *)orderItem {
    _orderItem = orderItem;
    
    //组二
    CGFloat itemHeight = 0;
    
    for (UIView *view in self.viewStoreContainer.subviews) {
        [view removeFromSuperview];
    }
    
    for (DealOrderItem *item in orderItem.deal_order_item) {
        
     
        if (item.list.count == 1) {
            
            MyOrderStoreInfoView *view1 = [MyOrderStoreInfoView appView];
            [view1 setBackgroundColor:[UIColor whiteColor]];
            [self.viewStoreContainer addSubview:view1];
            [view1.viewContainer bk_whenTapped:^{
                MyOrderDetailsVC *vc = [MyOrderDetailsVC new];
                vc.data_id = orderItem.id;
                [[AppDelegate sharedAppDelegate] pushViewController:vc];
            }];
            [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.viewStoreContainer.mas_left).with.offset(0);
                make.right.equalTo(self.viewStoreContainer.mas_right).with.offset(0);
                make.top.equalTo(self.viewStoreContainer.mas_top).with.offset(itemHeight);
                make.height.mas_offset(96 + 46);
            }];
            
            view1.item = item;
            view1.lbStatus.text = _orderItem.status_name;
            itemHeight = itemHeight + 96 + 46;
        }else {
            
            
            MyOrderStoreInfoCollectionView *view2 = [MyOrderStoreInfoCollectionView appView];
            [view2.viewContainer bk_whenTapped:^{
                MyOrderDetailsVC *vc = [MyOrderDetailsVC new];
                vc.data_id = orderItem.id;
                [[AppDelegate sharedAppDelegate] pushViewController:vc];
            }];
            
            view2.block = ^(){
                
                
                MyOrderDetailsVC *vc = [MyOrderDetailsVC new];
                vc.data_id = orderItem.id;
                [[AppDelegate sharedAppDelegate] pushViewController:vc];
                
            };
            [view2 setBackgroundColor:[UIColor whiteColor]];
            [self.viewStoreContainer addSubview:view2];
            
            [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.viewStoreContainer.mas_left).with.offset(0);
                make.right.equalTo(self.viewStoreContainer.mas_right).with.offset(0);
                make.top.equalTo(self.viewStoreContainer.mas_top).with.offset(itemHeight);
                make.height.mas_offset(92 + 46);
            }];
            
            view2.item = item;
            view2.lbStatus.text = _orderItem.status_name;
             
            itemHeight = itemHeight + 92 + 46;
         
        }
        
    }
     
    //itemHeight = 92;
    self.layoutStoreHeight.constant = itemHeight;
    
    
    if ([orderItem.status_name isEqualToString:@"待付款"]) {
        self.viewTotalContainer.hidden = NO;
        self.layoutTotalHeight.constant = 44.0f;
        
        self.lbTotalPrice.hidden = NO;
        self.lbTotalAccount.hidden = NO;
        
        self.lbTotalAccount.text = [NSString stringWithFormat:@"共%ld件商品需付款：",orderItem.count];
        //self.lbTotalPrice.text = [NSString stringWithFormat:@"￥%@",orderItem.app_format_total_price];
        
        NSString *current_price = [NSString stringWithFormat:@"￥%@",orderItem.app_format_total_price];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:current_price];
        [AttributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:10]
         
                              range:NSMakeRange(current_price.length - 2, 2)];
        
        [AttributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:10]
         
                              range:NSMakeRange(0, 1)];
        
        self.lbTotalPrice.attributedText = AttributedStr;
        
    }else {
        self.viewTotalContainer.hidden = YES;
        
        self.lbTotalPrice.hidden = YES;
        self.lbTotalAccount.hidden = YES;
        
        self.layoutTotalHeight.constant = 0.0f;
    }
  
    
    for (UIView *view in self.viewButtonContainer.subviews) {
        [view removeFromSuperview];
    }
    
    if (orderItem.operation.count == 0) {
        self.layoutButtonHeight.constant = 0;
        self.viewButtonContainer.height = YES;
    }else {
        self.layoutButtonHeight.constant = 42;
        self.viewButtonContainer.height = NO;
        
        CGFloat right = 10;
        for (MyOrderOperation *operation in orderItem.operation) {
            CGSize size = [self boundingSizeWithString:operation.name font:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(300, 100)];
            
            UIButton *btn = [UIButton new];
            
            btn.layer.cornerRadius = 2.0;//2.0是圆角的弧度，根据需求自己更改
            [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [btn setTitle:operation.name forState:UIControlStateNormal];
            if (![operation.type isEqualToString:@"j-payment"]) {
                [btn setTitleColor:kAppFontColorComblack forState:UIControlStateNormal];
                btn.layer.borderColor = RGB(231, 231, 231).CGColor;//设置边框颜色
                btn.layer.borderWidth = 0.5f;//设置边框颜色
            }else {
                [btn setBackgroundColor:RGB(255, 34, 68)];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            
            [self.viewButtonContainer addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.viewButtonContainer);
                make.right.equalTo(self.viewButtonContainer.mas_right).with.offset(-right);
                make.size.mas_equalTo(CGSizeMake(size.width + 25, 28));
            }];
            
            right = right + 10 + size.width + 25;
            
            __block MyCommonOrderTBCell *weakSelf = self;
            [btn bk_whenTouches:1 tapped:1 handler:^{
                 
                if (operation.param) {
                    [FWO2OJump myOrderHandler:operation.type orderId:orderItem.id couponType:operation.param.coupon_status];
                }else {
                    [FWO2OJump myOrderHandler:operation.type orderId:orderItem.id couponType:0];
                }
                
            }];
            
            
        }
        
        /*
        UIView *line = [UIView new];
        [line setBackgroundColor:kLineColor];
        
        [self.viewButtonContainer addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.viewButtonContainer.mas_top).with.offset(0);
            make.right.equalTo(self.viewButtonContainer.mas_right).with.offset(0);
            make.left.equalTo(self.viewButtonContainer.mas_left).with.offset(10);
            make.height.mas_offset(0.5);
            
        }];
         */
        
        
    }
   
}

#pragma mark 计算文字宽度

- (CGSize)boundingSizeWithString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize textSize = CGSizeZero;
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED && __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0)
    
    if (![string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        // below ios7
        textSize = [string sizeWithFont:font
                      constrainedToSize:size
                          lineBreakMode:NSLineBreakByWordWrapping];
    }
    else
#endif
    {
        //iOS 7
        CGRect frame = [string boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName:font } context:nil];
        textSize = CGSizeMake(frame.size.width, frame.size.height + 1);
    }
    
    return textSize;
}


@end
