//
//  RefundApplicationHeaderView.m
//  FanweO2O
//
//  Created by ycp on 17/3/14.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "RefundApplicationHeaderView.h"

@implementation RefundApplicationHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor colorWithRed:0.953 green:0.965 blue:0.961 alpha:1.00];
        [self initialize];
    }
    return self;
}
- (void)initialize
{
    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(10, 10, kScreenW-20, 130)];
    view.backgroundColor  =[UIColor whiteColor];
    [self addSubview:view];
    UILabel *redLabel =[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    redLabel.font =KAppTextFont15;
    redLabel.backgroundColor =[UIColor clearColor];
    redLabel.text =@"退款说明";
    redLabel.textAlignment =NSTextAlignmentLeft;
    [view addSubview:redLabel];
    
    self.textView =[ [UITextView alloc]initWithFrame:CGRectMake(5,CGRectGetMaxY(redLabel.frame),kScreenW-40,130-CGRectGetMaxY(redLabel.frame))];
    self.textView.delegate = self;
    self.textView.font =kAppTextFont14;
    [view addSubview:self.textView];
    
    self.placeHolderText =[[UILabel alloc] initWithFrame:CGRectMake(5, 6, 200, 20)];
    self.placeHolderText.text =@"请输入您的退款原因";
    self.placeHolderText.textColor =[UIColor colorWithRed:0.600 green:0.600 blue:0.600 alpha:1.00];
    self.placeHolderText.font =kAppTextFont14;
    self.placeHolderText.backgroundColor =[UIColor clearColor];
    [self.textView addSubview:self.placeHolderText];
}
- (void)textViewDidChange:(UITextView *)textView
{
      if([textView.text length] == 0){
          self.placeHolderText.text =@"请输入您的退款原因";

      }else
      {
          self.placeHolderText.text =@"";

      }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){     //这里"\n"对应的是键盘的 return 回收键盘之用
            
        [textView resignFirstResponder];
            
        return YES;
    }
    if (range.location >= 140)
        
    {
        return NO;
        
    }else
        
    {
        
        return YES;
        
    }


}

@end
