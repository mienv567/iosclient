//
//  SecondaryNavigationBarView.m
//  FanweO2O
//
//  Created by ycp on 17/2/4.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SecondaryNavigationBarView.h"

@implementation SecondaryNavigationBarView
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.searchButton.layer.masksToBounds =YES;
    self.searchButton.layer.cornerRadius =3;
   
    [self.searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    self.searchButton.titleLabel.font =kAppTextFont12;
    [self.searchButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.searchButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [self.searchButton setTitleColor:KAppMainTextBackColor forState:UIControlStateNormal];
    self.searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.searchButton.backgroundColor =[UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.00];

}
- (void)setIsTitleOrSearch:(BOOL)isTitleOrSearch
{
    if (isTitleOrSearch ==NO) {
        if (_searchText ==nil) {
            [self.searchButton setTitle:@"搜索商品或店铺" forState:UIControlStateNormal];
        }else
        {
            [self.searchButton setTitle:_searchText forState:UIControlStateNormal];
        }
        self.titleName.hidden=YES;
    }else
    {
        self.titleName.text =_searchText;
        self.searchButton.hidden =YES;
    }
}
- (void)setSearchText:(NSString *)searchText
{
    _searchText =searchText;
}

+ (instancetype)EditNibFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}
- (IBAction)leftBackButton:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(goBack)]) {
        [_delegate goBack];
    }
}
- (IBAction)searchToButton:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(goToDiscovery)]) {
        [_delegate goToDiscovery];
    }
}
- (IBAction)newViewButton:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(popNewView)]) {
        [_delegate popNewView];
    }
}

@end
