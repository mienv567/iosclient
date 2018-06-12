//
//  ButtonCustom.h
//  FanweO2O
//
//  Created by ycp on 17/1/6.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ButtonCustomDelegate <NSObject>

- (void)buttonCustonToNext:(NSInteger )number;

@end
@interface ButtonCustom : UIView

@property (nonatomic,assign)NSInteger Tag;
@property (nonatomic,assign)id<ButtonCustomDelegate>delegate;
- (instancetype)initWithFrame:(CGRect)frame imageIcon:(UIImage *)imageIcon titleText:(NSString *)titleText angelNumber:(NSString *)number ;


@end
