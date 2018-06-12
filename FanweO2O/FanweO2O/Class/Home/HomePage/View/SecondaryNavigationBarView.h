//
//  SecondaryNavigationBarView.h
//  FanweO2O
//
//  Created by ycp on 17/2/4.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SecondaryNavigationBarViewDelegate <NSObject>

@required
- (void)goBack;
- (void)popNewView;
@optional
- (void)goToDiscovery;


@end

@interface SecondaryNavigationBarView : UIView
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
/* 注意:赋值的时候 先searchText赋值 再给isTitleOrSearch赋值  */
@property (nonatomic,assign)BOOL   isTitleOrSearch;//默认是显示搜索导航栏,否则就是正常的导航栏;
@property (nonatomic,copy)NSString *searchText; //必传 传什么都可以;
@property (nonatomic,assign)id<SecondaryNavigationBarViewDelegate>delegate;
+ (instancetype)EditNibFromXib;
@end
