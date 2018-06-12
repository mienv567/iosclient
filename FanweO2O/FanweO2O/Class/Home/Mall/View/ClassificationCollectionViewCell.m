//
//  ClassificationCollectionViewCell.m
//  FanweO2O
//
//  Created by ycp on 16/12/12.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ClassificationCollectionViewCell.h"

@implementation ClassificationCollectionViewCell


-(id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        NSArray *arrCell = [[NSBundle mainBundle]loadNibNamed:@"ClassificationCollectionViewCell" owner:self options:nil];
        if (arrCell.count<1)
        {
            return nil;
        }
        if (![[arrCell objectAtIndex:0]isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        self = [arrCell objectAtIndex:0];
    }
    
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
