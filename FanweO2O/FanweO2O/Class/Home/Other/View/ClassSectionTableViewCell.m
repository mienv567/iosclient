//
//  ClassSectionTableViewCell.m
//  FanweO2O
//
//  Created by hym on 2017/1/9.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ClassSectionTableViewCell.h"
#import "ClassSectionView.h"

static NSString *cellIndent =  @"ClassSectionTableViewCell";

@interface ClassSectionTableViewCell()<ClassSectionTableViewCellDelegate>

@property (nonatomic, strong) ClassSectionView *section;

@end

@implementation ClassSectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (ClassSectionTableViewCell *)cellWithTableView:(UITableView *)tableView {
    
    ClassSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndent];
    
    if (!cell) {
        cell = [[ClassSectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndent];
        [cell doInit];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return cell;
}

- (void)doInit {
    
    ClassSectionView *section = [[ClassSectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.iCount = 4;
    //section.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:section];

    [section mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.top.equalTo(self.contentView.mas_top).with.offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
    }];

    self.section = section;
    
    __weak ClassSectionTableViewCell *weakSelf = self;
    self.section.block = ^(ClassSectionModel *select) {
        if ([weakSelf.delegate respondsToSelector:@selector(ClassSectionSelect:)]) {
            [weakSelf.delegate ClassSectionSelect:select];
        }
    };
}

- (void)setArray:(NSArray *)array {
    _array = array;
    self.section.array = array;
    self.section.iCount = self.iCount;
}

@end
