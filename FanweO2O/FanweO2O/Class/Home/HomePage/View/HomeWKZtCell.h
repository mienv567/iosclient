//
//  HomeWKZtCell.h
//  FanweO2O
//
//  Created by hym on 2016/12/30.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HomeWKZtCellDelegate <NSObject>

@required
- (void)refreshTableView:(NSString *)myHeight withTag:(NSInteger)Tag;
//先注释掉
//- (void)refreshTableView:(float)myHeight tagStr:(NSString *)tagStr;

- (void)beginRefreshTableView:(float)myHeight isWebViewDidFinishLoad:(BOOL)isWebViewDidFinishLoad;

@optional
- (void)goDetail:(NSString *)detailType detailId:(NSString *)detailId;
- (void)goWebView:(NSString *)url;

@end

@interface HomeWKZtCell : UITableViewCell

@property (nonatomic, retain) id<HomeWKZtCellDelegate> delegate;

+ (HomeWKZtCell *)cellWithTableView:(UITableView *)tableView;


-(void)setCellContent:(NSString *) contentStr isWebViewDidFinishLoad:(BOOL)isWebViewDidFinishLoad;




@end
