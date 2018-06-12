//
//  MerchantSearchCollCell.m
//  TXSLiCai
//
//  Created by Owen on 16/8/1.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import "MerchantSearchCollCell.h"

@implementation MerchantSearchCollCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.contentButton = [self creatButtonWithFrame:CGRectZero title:nil titleFontSize:12 titleColor:KAppMainTextBackColor image:nil backGroundColor:kGaryGroundColor cornerRadius:0];
        
        [self.contentView addSubview:_contentButton];
        self.contentButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//        self.contentButton.frame = self.bounds;
        [self.contentButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)layoutSubviews {
    self.contentButton.frame = self.bounds;
}
- (void)buttonAction:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(selectButtonClick:)]) {
        [self.delegate selectButtonClick:self];
    }
}
+ (CGSize)getSizeWithText:(NSString *)text {
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize size = [text boundingRectWithSize:CGSizeMake(kScreenW - 20, 24) options: NSStringDrawingUsesLineFragmentOrigin   attributes:@{NSFontAttributeName:KAppTextFont13,NSParagraphStyleAttributeName:style} context:nil].size;
//    NSString *stringFor18 = @"你好你好你好你好你好你好你好你好你好";
//    CGSize sizeFor18 = [stringFor18 boundingRectWithSize:CGSizeMake(kScreenWidth - 40, 24) options: NSStringDrawingUsesLineFragmentOrigin   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12*kScreenHeight/736],NSParagraphStyleAttributeName:style} context:nil].size;
//    if (size.width > sizeFor18.width) {
//        size = sizeFor18;
//    }
//    return CGSizeMake(size.width+20*kScreenHeight/736, 30*kScreenHeight/736);
//    if (size.width >kScreenW) {
//        size =CGSizeMake(kScreenW-40, 30);
//    }
    return CGSizeMake(size.width+10, 30);
}
- (UIButton *)creatButtonWithFrame:(CGRect)frame title:(NSString *)title titleFontSize:(CGFloat)titleFontSize titleColor:(UIColor *)titleColor image:(UIImage *)image backGroundColor:(UIColor *)backGroundColor cornerRadius:(CGFloat)cornerRadius
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (image != nil) {
        [button setImage:image forState:UIControlStateNormal];
    }
    if (title != nil) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (titleColor != nil) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    
    if (cornerRadius != 0) {
        [button.layer setCornerRadius:cornerRadius];
        button.layer.masksToBounds = YES;
    }
    if (backGroundColor != nil) {
        button.backgroundColor = backGroundColor;
    }
    if (titleFontSize != 0) {
        button.titleLabel.font = [UIFont systemFontOfSize:titleFontSize];
    }
    
    button.frame = frame;
    return button;
}

@end
