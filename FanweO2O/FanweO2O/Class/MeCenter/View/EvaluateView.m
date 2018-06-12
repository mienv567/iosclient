//
//  EvaluateView.m
//  FanweO2O
//
//  Created by hym on 2017/3/13.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "EvaluateView.h"

#import "EvaluateModel.h"

@interface EvaluateView()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
@property (weak, nonatomic) IBOutlet UILabel *lbPlaceholder;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *lbSart;

@end

@implementation EvaluateView

- (void)awakeFromNib {
    [self.line setBackgroundColor:kLineColor];
    
    self.lbPlaceholder.textColor = RGB(153, 153, 153);
    self.textView.textColor = kAppFontColorComblack;
    self.lbSart.textColor = kAppFontColorComblack;
    self.textView.delegate = self;
    
    CALayer *layer= [self.imageIcon layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    [layer setCornerRadius:2];
    //设置边框线的宽
    [layer setBorderWidth:1];
    //设置边框线的颜色
    [layer setBorderColor:[kLineColor CGColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object:nil];
}

+ (instancetype )appView {
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSArray *objs = [bundle loadNibNamed:@"EvaluateView" owner:nil options:nil];
    
    return [objs firstObject];
}

- (void)setModel:(EvaluateModel *)model {
    
    _model = model;
    
    [self.imageIcon sd_setImageWithURL:[NSURL URLWithString:model.deal_icon] placeholderImage:kDefaultCoverIcon];
}

- (void)textViewDidChange:(NSNotification *)notification
{
    self.lbPlaceholder.hidden = (self.textView.text.length > 0);
    
  
}

- (IBAction)onClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag - 10001;
    for (int i = 0; i < 5; i ++) {
        UIButton *btton = [self viewWithTag:10001 + i];
        if (i <= tag) {
            
            [btton setImage:[UIImage imageNamed:@"o2o_eva_star_h_icon"] forState:UIControlStateNormal];
            
        }else {
            [btton setImage:[UIImage imageNamed:@"o2o_eva_star_icon"] forState:UIControlStateNormal];
        }
    }
    
    self.model.sartRank = tag + 1;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.model.strContent = textView.text;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
