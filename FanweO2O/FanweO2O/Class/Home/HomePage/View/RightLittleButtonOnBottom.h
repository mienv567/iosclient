//
//  RightLittleButtonOnBottom.h
//  FanweO2O
//
//  Created by ycp on 16/12/2.
//  Copyright © 2016年 fanwe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RightLittleButtonOnBottomDelegate <NSObject>

- (void)backToTop;

@end
@interface RightLittleButtonOnBottom : UIButton
@property (nonatomic,assign)id<RightLittleButtonOnBottomDelegate>delegate;
@property (nonatomic,assign)NSInteger kind;    //0为有tabbar 1为没有tabbar
- (void)setKind:(NSInteger)kind;
@end
