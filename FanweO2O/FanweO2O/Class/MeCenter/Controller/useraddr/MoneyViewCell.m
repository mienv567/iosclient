//
//  MoneyViewCell.m
//  ZhoubaitongO2O
//
//  Created by Harlan on 2018/6/23.
//  Copyright © 2018年 xfg. All rights reserved.
//

#import "MoneyViewCell.h"

@interface MoneyViewCell()
@property (weak, nonatomic) IBOutlet UILabel *orderLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *moneylable;

@end

@implementation MoneyViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setModel:(MoneyModel *)model {
    _model = model;
}
@end
