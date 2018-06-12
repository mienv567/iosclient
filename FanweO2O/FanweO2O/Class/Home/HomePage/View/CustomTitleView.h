//
//  CustomTitleView.h
//  FanweO2O
//
//  Created by ycp on 16/12/12.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomTitleViewDelegate <NSObject>

- (void)popBack;

- (void)rightBtn;
@end
@interface CustomTitleView : UIView
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (nonatomic,assign)id<CustomTitleViewDelegate>delegate;
+ (instancetype)EditNibFromXib;
@end
