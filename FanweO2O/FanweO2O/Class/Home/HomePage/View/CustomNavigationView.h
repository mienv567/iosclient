//
//  CustomNavigationView.h
//  FanweO2O
//
//  Created by ycp on 16/11/29.
//  Copyright © 2016年 fanwe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "O2OHomeMainModel.h"
#import "GlobalVariables.h"
@protocol CustomNavigationViewDelegate <NSObject>
// 搜索界面
- (void)goToDiscoveryViewController;

- (void)customLeftButton;

- (void)loginView:(BOOL)islogin;

@end
@interface CustomNavigationView : UIView
{
    GlobalVariables *_fanweApp;
}
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageDown;
@property (weak, nonatomic) IBOutlet UIImageView *messageImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageIcon;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (nonatomic,assign)BOOL isLogin;
@property (nonatomic,strong)O2OHomeMainModel *model;

@property (nonatomic,assign)id<CustomNavigationViewDelegate>delegate;

+ (instancetype)EditNibFromXib;
@end
