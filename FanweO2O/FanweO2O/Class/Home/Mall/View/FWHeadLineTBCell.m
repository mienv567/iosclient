//
//  FWHeadLineTBCell.m
//  FanweO2O
//  头条
//  Created by hym on 2016/12/12.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "FWHeadLineTBCell.h"
#import "HeadLineModel.h"
#import "SDCycleScrollView.h"
#import "FWO2OJump.h"
#import "FWO2OJumpModel.h"
static NSString *cellIndent =  @"FWHeadLineTBCell";

@interface FWHeadLineTBCell()<SDCycleScrollViewDelegate>
{
    SDCycleScrollView *_cycleScrollView;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;

@end

@implementation FWHeadLineTBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIView *line = [self.contentView viewWithTag:1001];
    [line setBackgroundColor:kLineColor];
    UIView *line1 = [self.contentView viewWithTag:1002];
    [line1 setBackgroundColor:kLineColor];
    UIButton *btnMore = [self.contentView viewWithTag:1003];
    [btnMore setTitleColor:kAppFontColorComblack forState:UIControlStateNormal];
    // Initialization code
    
    SDCycleScrollView *cycleScrollView = [[SDCycleScrollView alloc] init];
    cycleScrollView.delegate =self;
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
    cycleScrollView.onlyDisplayText = YES;
    cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];
    cycleScrollView.titleLabelTextColor = kAppFontColorComblack;
    _cycleScrollView = cycleScrollView;
    
    [self.viewContainer addSubview:_cycleScrollView];
    
    [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewContainer.mas_left).with.offset(0);
        make.right.equalTo(self.viewContainer.mas_right).with.offset(0);
        make.top.equalTo(self.viewContainer.mas_top).with.offset(0);
        make.bottom.equalTo(self.viewContainer.mas_bottom).with.offset(0);
    }];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onClickMore:(id)sender {
   
    if (_delegate && [_delegate respondsToSelector:@selector(moreButton)]) {
        [_delegate moreButton];
    }
}

+ (instancetype)cellWithTbaleview:(UITableView *)newTableview {
    
    FWHeadLineTBCell *cell = [newTableview dequeueReusableCellWithIdentifier:cellIndent];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

/*
- (void)setHeadModel:(HeadLineModel *)headModel {
    _headModel = headModel;
    
    [_imageIcon sd_setImageWithURL:[NSURL URLWithString:headModel.url] placeholderImage:DEFAULT_ICON];
}
 */

- (void)setHeadLineArray:(NSMutableArray *)headLineArray {
    _headLineArray = headLineArray;
    
    NSMutableArray *tiles = [NSMutableArray new];
    
    for (HeadLineModel *aa in headLineArray) {
        
        [tiles addObject:aa.name];
    }
    _cycleScrollView.titlesGroup = tiles;
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{

    FWO2OJumpModel *model =[FWO2OJumpModel new];
    HeadLineModel *aa = _headLineArray[index];
    
    NSString *urlString =[NSString stringWithFormat:@"%@?ctl=notice&data_id=%@",
                          API_LOTTERYOUT_URL,aa.id];
    model.url =urlString;
    model.type =0;
    model.isHideTabBar = YES;
    model.isHideNavBar = YES;
    [FWO2OJump didSelect:model];
}
@end
