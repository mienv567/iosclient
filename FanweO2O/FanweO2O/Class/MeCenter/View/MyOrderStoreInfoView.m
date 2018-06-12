//
//  MyOrderStoreInfoView.m
//  FanweO2O
//
//  Created by hym on 2017/3/3.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MyOrderStoreInfoView.h"

#import "MyOrderModel.h"

#import "MyOrderImageView.h"

@interface MyOrderStoreInfoView()


@property (weak, nonatomic) IBOutlet UILabel *lbStoreName;

@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet MyOrderImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *lbAccount;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbStandard;       //规格
@property (weak, nonatomic) IBOutlet UIView *line;


@end

@implementation MyOrderStoreInfoView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.viewContainer setBackgroundColor:RGB(247, 248, 248)];
    [self.line setBackgroundColor:kLineColor];
    [self.lbPrice setTextColor:RGB(255, 34, 68)];
    [self.lbStandard setTextColor:kAppFontColorGray];
    [self.lbStatus setFont:[UIFont systemFontOfSize:15]];
    [self.lbStatus setTextColor:RGB(255, 34, 68)];
}

+ (instancetype )appView {
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSArray *objs = [bundle loadNibNamed:@"MyOrderView" owner:nil options:nil];
    
    return [objs firstObject];
}

- (void)setItem:(DealOrderItem *)item {
    _item = item;
    
    
    
    
    MyOrderStoreItem *store = [item.list firstObject];
    
    [self.imageView.imageView sd_setImageWithURL:[NSURL URLWithString:store.deal_icon] placeholderImage:kDefaultCoverIcon];
    
    //[self.imageIcon sd_setImageWithURL:[NSURL URLWithString:store.deal_icon] placeholderImage:kDefaultCoverIcon];
    
    self.lbStoreName.text = item.supplier_name;
    
    self.lbName.text = store.name;
    
    self.lbAccount.text = [NSString stringWithFormat:@"x%@",store.number];
    
    //.00变小
    NSString *current_price = [NSString stringWithFormat:@"￥%@",store.app_format_unit_price];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:current_price];
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:10]
     
                          range:NSMakeRange(current_price.length - 2, 2)];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:10]
     
                          range:NSMakeRange(0, 1)];
    
    _lbPrice.attributedText = AttributedStr;
    
    

    if ([store.attr_str length] > 0) {
        _lbStandard.text = [NSString stringWithFormat:@"规格: %@",store.attr_str];
    }else {
        _lbStandard.text = @"";
    }
    
    
}


@end
