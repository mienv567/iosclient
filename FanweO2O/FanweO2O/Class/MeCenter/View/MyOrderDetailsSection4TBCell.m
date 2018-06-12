//
//  MyOrderDetailsSection4TBCell.m
//  FanweO2O
//
//  Created by hym on 2017/3/7.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MyOrderDetailsSection4TBCell.h"

#import "MyOrderDetailsModel.h"


static NSString *const ID = @"MyOrderDetailsSection4TBCell";

@interface MyOrderDetailsSection4TBCell()

@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UILabel *lbWay;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutHeight;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UILabel *lbTime1;
@property (weak, nonatomic) IBOutlet UILabel *lbWay1;
@property (weak, nonatomic) IBOutlet UIView *remarkContainer;
@property (weak, nonatomic) IBOutlet UILabel *lbRemark;
@property (weak, nonatomic) IBOutlet UILabel *lbRemark1;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutHeightRemark;
@property (weak, nonatomic) IBOutlet UIView *payWay;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layPayWayHeight;
@property (weak, nonatomic) IBOutlet UILabel *lbPayName;
@property (weak, nonatomic) IBOutlet UILabel *lbPayPrice;
@property (weak, nonatomic) IBOutlet UIView *line2;

@end

@implementation MyOrderDetailsSection4TBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lbWay.textColor = kAppFontColorComblack;
    self.lbWay1.textColor = kAppFontColorComblack;
    self.lbTime1.textColor = kAppFontColorComblack;
    self.lbTime.textColor = kAppFontColorComblack;
    [self.line setBackgroundColor:kLineColor];
    [self.line1 setBackgroundColor:kLineColor];
    [self.line2 setBackgroundColor:kLineColor];
    
    self.lbRemark.textColor = kAppFontColorComblack;
    self.lbRemark1.textColor = kAppFontColorGray;
    
    self.lbPayName.textColor = kAppFontColorComblack;
    self.lbPayPrice.textColor = kAppFontColorComblack;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview {
    
    MyOrderDetailsSection4TBCell *cell = [newTableview dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
    
}

- (void)setOrderModel:(MyOrderDetailsModel *)orderModel {
    _orderModel = orderModel;
    
    _lbTime.text = orderModel.create_time;
    
    if ([orderModel.delivery_id integerValue] > 0) {
        _layoutHeight.constant = 44.5;
        _lbWay.hidden = NO;
        
        _lbWay1.hidden = NO;
        _lbWay.text = [NSString stringWithFormat:@"%@ 运费%ld元",orderModel.delivery_info.name,orderModel.delivery_fee];
        _viewContainer.hidden = NO;
    }else {
        _lbWay.hidden = YES;
        _lbWay1.hidden = YES;
        
        _layoutHeight.constant = 0;
        _viewContainer.hidden = YES;
    }
    
    
    if ([orderModel.memo length] > 0) {
        
        CGSize size = [self boundingSizeWithString:orderModel.memo font:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(CGRectGetWidth(_lbRemark1.frame), 300)];
        
        _layoutHeightRemark.constant = size.height + 30;
        _lbRemark.hidden = NO;
        _lbRemark1.hidden = NO;
        _lbRemark1.text = orderModel.memo;
        _line1.hidden = NO;
    }else {
        _layoutHeightRemark.constant = 0.001f;
        _lbRemark.hidden = YES;
        _lbRemark1.hidden = YES;
        _lbRemark1.text = @"";
        _line1.hidden = YES;
    }
    
    
    if (orderModel.payment_info) {
        
        _layPayWayHeight.constant = 45;
        _lbPayName.text = orderModel.payment_info.name;
        _lbPayPrice.text = orderModel.payment_info.money;
        _lbPayName.hidden = NO;
        _lbPayPrice.hidden = NO;
        
    }else{
        
        _layPayWayHeight.constant = 0;
        _lbPayName.hidden = YES;
        _lbPayPrice.hidden = YES;
    }
    
 
}

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
