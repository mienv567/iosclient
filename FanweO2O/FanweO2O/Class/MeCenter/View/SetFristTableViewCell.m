//
//  SetFristTableViewCell.m
//  FanweO2O
//
//  Created by ycp on 17/1/11.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SetFristTableViewCell.h"

@implementation SetFristTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = KAppTextFont13;
        self.detailTextLabel.font = KAppTextFont13;
        self.detailTextLabel.textColor = KAppMainTextBackColor;
        self.selectionStyle =UITableViewCellSelectionStyleNone;
        UIView *view =[[UIView alloc] initWithFrame:CGRectMake(15, 43, kScreenW, 1)];
        view.backgroundColor =kGaryGroundColor;
        [self addSubview:view];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
