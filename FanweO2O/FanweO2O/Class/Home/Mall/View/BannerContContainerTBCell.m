//
//  BannerContContainerTBCell.m
//  FanweO2O
//  广告栏
//  Created by hym on 2016/12/12.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "BannerContContainerTBCell.h"
#import "BannerModel.h"
#import "SDCycleScrollView.h"
static NSString *cellIndent =  @"BannerContContainerTBCell";
@interface BannerContContainerTBCell ()<SDCycleScrollViewDelegate> {
    SDCycleScrollView *_cycleScrollView;
    NSInteger _isSquare;
    UIPageControl *_page;
}

@end

@implementation BannerContContainerTBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (BannerContContainerTBCell *)cellWithTableView:(UITableView *)tableView {
    
    BannerContContainerTBCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndent];
    
    if (!cell) {
        cell = [[BannerContContainerTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndent];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell initialize:1];
    }
    
    return cell;
}

+ (BannerContContainerTBCell *)cellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier {
    BannerContContainerTBCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (!cell) {
        cell = [[BannerContContainerTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell initialize:1];
    }
    
    return cell;
}

+ (BannerContContainerTBCell *)cellWithTableView:(UITableView *)tableView isSquare:(NSInteger)isSquare {
    BannerContContainerTBCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndent];
    
    if (!cell) {
        cell = [[BannerContContainerTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndent];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell initialize:isSquare];
    }
    
    return cell;
}

- (void)layoutSubviews {
//    UIView *bannerView = [self.contentView viewWithTag:1000];
//    if (_isSquare == 0) {
//        UIBezierPath *maskPath =[UIBezierPath bezierPath];
//        [maskPath moveToPoint:CGPointMake(0, 0)];
//        [maskPath addLineToPoint:CGPointMake(0, 0)];
//        [maskPath addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), 0)];
//        [maskPath addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 20)];
//        [maskPath addQuadCurveToPoint:CGPointMake(0, CGRectGetHeight(self.frame) - 20) controlPoint:CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame))];
//        CAShapeLayer *maskLayer =[[CAShapeLayer alloc] init];
//        maskLayer.path = maskPath.CGPath;
//        bannerView.layer.mask = maskLayer;
//    }
}

- (void)initialize:(NSInteger)isSquare {
    
    UIView *bannerView = [[UIView alloc] init];
    bannerView.tag = 1000;
    [self.contentView addSubview:bannerView];
    [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.top.equalTo(self.contentView.mas_top).with.offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
    }];
    
    _cycleScrollView = [[SDCycleScrollView alloc] init];
    _cycleScrollView.delegate = self;
    _cycleScrollView.pageDotImage = [UIImage imageNamed:@"page_normal"];
    _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"page_select"];
//    _cycleScrollView.hidesForSinglePage =YES;
//    _cycleScrollView.pageControlDotSize =CGSizeMake(25, 8);
    _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
    _cycleScrollView.pageControlBottomOffset = 10;
    _cycleScrollView.infiniteLoop = YES;
    [bannerView addSubview:_cycleScrollView];
    [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bannerView.mas_left).with.offset(0);
        make.right.equalTo(bannerView.mas_right).with.offset(0);
        make.top.equalTo(bannerView.mas_top).with.offset(0);
        make.bottom.equalTo(bannerView.mas_bottom).with.offset(0);
    }];
    
    _isSquare = isSquare;
    

}


- (void)setBannerArray:(NSMutableArray *)bannerArray {
    _bannerArray = bannerArray;
    
    NSMutableArray *banner = [NSMutableArray new];
    
    for (BannerModel *model in bannerArray) {
        [banner addObject:model.img];
    }
    _page.numberOfPages =banner.count;
    _cycleScrollView.imageURLStringsGroup = banner;
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    BannerModel *model = _bannerArray[index];
    if ([self.delegate respondsToSelector:@selector(bannerContContainerGoNextVC:)]) {
        [self.delegate bannerContContainerGoNextVC:model];
    }
}



@end
