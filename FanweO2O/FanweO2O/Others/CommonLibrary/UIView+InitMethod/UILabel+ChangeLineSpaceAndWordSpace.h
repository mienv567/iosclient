//
//  UILabel+ChangeLineSpaceAndWordSpace.h
//  FanweO2O
//
//  Created by hym on 2017/5/4.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ChangeLineSpaceAndWordSpace)

/**
 *  改变行间距
 */
- (void)changeLineSpaceForWithSpace:(float)space;

/**
 *  改变字间距
 */
- (void)changeWordSpaceForWithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
- (void)changeSpaceForwithLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

@end
