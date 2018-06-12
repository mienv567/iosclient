//
//  MallIndexsTBCell.m
//  FanweO2O
//  菜单列表cell
//  Created by hym on 2016/12/9.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "MallIndexsTBCell.h"
#import "MallIndexModel.h"
#import "ButtonIcon.h"
#import "MyTool.h"
#import "UIView+BlocksKit.h"
#import "FWO2OJumpModel.h"
#import "FWO2OJump.h"
static NSString *cellIndent =  @"MallIndexsTBCell";

@interface MallIndexsTBCell()
@property (nonatomic, strong) UIScrollView *scrollView;


@end



@implementation MallIndexsTBCell

+ (MallIndexsTBCell *)cellWithTableView:(UITableView *)tableView {
    MallIndexsTBCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndent];
    
    if (!cell) {
        cell = [[MallIndexsTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndent];
        [cell doInit];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //[cell.contentView setBackgroundColor:kBackGroundColor];
    }
    return cell;
}

- (void)doInit {
    self.indexsArray = [NSMutableArray new];
    
    _scrollView = [UIScrollView new];
    
    _scrollView.scrollEnabled = YES;
    _scrollView.pagingEnabled = YES;
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.contentView addSubview:_scrollView];

    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.height.mas_offset(0);
        make.top.equalTo(self.contentView.mas_top).with.offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        
    }];
    
}

- (void)setIndexsArray:(NSMutableArray *)indexsArray {
    
    _indexsArray = indexsArray;
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat width = SCREEN_WIDTH/5.0;
    CGFloat hight = 75;
    int k = 0;
    if (indexsArray.count == 0) {

        return;
    }
    
    CGFloat allHight = 75;
    if (indexsArray.count > 5 ) {
        [_scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 2*hight));
            make.left.equalTo(self.contentView.mas_left).with.offset(0);
            make.top.equalTo(self.contentView.mas_top).with.offset(0);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
        }];
        allHight = 2*hight;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH *ceil(indexsArray.count/10.0) , 2*hight);
    } else {
        [_scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, hight));
            make.left.equalTo(self.contentView.mas_left).with.offset(0);
            make.top.equalTo(self.contentView.mas_top).with.offset(0);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
        }];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH *ceil(indexsArray.count/10.0),hight);
    }
    
    for (int z = 0; z < ceil(indexsArray.count / 10.0); z++) {
        UIView *views = [UIView new];
        [_scrollView addSubview:views];
        
        [views mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_scrollView.mas_left).with.offset(SCREEN_WIDTH*z);
            make.top.equalTo(_scrollView.mas_top).with.offset(0);
            //make.bottom.equalTo(_scrollView.mas_bottom).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, allHight));
            //make.width.mas_offset(SCREEN_WIDTH);
        }];
        
        NSInteger g = indexsArray.count - z*10;
        NSInteger section = 0;
        
        if (g >= 10) {
            section = 2;
        }else if(0<g && g<=5){
            section = 1;
        }else if(5<g && g<10){
           section = 2; 
        }else {
            break;
        }
        
        for (int j = 0 ; j <  section ; j++) {
            for (int i = 0; i < 5; i++) {
                
                MallIndexModel *mode = indexsArray[k];
                
                ButtonIcon *btn = [ButtonIcon new];
                btn.tag = k;
                [btn setTitle:mode.name forState:UIControlStateNormal];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                [btn setTitleColor:kAppFontColorComblack forState:UIControlStateNormal];
    
                //[btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
                
               
                __block MallIndexsTBCell *weakSelf = self;
                [btn bk_whenTouches:1 tapped:1 handler:^{
                    
                    [weakSelf onClick:btn];
    
                }];
                
                [btn sd_setImageWithURL:[NSURL URLWithString:mode.img] forState:UIControlStateNormal placeholderImage:DEFAULT_ICON];
                //[btn sd_setImageWithURL:[NSURL URLWithString:mode.img] forState:UIControlStateNormal];
                [views addSubview:btn];
                
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(views.mas_left).with.offset(width*i);
                    make.top.equalTo(views.mas_top).with.offset(hight*j);
                    make.size.mas_equalTo(CGSizeMake(width, hight));
                }];
                 
                k ++;
                
                if (k >= indexsArray.count) {
                    break;
                }
            }
     
        }
     
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
}


- (void)onClick:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    MallIndexModel *model = _indexsArray[btn.tag];

    
    /*
    FWO2OJumpModel *jump = [FWO2OJumpModel new];
    
    NSMutableString *muString = [NSMutableString new];
    
    for (NSString *key in model.data.allKeys) {
        NSString *value = [model.data stringForKey:key];
        if (value.length > 0) {
            [muString appendFormat:@"&%@=%@",key,[model.data stringForKey:key]];
        }
    }
    
    if ([model.ctl isEqualToString:@"search"]) {
        
        
        
        [[AppDelegate sharedAppDelegate] topViewController].tabBarController.selectedIndex = 1;
        
        return;
        
    }else if ([model.ctl isEqualToString:@"deal"]) {
        //三期
        jump.isHideTabBar = YES;
        jump.isHideNavBar = YES;
        jump.url = [NSString stringWithFormat:@"%@?ctl=%@%@",API_LOTTERYOUT_URL,model.ctl,muString];
        
    }else if ([model.ctl isEqualToString:@"index"]) {
        
        return;
        
    }else if (model.type != 0){
        
        jump.type = model.type;
        
        if ( model.data.allKeys.count > 0) {
            jump.data_id = [model.data.allValues firstObject];
        }
        
    }else {
        
        jump.isHideTabBar = YES;
        jump.isHideNavBar = YES;
        jump.url = [NSString stringWithFormat:@"%@?ctl=%@%@",API_LOTTERYOUT_URL,model.ctl,muString];
    }
    
    
    [FWO2OJump didSelect:jump];

    */
    if ([self.delegate respondsToSelector:@selector(goNextVC:)]) {
        [self.delegate goNextVC:model];
    }
}

@end
