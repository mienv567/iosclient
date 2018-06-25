//
//  MerchantSearchCollectionReusableView.m
//  TXSLiCai
//
//  Created by Owen on 16/8/1.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import "MerchantSearchCollectionReusableView.h"
@interface MerchantSearchCollectionReusableView ()<UIAlertViewDelegate>
@property (nonatomic, weak) UILabel *textLabel;
@property (nonatomic, weak) UIImageView *imageView;
@end
@implementation MerchantSearchCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        UILabel *label = [self creatLabelWithFrame:CGRectMake(10, 0, 100, 30) Text:nil fontSize:13 textColor:KAppMainTextBackColor textAlignment:0 backGrounColor: nil];
        [self addSubview:label];
        self.textLabel = label;
        
        UIButton *delectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        delectButton.frame = CGRectMake(kScreenW-16-20,(30-16)/2, 16, 16);
        [delectButton setTitleColor:KAppMainTextBackColor  forState:UIControlStateNormal];
        [delectButton setImage:[UIImage imageNamed:@"trash_icon"] forState:UIControlStateNormal];
        [delectButton.titleLabel setFont:KAppTextFont13];
        [delectButton setImage:[UIImage imageNamed:@"trash_icon"] forState:UIControlStateNormal];
        [delectButton addTarget:self action:@selector(delect) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:delectButton];
        _delectButton = delectButton;
    }
    return self;
}

- (UILabel *)creatLabelWithFrame:(CGRect)frame Text:(NSString *)text fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment backGrounColor:(UIColor *)backGrounColor
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    
    if (text != nil) {
        label.text = text;
    }
    if (fontSize !=0 ) {
        label.font = [UIFont systemFontOfSize:fontSize];
    }
    
    if (textColor != nil) {
        label.textColor = textColor;
    }
    if (textAlignment != 0) {
        label.textAlignment = textAlignment;
    }
    if (backGrounColor != nil) {
        label.backgroundColor = backGrounColor;
    }
    return label;
    
}
- (void)delect {
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定要清空历史数据?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertview show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    } else {
        if ([self.delectDelegate respondsToSelector:@selector(delectData:)]) {
            [self.delectDelegate delectData:self];
        }
    }
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}
- (void) setText:(NSString *)text {
    self.textLabel.text = text;
}
- (void) setImage:(NSString *)image {
    [self.imageView setImage:[UIImage imageNamed:image]];
}
@end
