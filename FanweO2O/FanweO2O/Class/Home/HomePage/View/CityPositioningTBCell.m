//
//  CityPositioningTBCell.m
//  FanweO2O
//
//  Created by hym on 2016/12/15.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "CityPositioningTBCell.h"
#import "CityModelFirst.h"
#import "NSString+Addition.h"
static NSString *cellIndent =  @"CityPositioningTBCell";
@implementation CityPositioningTBCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

+ (CityPositioningTBCell *)cellWithTableView:(UITableView *)tableView {
    CityPositioningTBCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndent];
    
    if (!cell) {
        cell = [[CityPositioningTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndent];
        [cell doInit];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return cell;
}

- (void)doInit {
    UIView *view = self.contentView;
    UILabel *lbKey = [UILabel new];
    lbKey.layer.borderWidth = 1;
    lbKey.layer.cornerRadius = 10;
    lbKey.textColor = RGB(255, 34, 68);
    lbKey.layer.borderColor = RGB(255, 34, 68).CGColor;
    lbKey.textAlignment = NSTextAlignmentCenter;
    lbKey.tag = 1000;
    //lbKey.text = cityModel.key;
    
    [view addSubview:lbKey];
    [lbKey mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).with.offset(kDefaultMargin);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.equalTo(view.mas_top).with.offset(kDefaultMargin);
    }];
}

- (void)setCityModel:(CityValueModel *)cityModel {
    _cityModel = cityModel;

    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
        
    }
    UIView *view = self.contentView;
    UILabel *lbKey = [view viewWithTag:1000];
   
   

    lbKey.text = cityModel.key;
    
    NSArray *content = cityModel.coent;
    
    CGFloat btn_left = 40;
    
    NSInteger row = 0;  //行数

    for (int i = 0; i < content.count; i++) {
        
        CityBaseModel *model = content[i];
        CGFloat btn_width = [model.name commonStringWidthForFont:13] + 20;
        if (btn_left + btn_width + 10 > SCREEN_WIDTH) {
            row ++;
            btn_left = 40;
        }
        UIButton *btn = [UIButton new];
        [btn setTitle:model.name forState:UIControlStateNormal];
        [btn setTitleColor:KAppMainTextBackColor forState:UIControlStateNormal];
        btn.titleLabel.font =KAppTextFont13;
        [btn.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [btn addTarget:self action:@selector(onSelctCity:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i+21000;
        [view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left).with.offset(btn_left);
            make.size.mas_equalTo(CGSizeMake(btn_width, 30));
            make.top.equalTo(view.mas_top).with.offset(5 + 50 * row);
        }];
        
        btn_left = btn_left + btn_width + 10;
        
    }
    
    _cityModel.hight = 5 + 50 *(row + 1);
    
}

- (void)onSelctCity:(UIButton *)sender {
    
    CityBaseModel *model = _cityModel.coent[sender.tag-21000];
    
    if ([self.delegate respondsToSelector:@selector(selectCity:)]) {
        [self.delegate selectCity:model];
    }
}

@end
