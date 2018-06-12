//
//  MerchantSearchTextFieldView.h
//  TXSLiCai
//
//  Created by Owen on 16/8/1.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MerchantSearchTextFieldViewDelegate <NSObject>

- (void)goToBack;

- (void)searchClickButton;

- (void)middleClickBtnToView;
@end
@interface MerchantSearchTextFieldView : UIView
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong)UIView *middleView;
@property (nonatomic, strong)UIButton *middleBtn;
@property (nonatomic,copy)NSString *btnTitle;
@property (nonatomic,strong)UIButton *goBackButton;
@property (nonatomic,assign)BOOL isGoBackHidden;
@property (nonatomic,assign)id<MerchantSearchTextFieldViewDelegate>delegate;
- (void)setIsGoBackHidden:(BOOL)isGoBackHidden;
@end
