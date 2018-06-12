//
//  CustomGoodsTableViewCell.m
//  FanweO2O
//
//  Created by ycp on 16/12/7.
//  Copyright © 2016年 fanwe. All rights reserved.
//

#import "CustomGoodsTableViewCell.h"
#import "CustomGoodsModel.h"
#import "MyTool.h"

static NSString *const ID = @"CustomGoodsTableViewCell";
@interface CustomGoodsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftMainLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftRMBStyle;
@property (weak, nonatomic) IBOutlet UILabel *leftPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftDeletePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftSaleLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;

@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightMainLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightRMBStyle;
@property (weak, nonatomic) IBOutlet UILabel *rightPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightDeletePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightSaleLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *OriginalPrice;

@property (nonatomic, strong) CustomGoodsModel *model1;
@property (nonatomic, strong) CustomGoodsModel *model2;
@end

@implementation CustomGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIView *line = [self.contentView viewWithTag:1001];
    line.backgroundColor = kBackGroundColor;
    
    UIView *line2 = [self.contentView viewWithTag:1002];
    line2.backgroundColor = kBackGroundColor;
    
    [_leftMainLabel setTextColor:kAppFontColorComblack];
    
    _leftMainLabel.font =KAppTextFont13;
    [_rightMainLabel setTextColor:kAppFontColorComblack];
    
    [_rightSaleLabel setTextColor:kAppFontColorLightGray];
    _rightMainLabel.font =KAppTextFont13;
    [_leftSaleLabel setTextColor:kAppFontColorLightGray];
    [_rightDeletePriceLabel setTextColor:kAppFontColorLightGray];
    [_leftDeletePriceLabel setTextColor:kAppFontColorLightGray];
   
}

- (IBAction)leftButtonClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(customGoodGoNextVC:)]) {
        [self.delegate customGoodGoNextVC:_model1];
    }
    
}


- (IBAction)rightButtonClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(customGoodGoNextVC:)]) {
        [self.delegate customGoodGoNextVC:_model2];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview {
    CustomGoodsTableViewCell *cell = [newTableview dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)upDataWith:(NSMutableArray *)array indexPath:(NSIndexPath *)indexPath {
    
    
    //第一个
    if ((indexPath.row + 1) * 2 <= array.count) {
        //有数据
        
        _leftView.hidden = NO;
        _rightView.hidden = NO;
        
        CustomGoodsModel *model1 = array[2*indexPath.row];
        _model1 = model1;
        
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:model1.f_icon] placeholderImage:DEFAULT_ICON];
        _leftMainLabel.text = model1.name;
        [MyTool setLabelSpacing:_leftMainLabel lfSpacing:2.5 strContent:model1.name];
        //.00变小
        NSString *current_price = [NSString stringWithFormat:@"%.2lf",model1.current_price];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:current_price];
        [AttributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:12]
         
                              range:NSMakeRange(current_price.length - 2, 2)];
        
        _leftPriceLabel.attributedText = AttributedStr;
        
        //删除线
        NSString *oldPrice = [NSString stringWithFormat:@"%.2f",model1.origin_price];
        NSUInteger length = [oldPrice length];
        
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
        [attri addAttribute:NSStrikethroughColorAttributeName value:kAppFontColorLightGray range:NSMakeRange(0, length)];
        
        if (_hsShowPrice) {
            
            if (model1.origin_price != 0) {
                [_leftDeletePriceLabel setAttributedText:attri];
            }
            
        }
        
        //
        
        if ([model1.buy_count integerValue ]> 0) {
            _leftSaleLabel.text = [NSString stringWithFormat:@"已售%@",model1.buy_count];_leftSaleLabel.text = [NSString stringWithFormat:@"已售%@",model1.buy_count];
        }
        
        
        
        //cell 2
        CustomGoodsModel *model2 = array[2*indexPath.row + 1];
        _model2 = model2;
        
        [_rightImageView sd_setImageWithURL:[NSURL URLWithString:model2.f_icon] placeholderImage:DEFAULT_ICON];
        _rightMainLabel.text = model2.name;
        [MyTool setLabelSpacing:_rightMainLabel lfSpacing:2.5 strContent:model2.name];
        
        NSString *current_price2 = [NSString stringWithFormat:@"%.2lf",model2.current_price];
        NSMutableAttributedString *AttributedStr2 = [[NSMutableAttributedString alloc]initWithString:current_price2];
        [AttributedStr2 addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:12]
         
                              range:NSMakeRange(current_price2.length - 2, 2)];
        
        _rightPriceLabel.attributedText = AttributedStr2;
        
        //删除线
        NSString *oldPrice2 = [NSString stringWithFormat:@"%.2f",model2.origin_price];
        NSUInteger length2 = [oldPrice2 length];
        
        NSMutableAttributedString *attri2 = [[NSMutableAttributedString alloc] initWithString:oldPrice2];
        [attri2 addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length2)];
        [attri2 addAttribute:NSStrikethroughColorAttributeName value:kAppFontColorLightGray range:NSMakeRange(0, length2)];
        
        if (_hsShowPrice) {
            
            if (model2.origin_price != 0) {
               [_rightDeletePriceLabel setAttributedText:attri2];
            }
            
            
        }
        
        //
        if ([model2.buy_count integerValue ]> 0) {
            _rightSaleLabel.text = [NSString stringWithFormat:@"已售%@",model2.buy_count];
        }
       
        
    }else {
        
        _rightView.hidden = YES;
        CustomGoodsModel *model1 = array[2*indexPath.row];
        _model1 = model1;
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:model1.f_icon] placeholderImage:DEFAULT_ICON];
        _leftMainLabel.text = model1.name;
        
        //.00变小
        NSString *current_price = [NSString stringWithFormat:@"%.2f",model1.current_price];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:current_price];
        [AttributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:12]
         
                              range:NSMakeRange(current_price.length - 2, 2)];
        
        _leftPriceLabel.attributedText = AttributedStr;
        
        //删除线
        NSString *oldPrice = [NSString stringWithFormat:@"%.2f",model1.origin_price];
        NSUInteger length = [oldPrice length];
        
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
        [attri addAttribute:NSStrikethroughColorAttributeName value:kAppFontColorLightGray range:NSMakeRange(0, length)];
        
        if (_hsShowPrice) {
            
            if (model1.origin_price != 0) {
                [_leftDeletePriceLabel setAttributedText:attri];
            }
            
        }
        
        
        if ([model1.buy_count integerValue ]> 0) {
            _leftSaleLabel.text = [NSString stringWithFormat:@"已售%@",model1.buy_count];_leftSaleLabel.text = [NSString stringWithFormat:@"已售%@",model1.buy_count];
        }

    }
    
}

@end
