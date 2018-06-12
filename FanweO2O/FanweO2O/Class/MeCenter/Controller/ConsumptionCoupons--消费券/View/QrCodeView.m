//
//  QrCodeView.m
//  FanweO2O
//
//  Created by ycp on 17/3/6.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "QrCodeView.h"

@implementation QrCodeView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor =[UIColor colorWithWhite:0 alpha:0.8];
    self.qrCodeNumber.textColor =KAppMainTextBackColor;
    self.aleatLabel.textColor =KAppMainTextBackColor;
    self.littleView.layer.masksToBounds =YES;
    self.littleView.layer.cornerRadius =myCornerRadius;
//    self.littleView.hidden =YES;
    self.xuLine.frame =CGRectMake(0, 0, kScreenW, 2);
    self.xuLine.image =[self drawLineByImageView:_xuLine];
    
}
+ (instancetype)EditNibFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}
- (IBAction)clickBtn:(id)sender {
    if (_delegate  && [_delegate respondsToSelector:@selector(goBackToView)]) {
        [_delegate goBackToView];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    point = [_littleView.layer convertPoint:point fromLayer:self.layer];
    if ([_littleView.layer containsPoint:point]){
        return;
    }else
    {
        if (_delegate  && [_delegate respondsToSelector:@selector(goBackToView)]) {
            [_delegate goBackToView];
        }
    }
}
/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
//- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
//{
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    [shapeLayer setBounds:lineView.bounds];
//    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
//    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
//    //  设置虚线颜色为blackColor
//    [shapeLayer setStrokeColor:lineColor.CGColor];
//    //  设置虚线宽度
//    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
//    [shapeLayer setLineJoin:kCALineJoinRound];
//    //  设置线宽，线间距
//    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
//    //  设置路径
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path, NULL, 0, 0);
//    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
//    [shapeLayer setPath:path];
//    CGPathRelease(path);
//    //  把绘制好的虚线添加上来
//    [lineView.layer addSublayer:shapeLayer];
//}

- (UIImage *)drawLineByImageView:(UIImageView *)imageView{
    UIGraphicsBeginImageContext(imageView.frame.size); //开始画线 划线的frame
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    //设置线条终点形状
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    // 5是每个虚线的长度 1是高度 请使用double类型 如果报错 改为CGFloat
    CGFloat lengths[] = {10,2};
    CGContextRef line = UIGraphicsGetCurrentContext();
    // 设置颜色
    CGContextSetStrokeColorWithColor(line, [UIColor colorWithRed:0.812 green:0.820 blue:0.835 alpha:1.00].CGColor);
    CGContextSetLineDash(line, 0, lengths, 2);//画虚线
    CGContextMoveToPoint(line, 0.0, 2.0); //开始画线
    CGContextAddLineToPoint(line, kScreenW - 10, 2.0);
    
    CGContextStrokePath(line);
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
}
@end
