//
//  PopWhiteView.h
//  FanweO2O
//
//  Created by ycp on 17/2/8.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopWhiteViewDelegate <NSObject>

- (void)refresh;

@end
@interface PopWhiteView : UIView
@property (nonatomic,assign)id<PopWhiteViewDelegate>delegate;
@end
