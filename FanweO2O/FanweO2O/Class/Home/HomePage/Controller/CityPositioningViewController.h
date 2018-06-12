//
//  CityPositioningViewController.h
//  FanweO2O
//
//  Created by ycp on 16/11/29.
//  Copyright © 2016年 fanwe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CityPositioningViewControllerDelegate <NSObject>

- (void)closeBtn;

@end
@interface CityPositioningViewController : UIViewController
@property (nonatomic,assign)id<CityPositioningViewControllerDelegate>delegate;
@end
