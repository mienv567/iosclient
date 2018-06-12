//
//  FavorableTBCell.m
//  FanweO2O
//  优惠卷
//  Created by hym on 2017/1/11.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "FavorableTBCell.h"
#import "FavorableModel.h"
static NSString *const ID = @"FavorableTBCell";

@interface FavorableTBCell()

@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbLocation_name;
@property (weak, nonatomic) IBOutlet UILabel *lbDistance;
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbInfo;
@property (weak, nonatomic) IBOutlet UILabel *lbYouhui_value;

@property (weak, nonatomic) IBOutlet UIImageView *imageStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imageSide;

@property (weak, nonatomic) IBOutlet UILabel *lbOtherName;
@property (weak, nonatomic) IBOutlet UIButton *btnGet;      //立即领取

@property (weak, nonatomic) IBOutlet UIView *topCircle;
@property (weak, nonatomic) IBOutlet UIView *bottomCircle;

@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIView *line;

@end

@implementation FavorableTBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = kBackGroundColor;
    self.backgroundColor = kBackGroundColor;

    [self.btnGet setCornerRadius:4];
    
    [self.viewContainer setCornerRadius:6];
    self.viewContainer.layer.borderWidth = 1;
    self.viewContainer.layer.borderColor = [kBackGroundColor CGColor];
    
    [self.viewContainer bringSubviewToFront:self.topCircle];
    self.topCircle.layer.borderWidth = 1;
    self.topCircle.layer.borderColor = [RGB(225, 225, 225) CGColor];
    [self.topCircle setCornerRadius:5];
    [self.topCircle setBackgroundColor:kBackGroundColor];
    
    [self.viewContainer bringSubviewToFront:self.bottomCircle];
    self.bottomCircle.layer.borderWidth = 1;
    self.bottomCircle.layer.borderColor = [RGB(225, 225, 225) CGColor];
    [self.bottomCircle setCornerRadius:5];
    [self.bottomCircle setBackgroundColor:kBackGroundColor];
    
    [self.line setBackgroundColor:RGB(225, 225, 225)];
    
    
    _lbDistance.textColor = kAppFontColorLightGray;
    _lbStatus.textColor = kAppFontColorLightGray;
    _lbInfo.textColor = kAppFontColorComblack;
    _lbOtherName.textColor = kAppFontColorComblack;
    _lbLocation_name.textColor = kAppFontColorComblack;
    
    [_lbYouhui_value setFont:[UIFont systemFontOfSize:25 weight:0.1]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview {
    
    FavorableTBCell *cell = [newTableview dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setModel:(FavorableModel *)model {
    _model = model;
    
    //status:1-可领取；-1-未开始；0-不可领取；2-已领取，去使用
    
    if (model.status == 0) {
        //已抢光
        _btnGet.hidden = YES;
        _lbInfo.hidden = YES;
        _lbStatus.hidden = YES;
        _lbDistance.hidden = NO;
        _lbName.hidden = NO;
        _lbOtherName.hidden = YES;
        _lbLocation_name.hidden = NO;
        _imageStatus.hidden = NO;
        
        //_lbOtherName.text = model.name;
        
        _lbDistance.text = [NSString stringWithFormat:@"%.2fkm",model.distance/1000];
        _lbName.text = model.name;
        _lbLocation_name.text = model.location_name;
        
        [_lbYouhui_value setTextColor:kAppFontColorGray];
        
        [_imageSide setImage:[UIImage imageNamed:@"youhuis-border-gray"]];
        
        /*
        'info'="已结束";
        'order_status'=7;
        
        'info'="已抢光";
        'order_status'=6;
        
        'info'="积分不足";
        'order_status'=2;
        
        'info'="经验不足";
        'order_status'=3;
        
        'info'="已领取";
        'order_status'=5;
        
        'order_status'=4;
        'info'="x时x分"; // 倒计时
        */
        if (_model.order_status == 6) {
            [_imageStatus setImage:[UIImage imageNamed:@"youhui-sold-out"]];
        }else if (_model.order_status == 2) {
            [_imageStatus setImage:[UIImage imageNamed:@"youhui-no-point"]];
        }else if (_model.order_status == 7) {
            [_imageStatus setImage:[UIImage imageNamed:@"events_sale_out"]];
        }
        
        
        
        
    }else if(model.status == 1) {
        
        _btnGet.hidden = NO;
        _lbInfo.hidden = NO;
        _lbStatus.hidden = NO;
        _lbDistance.hidden = NO;
        _lbName.hidden = NO;
        _lbOtherName.hidden = YES;
        _lbLocation_name.hidden = NO;
        _imageStatus.hidden = YES;

        _lbInfo.text = model.info;
        //_lbStatus.text = model.status;
        _lbDistance.text = [NSString stringWithFormat:@"%.2fkm",model.distance/1000];
        /*
        if (model.distance > 1000) {
            _lbDistance.text = [NSString stringWithFormat:@"%.2fkm",model.distance/1000];
        }else {
            _lbDistance.text = [NSString stringWithFormat:@"%.2fm",model.distance];
        }
        */
        _lbName.text = model.name;
        _lbLocation_name.text = model.location_name;
        
        
        _lbStatus.text = @"已抢";
        
        
        [_lbYouhui_value setTextColor:kAppFontColorRed];
        
        [_imageSide setImage:[UIImage imageNamed:@"youhuis-border"]];
        
    }else if(model.status == 2){
        //已领取，去使用
        [self.btnGet setTitle:@"去使用" forState:UIControlStateNormal];
        _btnGet.hidden = NO;
        _lbInfo.hidden = NO;
        _lbStatus.hidden = NO;
        _lbDistance.hidden = NO;
        _lbName.hidden = NO;
        _lbOtherName.hidden = YES;
        _lbLocation_name.hidden = NO;
        _imageStatus.hidden = YES;
        
        _lbInfo.text = model.info;
        //_lbStatus.text = model.status;
        _lbDistance.text = [NSString stringWithFormat:@"%.2fkm",model.distance/1000];
        /*
        if (model.distance > 1000) {
            _lbDistance.text = [NSString stringWithFormat:@"%.2fkm",model.distance/1000];
        }else {
            _lbDistance.text = [NSString stringWithFormat:@"%.2fm",model.distance];
        }
        */
        _lbName.text = model.name;
        _lbLocation_name.text = model.location_name;
        
        
        _lbStatus.text = @"已抢";
        
        
        [_lbYouhui_value setTextColor:kAppFontColorRed];
        
        [_imageSide setImage:[UIImage imageNamed:@"youhuis-border"]];
    }else if (model.status == -1) {
        //未开始
    }
    
    
    if ([model.youhui_type integerValue] == 0) {
        NSString *current_price;
        if (model.youhui_value >=10) {
            current_price = [NSString stringWithFormat:@"￥%.0f",model.youhui_value];
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:current_price];
            
            [AttributedStr addAttribute:NSFontAttributeName
             
                                  value:[UIFont systemFontOfSize:20 weight:0.1]
             
                                  range:NSMakeRange(0, 1)];
            
            _lbYouhui_value.attributedText = AttributedStr;
        }else
        {
            current_price = [NSString stringWithFormat:@"￥%.1lf",model.youhui_value];
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:current_price];
            [AttributedStr addAttribute:NSFontAttributeName
             
                                  value:[UIFont systemFontOfSize:20 weight:0.1]
             
                                  range:NSMakeRange(current_price.length - 1, 1)];
            
            [AttributedStr addAttribute:NSFontAttributeName
             
                                  value:[UIFont systemFontOfSize:20 weight:0.1]
             
                                  range:NSMakeRange(0, 1)];
            
            _lbYouhui_value.attributedText = AttributedStr;
        }
        
       
        
    }else {
        
        NSString *current_price = [NSString stringWithFormat:@"%.1lf折",model.youhui_value];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:current_price];
        [AttributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:20 weight:0.1]
         
                              range:NSMakeRange(current_price.length - 2, 2)];
        
        _lbYouhui_value.attributedText = AttributedStr;
        
        
    }
    
}

- (IBAction)onCliKGet:(id)sender {
    if ([_delegate respondsToSelector:@selector(immediatelyGetWithModel:)]) {
        [_delegate performSelector:@selector(immediatelyGetWithModel:) withObject:_model];
    }
}

@end
