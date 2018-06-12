//
//  RefundApplicationHeaderView.h
//  FanweO2O
//
//  Created by ycp on 17/3/14.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefundApplicationHeaderView : UIView<UITextViewDelegate>
@property (nonatomic,strong)UILabel *placeHolderText;
@property(nonatomic,strong)UITextView *textView;
@end
