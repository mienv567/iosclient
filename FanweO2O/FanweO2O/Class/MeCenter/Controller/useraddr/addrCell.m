//
//  addrCell.m
//  FanweO2O
//
//  Created by zzl on 2017/3/1.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "addrCell.h"

UIColor* g_defcolor = nil;
@implementation addrCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if( g_defcolor == nil )
        g_defcolor = [self.mdefaultbt titleColorForState:UIControlStateNormal];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)defaultClicked:(id)sender {
    
    if( self.mCellDelegate &&
    [self.mCellDelegate respondsToSelector:@selector(addrCellClicked:clicked:)] )
    {
        [self.mCellDelegate addrCellClicked:self.mDataRef clicked:1];
    }
}

- (IBAction)editCliecked:(id)sender {
    if( self.mCellDelegate &&
       [self.mCellDelegate respondsToSelector:@selector(addrCellClicked:clicked:)] )
    {
        [self.mCellDelegate addrCellClicked:self.mDataRef clicked:2];
    }
    
}
- (IBAction)delClicked:(id)sender {
    if( self.mCellDelegate &&
       [self.mCellDelegate respondsToSelector:@selector(addrCellClicked:clicked:)] )
    {
        [self.mCellDelegate addrCellClicked:self.mDataRef clicked:3];
    }
}


@end
