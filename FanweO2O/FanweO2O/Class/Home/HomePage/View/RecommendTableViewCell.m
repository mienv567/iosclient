//
//  RecommendTableViewCell.m
//  FanweO2O
//  好店推荐
//  Created by ycp on 16/12/7.
//  Copyright © 2016年 fanwe. All rights reserved.
//

#import "RecommendTableViewCell.h"
#import "RecommendModel.h"
#import "FWO2OJumpModel.h"
#import "FWO2OJump.h"
#import "StoreListVC.h"
static NSString *cellIndent =  @"RecommendTableViewCell";
@interface RecommendTableViewCell()

@property (nonatomic,strong)UIView *backGroundView ;
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UIButton *btn;
@property (nonatomic, strong) UIScrollView *scrollView;

@end


@implementation RecommendTableViewCell


+ (RecommendTableViewCell *)cellWithTableView:(UITableView *)tableView {
    RecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndent];
    
    if (!cell) {
        cell = [[RecommendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndent];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //[cell.contentView setBackgroundColor:kBackGroundColor];
        [cell doInit];
    }
    
    return cell;
    
}

- (void)doInit {
    
    _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 190)];
    _backGroundView.backgroundColor = [UIColor colorWithRed:1.000 green:0.392 blue:0.318 alpha:1.00];
    [self.contentView addSubview:_backGroundView];
    _label = [[UILabel alloc]init];
    _label.center = CGPointMake((SCREEN_WIDTH - 150) / 2, 0);
    _label.size =CGSizeMake(150, 40);
    _label.contentMode = UIViewContentModeCenter;
    _label.textAlignment = NSTextAlignmentCenter;
//    _label =[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 40)];
    _label.textColor =[UIColor whiteColor];
    _label.font =kAppTextFont16;
    _label.text =@"好店推荐";
    [_backGroundView addSubview:_label];
    _btn =[UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame =CGRectMake(kScreenW-75, 0, 60, 40);
    [_btn setImage:[UIImage imageNamed:@"next_arrow"] forState:UIControlStateNormal];
    [_btn setTitle:@"更多" forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -0, 0, 0)];
    [_btn setImageEdgeInsets:UIEdgeInsetsMake(0, 45, 0, 0)];
    _btn.titleLabel.font =KAppTextFont13;
    [_btn addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_backGroundView addSubview:_btn];
    
    UIScrollView *scrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_label.frame), kScreenW, CGRectGetMaxY(_backGroundView.frame)-40-20)];
    scrollView.backgroundColor = [UIColor colorWithRed:1.000 green:0.392 blue:0.318 alpha:1.00];
    scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView = scrollView;
    [_backGroundView addSubview:scrollView];
    
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < dataArray.count; i ++) {
        RecommendModel *model = dataArray[i];
        
        
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake((100 + 10) * i, 90, 100, 20)];
//        view.backgroundColor = [UIColor whiteColor];
//        [_scrollView addSubview:view];
        
        UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake((100+10)*i, 0, 100, 100)];
        imageView.backgroundColor =[UIColor greenColor];
        imageView.userInteractionEnabled = YES;
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *lay = [CAShapeLayer layer];
        lay.frame = imageView.bounds;
        lay.path = bezierPath.CGPath;
        imageView.layer.mask = lay;
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.preview_v2] placeholderImage:kDefaultCoverIcon];
        
        //imageView.frame =CGRectMake((100+10)*i, 0, 100, 100);
        [_scrollView addSubview:imageView];
        
        UILabel *imageLabel =[[UILabel alloc] initWithFrame:CGRectMake((100+10)*i, 100, 100, 30)];
        imageLabel.textAlignment =NSTextAlignmentCenter;
        imageLabel.text =[NSString stringWithFormat:@"%@",model.name];
        imageLabel.font =KAppTextFont13;
        imageLabel.backgroundColor=kWhiteColor;
        UIBezierPath *bezierPath1 = [UIBezierPath bezierPathWithRoundedRect:imageLabel.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *lay1 = [CAShapeLayer layer];
        lay1.frame = imageLabel.bounds;
        lay1.path = bezierPath1.CGPath;
        imageLabel.layer.mask = lay1;
        [_scrollView addSubview:imageLabel];
        
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor =[UIColor clearColor];
        btn.frame =CGRectMake((100+10)*i, 0, 100, 130);
        btn.tag =i;
        [btn addTarget:self action:@selector(scrollViewBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
        
    }
    
    _scrollView.contentSize =CGSizeMake(110*dataArray.count+20, 0);
    
}

- (void)moreButtonClick
{

    [[AppDelegate sharedAppDelegate] pushViewController:[StoreListVC new]];
}

- (void)scrollViewBtn:(UIButton*)btn
{
    if (btn.tag >= _dataArray.count) {
        return;
    }
    RecommendModel *model = _dataArray[btn.tag];
    FWO2OJumpModel *jump = [FWO2OJumpModel new];
    jump.type = 0;
    jump.url = model.app_url;
    jump.name = model.name;
    jump.isHideNavBar = YES;
    jump.isHideTabBar = YES;
    [FWO2OJump didSelect:jump];
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



@end
