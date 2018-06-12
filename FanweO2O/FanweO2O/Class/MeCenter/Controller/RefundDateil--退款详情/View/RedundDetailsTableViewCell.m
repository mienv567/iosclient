//
//  RedundDetailsTableViewCell.m
//  FanweO2O
//
//  Created by ycp on 17/3/2.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "RedundDetailsTableViewCell.h"

@implementation RedundDetailsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        _resultsLabel =[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 18)];
        _resultsDetailsLabel =[[UILabel alloc] init];
        _resultsLabel.textColor =[UIColor colorWithRed:0.612 green:0.612 blue:0.612 alpha:1.00];
        _resultsDetailsLabel.textColor =KAppMainTextBackColor;
        _resultsLabel.text =@"退款原因:";
        _resultsLabel.font =kAppTextFont12;
        _resultsDetailsLabel.font =kAppTextFont12;
        _resultsDetailsLabel.numberOfLines=0;
        _resultsDetailsLabel.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:_resultsLabel];
        [self.contentView addSubview:_resultsDetailsLabel];
        
    }
    return self;
}

- (void)setTextContent:(NSString *)textContent
{
    CGSize height = [textContent boundingRectWithSize:CGSizeMake(kScreenW-20-CGRectGetMaxX(_resultsLabel.frame), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kAppTextFont12} context:nil].size;
    _resultsDetailsLabel.frame = CGRectMake(CGRectGetMaxX(_resultsLabel.frame)+10, 11, kScreenW-20-CGRectGetMaxX(_resultsLabel.frame), height.height);
    _resultsDetailsLabel.text = textContent;
    _height = height.height;
    
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
