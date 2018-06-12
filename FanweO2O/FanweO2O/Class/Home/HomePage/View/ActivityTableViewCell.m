//
//  ActivityTableViewCell.m
//  FanweO2O
//
//  Created by hym on 2017/1/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ActivityTableViewCell.h"
#import "ActivityBcateListModel.h"
static NSString *const ID = @"ActivityTableViewCell";

@interface ActivityTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgeIcon;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbSupplier_info_name;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UILabel *lbDistance;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIImageView *imageStatue;

@end

@implementation ActivityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = kBackGroundColor;
    self.contentView.backgroundColor = kBackGroundColor;
    [self.lbSupplier_info_name setTextColor:kAppFontColorComblack];
    [self.lbTime setTextColor:kAppFontColorGray];
    [self.lbDistance setTextColor:kAppFontColorGray];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview {
    
    ActivityTableViewCell *cell = [newTableview dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setItem:(ActivityItem *)item {
    _item = item;
    
    [_imgeIcon sd_setImageWithURL:[NSURL URLWithString:item.img]];
    
    [_image sd_setImageWithURL:[NSURL URLWithString:item.supplier_info_preview]];
    
    _lbName.text = item.name;
    
    _lbSupplier_info_name.text = item.supplier_info_name;
    
    if ([item.submit_begin_time_format length] == 0 || [item.submit_end_time_format length] == 0) {
        _lbTime.text = [NSString stringWithFormat:@"报名时间: %@",item.sheng_time_format];
    }else {
        _lbTime.text = [NSString stringWithFormat:@"报名时间: %@ 至 %@",item.submit_begin_time_format,item.submit_end_time_format];
    }
    
    _lbDistance.text = [NSString stringWithFormat:@"%.2fkm",item.distance/1000];
    
    /*
    if (item.distance > 1000) {
        
        _lbDistance.text = [NSString stringWithFormat:@"%.2fkm",item.distance/1000];
        
    }else {
        
        _lbDistance.text = [NSString stringWithFormat:@"%.2fm",item.distance];
        
    }
    */
    
    if (item.out_time == 1 || item.is_over == 1) {
        [self.imageStatue setImage:[UIImage imageNamed:@"events_sale_out"]];
        self.imageStatue.hidden = NO;
    }else {
        if (item.submit_count == item.total_count) {
            [self.imageStatue setImage:[UIImage imageNamed:@"events_house_full"]];
            self.imageStatue.hidden = NO;
        }else {
            self.imageStatue.hidden = YES;
        }
        
        
    }
    
    
}

@end
