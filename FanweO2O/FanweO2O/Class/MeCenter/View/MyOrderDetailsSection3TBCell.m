//
//  MyOrderDetailsSection3TBCell.m
//  FanweO2O
//
//  Created by hym on 2017/3/7.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MyOrderDetailsSection3TBCell.h"

#import "MyOrderDetailsModel.h"
#import "MyOrderImageView.h"
static NSString *const ID = @"MyOrderDetailsSection3TBCell";

@interface MyOrderDetailsSection3TBCell()


@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbCount;
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;

@property (weak, nonatomic) IBOutlet MyOrderImageView *image;


@end

@implementation MyOrderDetailsSection3TBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_lbName setTextColor:kAppFontColorComblack];
    [_lbPrice setTextColor:RGB(255, 34, 68)];
    [_lbCount setTextColor:kAppFontColorComblack];
    [_lbStatus setTextColor:kAppFontColorLightGray];
    
    [self.contentView setBackgroundColor:RGB(247, 248, 248)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview {
    
    MyOrderDetailsSection3TBCell *cell = [newTableview dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
    
}

- (void)setModel:(MyOrderDetailsStoreItem *)model {
    _model = model;
    _lbName.text = model.name;
    
    
    //.00变小
    NSString *current_price = [NSString stringWithFormat:@"￥%@",model.app_format_unit_price];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:current_price];
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:10]
     
                          range:NSMakeRange(current_price.length - 2, 2)];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:10]
     
                          range:NSMakeRange(0, 1)];
    
    _lbPrice.attributedText = AttributedStr;

    
    //_lbPrice.text = [NSString stringWithFormat:@"￥%@",model.app_format_unit_price];
    _lbCount.text = [NSString stringWithFormat:@"x%@",model.number];
    _lbStatus.text = model.deal_orders;
    [_image.imageView sd_setImageWithURL:[NSURL URLWithString:model.deal_icon] placeholderImage:kDefaultCoverIcon];
}

@end
