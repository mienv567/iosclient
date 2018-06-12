//
//  XDJProgressHUD.h
//  HaoAiDai
//
//  Created by Crius on 15/8/25.
//  Copyright (c) 2015年 Crius. All rights reserved.
//

#import "MBProgressHUD.h"

#define LENGTH_SHORT (2)
#define LENGTH_LONG  (3.5)

CG_EXTERN  MBProgressHUD * _showTipsView(NSString* text, float duration_time, UIView* view);
CG_EXTERN  MBProgressHUD * _showResultView(NSString* text, float duration_time, UIView* view, UIImage *image);
CG_EXTERN  MBProgressHUD * _showLongTipsView(NSString* text, float duration_time, UIView* view);

#define ShowTipsView(text, duration_time, view) _showTipsView(text, duration_time, view)
#define ShowLongTipsView(text, duration_time, view) _showLongTipsView(text, duration_time, view)

#define ShowLongTips(text)                          ShowLongTipsView(text, LENGTH_SHORT, self.view)
#define ShowTips(text)                          ShowTipsView(text, LENGTH_SHORT, self.view)
#define ShowTipsWithDuration(text, duration)    ShowTipsView(text, duration, self.view)
#define ShowTipsOnView(text,view)               ShowTipsView(text, LENGTH_SHORT, view)

#define HideTips()                      [MBProgressHUD hideHUDForView:self.view animated:NO];

#define HideIndicatorInView(view)      [MBProgressHUD hideHUDForView:view animated:NO];
#define ShowIndicatorInView(view)      do{ HideIndicatorInView(view);\
/*MBProgressHUD *hud = */[XDJProgressHUD showHUDAddedTo:view animated:YES]; /*hud.labelText = @"正在加载";*/}while(0)

#define ShowIndicatorTextInView(view,text) do{ HideIndicatorInView(view);\
MBProgressHUD *hud = [XDJProgressHUD showHUDAddedTo:view animated:YES]; hud.labelText = text;\
hud.userInteractionEnabled = NO;\
}while(0)
//ADD BY CSH
#define ShowIndicatorInViewEnabled(view,text) do{ HideIndicatorInView(view);\
MBProgressHUD *hud = [XDJProgressHUD showHUDAddedTo:view animated:YES]; hud.labelText = text;\
hud.userInteractionEnabled = YES;\
}while(0)

//
#define ShowIndicatorText(text)         ShowIndicatorTextInView(self.view,text)
#define ShowIndicator()                 ShowIndicatorInView(self.view);

#define ShowSuccessView(text, duration_time, view)  _showResultView(text, duration_time, view, [UIImage imageNamed:@"Checkmark"])
#define ShowSuccess(text)                          ShowSuccessView(text, LENGTH_SHORT, self.view)

#define ShowError(text)                 do{ HideIndicator_InView(self.view); \
[MBProgressHUD showError:text toView:self.view];}while(0)
#define HideIndicator()                 HideIndicatorInView(self.view)

@interface XDJProgressHUD : MBProgressHUD

@end

@interface XDJRoundProgressHUD : MBRoundProgressView

@end

@interface XDJBarProgressHUD : MBBarProgressView

@end



