//
//  RecommendTableViewCell.h
//  FanweO2O
//
//  Created by ycp on 16/12/7.
//  Copyright © 2016年 fanwe. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FW_RECOMMEND_HIGHT  190

@interface RecommendTableViewCell : UITableViewCell

+ (RecommendTableViewCell *)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end
