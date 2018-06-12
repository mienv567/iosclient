//
//  UITableView+CNHEmptyDataSet.h
//  FanweO2O
//
//  Created by hym on 2017/1/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (CNHEmptyDataSet)

- (void) tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount;


@end
