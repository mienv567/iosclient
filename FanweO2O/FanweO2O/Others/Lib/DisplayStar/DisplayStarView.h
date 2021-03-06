//
//  DisplayStarView.h
//  阿达21321
//
//  Created by ycp on 17/2/6.
//  Copyright © 2017年 fanwe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisplayStarView : UIView
{
    CGFloat _starSize;        /* 根据字体大小来确定星星的大小 */
    NSInteger _maxStar;      /* 总共的长度 */
    CGFloat _showStar;    //需要显示的星星的长度
    UIColor *_emptyColor;   //未点亮时候的颜色
    UIColor *_fullColor;    //点亮的星星的颜色
}
@property (nonatomic, assign) CGFloat starSize;
@property (nonatomic, assign) NSInteger maxStar;
@property (nonatomic, assign) CGFloat showStar;
@property (nonatomic, retain) UIColor *emptyColor;
@property (nonatomic, retain) UIColor *fullColor;
@end
