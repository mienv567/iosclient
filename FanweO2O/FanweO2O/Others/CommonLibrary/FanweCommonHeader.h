//
//  FanweCommonHeader.h
//  FanweApp
//
//  Created by mac on 16/8/3.
//  Copyright © 2016年 xfg. All rights reserved.
//  综合宏

#ifndef FanweCommonHeader_h
#define FanweCommonHeader_h

// 以下为大众宏（可能整个app都有用到）

typedef void (^FWVoidBlock)();
typedef void (^FWErrorBlock)(int errId, NSString *errMsg);

#define kDefaultMargin              10   // 边距
//#define kLeftMargin                 10   // 边距
#define kMyMargin1                  8   // 边距
#define kBorderWidth                1   // 边框宽度
#define myCornerRadius              4   // 圆角大小
#define myLineHight1                1   // 分割线高度
#define myLineHight2                2   //个人中心横分割线2
#define myLineHight3                3   //个人中心竖直分割线
#define myDotelineHight             1   // 虚线分割线高度

#define kDefaultUserIcon            [UIImage imageNamed:@"ic_default_head"]     // 默认头像
#define kDefaultCoverIcon           [UIImage imageNamed:@"no_pic"]              // 还未加载完成时显示的默认图片
#define kDefaultCoverColor          RGB(238, 238, 238)                          // 还未加载完成时显示的默认图片


// 以下为小众宏（可能单纯某个类用到）

#define kAdvsTimeInterval           4   // 广告位间隔轮播时间
#define kRefreshWithNewaTimeInterval 20 //主页热门定时刷新的时间
#define kAdvsPageWidth              4   // 广告轮播组件的那个引导点的宽度

#define DEFAULT_ICON        [UIImage imageNamed:@"no_pic"]

#define kMyBtnWidth1                MyBtnWidth1()  // 按钮宽度
static __inline__ CGFloat MyBtnWidth1()
{
    if (([UIScreen mainScreen].bounds.size.width >= 375.0f)) {
        return 32;
    }else {
        return 30;
    }
}


//个人中心设置按钮高度
#define kCenterBtnHeight        CenterBtnHeight()
static __inline__ CGFloat CenterBtnHeight()
{
    if (([UIScreen mainScreen].bounds.size.height==568.0f)) {
        return kScreenH * 0.088;
    }else if ([UIScreen mainScreen].bounds.size.height==667.0f){
        return kScreenH * 0.0803;
    }else if ([UIScreen mainScreen].bounds.size.height==736.0f){
        return kScreenH * 0.0801;
    }else{
        return kScreenH * 0.088;
    }
    
}

//个人中心(观众)scrollView的长度
#define kCenterScrollHeight1     CenterScrollHeight1()
static inline CGFloat CenterScrollHeight1()
{
    if (([UIScreen mainScreen].bounds.size.height==568.0f)) {
        return kScreenH * 1.35;
    }else if ([UIScreen mainScreen].bounds.size.height==667.0f){
        return kScreenH * 1.3;
    }else if ([UIScreen mainScreen].bounds.size.height==736.0f){
        return kScreenH * 1.28;
    }else{
        return kScreenH * 1.40;
    }

}

//个人中心(主播)scrollView的长度
#define kCenterScrollHeight2     CenterScrollHeight2()
static inline CGFloat CenterScrollHeight2()
{
    if (([UIScreen mainScreen].bounds.size.height==568.0f)) {
        return kScreenH * 1.67;
    }else if ([UIScreen mainScreen].bounds.size.height==667.0f){
        return kScreenH * 1.62;
    }else if ([UIScreen mainScreen].bounds.size.height==736.0f){
        return kScreenH * 1.6;
    }else{
        return kScreenH * 1.72;
    }
    
}

//个人中心(认证观众)scrollView的长度
#define kCenterScrollHeight3     CenterScrollHeight3()
static inline CGFloat CenterScrollHeight3()
{
    if (([UIScreen mainScreen].bounds.size.height==568.0f)) {
        return kScreenH * 1.38;
    }else if ([UIScreen mainScreen].bounds.size.height==667.0f){
        return kScreenH * 1.33;
    }else if ([UIScreen mainScreen].bounds.size.height==736.0f){
        return kScreenH * 1.31;
    }else{
        return kScreenH * 1.43;
    }
    
}

//个人中心(认证主播)scrollView的长度
#define kCenterScrollHeight4     CenterScrollHeight4()
static inline CGFloat CenterScrollHeight4()
{
    if  ([UIScreen mainScreen].bounds.size.height==568.0f){
        return kScreenH * 1.7;
    }else if ([UIScreen mainScreen].bounds.size.height==667.0f){
        return kScreenH * 1.65;
    }else if ([UIScreen mainScreen].bounds.size.height==736.0f){
        return kScreenH * 1.63;
    }else{
        return kScreenH * 1.75;
    }
    
}

#define kIsTCShowSupportIMCustom    1   // 是否支持IM自定义



#endif /* FanweCommonHeader_h */
