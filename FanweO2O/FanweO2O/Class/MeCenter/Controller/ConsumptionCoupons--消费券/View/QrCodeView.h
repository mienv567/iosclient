//
//  QrCodeView.h
//  FanweO2O
//
//  Created by ycp on 17/3/6.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QrCodeViewDelegate <NSObject>

- (void)goBackToView;

@end
@interface QrCodeView : UIView
@property (weak, nonatomic) IBOutlet UIView *littleView;
@property (weak, nonatomic) IBOutlet UIImageView *xuLine;
@property (weak, nonatomic) IBOutlet UILabel *qrCodeNumber;
@property (weak, nonatomic) IBOutlet UILabel *aleatLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;
@property (weak, nonatomic) IBOutlet UIButton *backToViewController;
@property (nonatomic,assign)id<QrCodeViewDelegate>delegate;
+ (instancetype)EditNibFromXib;
@end
