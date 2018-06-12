//
//  LeftTableViewCell.m
//  FanweO2O
//
//  Created by ycp on 16/12/12.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "LeftTableViewCell.h"

@interface LeftTableViewCell ()
@property (nonatomic, strong) UIView *redView;

@end
@implementation LeftTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 44)];
        self.redView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.redView];
        
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 82-5, 44)];
        self.name.numberOfLines = 0;
        self.name.font = [UIFont systemFontOfSize:13];
        self.name.textAlignment =NSTextAlignmentCenter;
        self.name.textColor =[UIColor blackColor];
        self.name.highlightedTextColor = [UIColor redColor];
        [self.contentView addSubview:self.name];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, kScreenW, 0.5)];
        line.backgroundColor =[UIColor colorWithRed:0.900 green:0.900 blue:0.900 alpha:1.00];
        [self.contentView addSubview:line];
    }
    
    
    
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
    self.contentView.backgroundColor = selected ? [UIColor colorWithRed:0.900 green:0.900 blue:0.900 alpha:1.00] : [UIColor whiteColor];
    self.highlighted = selected;
    self.name.highlighted = selected;
    self.redView.hidden = !selected;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



@end
