//
//  UITableView+CNHEmptyDataSet.m
//  FanweO2O
//
//  Created by hym on 2017/1/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "UITableView+CNHEmptyDataSet.h"

@implementation UITableView (CNHEmptyDataSet)

- (void) tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount {
    
    if (rowCount == 0) {
        // Display a message when the table is empty
        UIView *emptyView = [[UIView alloc]initWithFrame:self.frame];
        CGFloat imgW = 150.0f;
        CGFloat imgH = 91.0f;
        CGFloat centerX = self.frame.size.width * 0.5;
        CGFloat centerY = self.frame.size.height * 0.4;
        UIImageView *emptyImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(centerX-imgW*0.5,centerY-imgH, imgW, imgH)];
        emptyImageView.image = [UIImage imageNamed:@"o2o_no_data_icon"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(emptyImageView.frame)+20, self.frame.size.width, 15)];
        label.text = message;
        label.textColor = kMainColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        
        
        [emptyView addSubview:emptyImageView];
        [emptyView addSubview:label];
        
        
        self.backgroundView = emptyView;
        self.backgroundColor = kGaryGroundColor;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    } else {
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }

}

@end
