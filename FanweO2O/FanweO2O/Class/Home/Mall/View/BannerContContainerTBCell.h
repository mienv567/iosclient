//
//  BannerContContainerTBCell.h
//  FanweO2O
//
//  Created by hym on 2016/12/12.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BannerModel;

#define FW_O2O_BANNER_HIGHT         115

#define FW_O2O_BANNER_BIG_HIGHT     175 * SCREEN_WIDTH/375.0


@protocol  BannerContContainerDelegate <NSObject>

@optional
-(void)bannerContContainerGoNextVC:(BannerModel *)model;
@end


@interface BannerContContainerTBCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *bannerArray;

+ (BannerContContainerTBCell *)cellWithTableView:(UITableView *)tableView;

//isSquare - 0为沃形显示，1为长方形显示
+ (BannerContContainerTBCell *)cellWithTableView:(UITableView *)tableView isSquare:(NSInteger)isSquare;

+ (BannerContContainerTBCell *)cellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, retain) id <BannerContContainerDelegate> delegate;

@end
