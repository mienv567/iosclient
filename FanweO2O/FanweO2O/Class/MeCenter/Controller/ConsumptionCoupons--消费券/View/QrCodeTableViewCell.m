//
//  QrCodeTableViewCell.m
//  FanweO2O
//
//  Created by ycp on 17/3/3.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "QrCodeTableViewCell.h"
@implementation QrCodeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.line.backgroundColor =[UIColor colorWithRed:0.953 green:0.965 blue:0.961 alpha:1.00];
    //红色
    _color1 =[UIColor colorWithRed:1.000 green:0.133 blue:0.267 alpha:1.00];
    //灰
    _color2 =[UIColor colorWithRed:0.600 green:0.600 blue:0.600 alpha:1.00];
}
- (void)setModel:(CouponCount *)model
{
    
    if (model ==nil) {
        return;
    }else{
        _model =model;
        if ([model.status intValue] ==1) {
            //富文本
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"券码: %@",model.password] ];
            [attributedStr addAttribute:NSForegroundColorAttributeName
                                  value:_color1
                                  range:NSMakeRange(3, attributedStr.length-3)];
            self.codeNumberLabel.attributedText =attributedStr;
          
         
        }else
        {
          
            NSMutableAttributedString *attributedStr =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"券码: %@(%@)",model.password,model.info] ];
            [attributedStr addAttribute:NSForegroundColorAttributeName
                                  value:_color2
                                  range:NSMakeRange(0, attributedStr.length)];
            self.codeNumberLabel.attributedText =attributedStr;
            
        }
    }
}
- (void)setPModel:(PreferentialModel *)pModel
{
   
    if (pModel ==nil) {
        return;
    }else{
        _pModel =pModel;
        if ([pModel.status intValue] ==1) {
            //富文本
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"券码: %@",pModel.youhui_sn] ];
            [attributedStr addAttribute:NSForegroundColorAttributeName
                                  value:_color1
                                  range:NSMakeRange(3, attributedStr.length-3)];
            self.codeNumberLabel.attributedText =attributedStr;
        
            
        }else if([pModel.status intValue] ==2)
        {
            
            NSMutableAttributedString *attributedStr =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"券码: %@(已使用)",pModel.youhui_sn] ];
            [attributedStr addAttribute:NSForegroundColorAttributeName
                                  value:_color2
                                  range:NSMakeRange(0, attributedStr.length)];
            self.codeNumberLabel.attributedText =attributedStr;
       
        }else{
            NSMutableAttributedString *attributedStr =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"券码: %@(已过期)",pModel.youhui_sn] ];
            [attributedStr addAttribute:NSForegroundColorAttributeName
                                  value:_color2
                                  range:NSMakeRange(0, attributedStr.length)];
            self.codeNumberLabel.attributedText =attributedStr;
      
        }
    }
}
- (void)setAModel:(ActivityModel *)aModel
{
    if (aModel ==nil) {
        return;
    }else{
        _aModel =aModel;
        if ([aModel.status intValue] ==1) {
            //富文本
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"券码: %@",aModel.sn] ];
            [attributedStr addAttribute:NSForegroundColorAttributeName
                                  value:_color1
                                  range:NSMakeRange(3, attributedStr.length-3)];
            self.codeNumberLabel.attributedText =attributedStr;
    
            
        }else
        {
            
            NSMutableAttributedString *attributedStr =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"券码: %@(%@)",aModel.sn,aModel.info] ];
            [attributedStr addAttribute:NSForegroundColorAttributeName
                                  value:_color2
                                  range:NSMakeRange(0, attributedStr.length)];
            self.codeNumberLabel.attributedText =attributedStr;
     
        }
    }
}
- (void)setPGmodel:(PickUpGoodsModel *)PGmodel
{
    if (PGmodel ==nil) {
        return;
    }else{
        _PGmodel =PGmodel;
        if ([PGmodel.status intValue] ==1) {
            //富文本
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"券码: %@",PGmodel.sn] ];
            [attributedStr addAttribute:NSForegroundColorAttributeName
                                  value:_color1
                                  range:NSMakeRange(3, attributedStr.length-3)];
            self.codeNumberLabel.attributedText =attributedStr;

            
        }else
        {
            
            NSMutableAttributedString *attributedStr =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"券码: %@(%@)",PGmodel.sn,PGmodel.info] ];
            [attributedStr addAttribute:NSForegroundColorAttributeName
                                  value:_color2
                                  range:NSMakeRange(0, attributedStr.length)];
            self.codeNumberLabel.attributedText =attributedStr;

        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
