//
//  CustomGoodsComTBCell.m
//  FanweO2O
//
//  Created by hym on 2016/12/13.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "CustomGoodsComTBCell.h"
#import "MyTool.h"
static NSString *const ID = @"CustomGoodsComTBCell";
@interface CustomGoodsComTBCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageShop;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbBrief;
@property (weak, nonatomic) IBOutlet UILabel *lbCurrentPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbOriginPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbBuyCount;

@property (weak, nonatomic) IBOutlet UILabel *lbDeletePriceLabel;

@end

@implementation CustomGoodsComTBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_line setBackgroundColor:kLineColor];
    [_lbName setTextColor:kAppFontColorComblack];
    [_lbOriginPrice setTextColor:kAppFontColorLightGray];
    //[_lbCurrentPrice setTextColor:kAppFontColorLightGray];
    [_lbBuyCount setTextColor:kAppFontColorLightGray];
     _addLabel.textColor =kAppFontColorLightGray;
    [_lbBrief setTextColor:kAppFontColorLightGray];
    
    [_lbDeletePriceLabel setTextColor:kAppFontColorLightGray];
}

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview {
    CustomGoodsComTBCell *cell = [newTableview dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;

}

- (void)setGoodModel:(CustomGoodsModel *)goodModel {
    _goodModel = goodModel;
    
    [_imageShop sd_setImageWithURL:[NSURL URLWithString:goodModel.f_icon] placeholderImage:DEFAULT_ICON];

    if(self.count == 1){
        _lbName.text = goodModel.brief;
        _lbBrief.text = @"";
    }else {
        _lbName.text =goodModel.supplier_name;
        _lbBrief.text = goodModel.brief;
        [MyTool setLabelSpacing:_lbBrief lfSpacing:2.5 strContent:goodModel.brief];
    }
    
    
    //.00变小
    NSString *current_price = [NSString stringWithFormat:@"%.2lf",goodModel.current_price];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:current_price];
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:12]
     
                          range:NSMakeRange(current_price.length - 2, 2)];
    
    _lbCurrentPrice.attributedText = AttributedStr;
    
    //删除线
    
    NSString *oldPrice = [NSString stringWithFormat:@"%.0lf",goodModel.origin_price];
    NSUInteger length = [oldPrice length];
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:kAppFontColorLightGray range:NSMakeRange(0, length)];
     [attri addAttribute:NSFontAttributeName value:kAppTextFont12 range:NSMakeRange(0, length)];
    //[_lbOriginPrice setAttributedText:attri];
    if ([goodModel.buy_count integerValue] > 0) {
         _lbBuyCount.text = [NSString stringWithFormat:@"已售%@",goodModel.buy_count];
    }
    if (goodModel.distance != nil) {
        if (_count ==1) {
            _addLabel.hidden =YES;
        }else
        {
            _addLabel.text =goodModel.distance;
        }
        
    }
    
    //价格删除线
    //删除线
    if (goodModel.origin_price != 0) {
        _lbDeletePriceLabel.hidden = NO;
        NSString *oldPrice1 = [NSString stringWithFormat:@"￥%.0lf",goodModel.origin_price];
        NSUInteger length2 = [oldPrice1 length];
        
        NSMutableAttributedString *attri1 = [[NSMutableAttributedString alloc] initWithString:oldPrice1];
        [attri1 addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length2)];
        [attri1 addAttribute:NSStrikethroughColorAttributeName value:kAppFontColorLightGray range:NSMakeRange(0, length2)];
       
        [_lbDeletePriceLabel setAttributedText:attri1];

    }else {
        _lbDeletePriceLabel.hidden = YES;
    }
    
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
