//
//  PopView.h
//  FanweO2O
//
//  Created by ycp on 17/2/7.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopViewDelegate <NSObject>

- (void)back;
- (void)toRefresh;
- (void)selectButton:(NSInteger)count;
@end
@interface PopView : UIView
@property (nonatomic,strong)NSArray *imageArray;
@property (nonatomic,strong)NSArray *nameArray;
@property (nonatomic,strong)GlobalVariables *fanweApp;
@property (nonatomic,assign)NSInteger no_msg;
@property (nonatomic,assign)id<PopViewDelegate>delegate;
@property (nonatomic,strong)UIButton *closeButton;

@property UIImageView *littleIcon;
@end
