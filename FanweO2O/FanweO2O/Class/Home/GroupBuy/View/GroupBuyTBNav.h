//
//  GroupBuyTBNav.h
//  FanweO2O
//
//  Created by ycp on 17/6/8.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GroupBuyTBNavDelegate <NSObject>

- (void)searchBtn;
- (void)contenBtn;
@end

@interface GroupBuyTBNav : UIView
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (nonatomic, copy)NSString *titleText;
@property (weak, nonatomic)id<GroupBuyTBNavDelegate>delegate;
+(instancetype)EditNibFromXib;
@end
