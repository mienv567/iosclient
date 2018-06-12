//
//  HomeZtCell.h
//  O2O
//
//  Created by mac on 15/3/17.
//  Copyright (c) 2015年 fanwe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeZtCellDelegate <NSObject>

@required
- (void)refreshTableView:(NSString *)myHeight withTag:(NSInteger)Tag;
//先注释掉
//- (void)refreshTableView:(float)myHeight tagStr:(NSString *)tagStr;

@optional
- (void)goDetail:(NSString *)detailType detailId:(NSString *)detailId;
- (void)goWebView:(NSString *)url;

@end

@interface HomeZtCell : UITableViewCell<UIWebViewDelegate>

@property (nonatomic, retain) id<HomeZtCellDelegate> delegate;

@property (nonatomic, copy) NSString *tagStr;

+ (HomeZtCell *)cellWithTableView:(UITableView *)tableView cellIndent:(NSString *)cellIndent;

//设置内容
-(void)setCellContent:(NSString *) contentStr isWebViewDidFinishLoad:(BOOL)isWebViewDidFinishLoad;

//获得单元格式高度
-(CGFloat)getCellHeight:(float)myHeight;

- (void)setTableViewTag:(NSInteger)Tag;

@end
