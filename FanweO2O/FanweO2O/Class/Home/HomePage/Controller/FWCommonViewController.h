//
//  FWCommonViewController.h
//  FanweO2O
//
//  Created by hym on 2016/12/15.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWCommonViewController : UIViewController


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *advArray;             //adv
@property (nonatomic, strong) NSMutableArray *adv2Array;            //adv2
@property (nonatomic, strong) NSMutableArray *indexsArray;          //首页菜单列表
@property (nonatomic, strong) NSMutableArray *articleArray;         //头条
@property (nonatomic, strong) NSMutableArray *supplierListArray;    //推荐
@property (nonatomic, strong) NSMutableArray *dealListArray;        //猜你喜欢

@property (nonatomic, strong) NSMutableArray *cateListArray;        //美食
@property (nonatomic, strong) NSMutableArray *eventListArray;       //活动
@property (nonatomic, strong) NSMutableArray *youhuiListArray;      //优惠

@property (nonatomic, strong) NetHttpsManager *httpManager;
@property (nonatomic, strong) GlobalVariables *fanweApp;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger is_banner_square;
@property (nonatomic, copy) NSString *city_id;
@property (nonatomic, copy) NSString *city_name;

@property (nonatomic, copy) NSString *zt3Html; //专题推荐
@property (nonatomic, assign) BOOL zt3_isWebViewDidFinishLoad; //专题是否加载完成
@property (nonatomic, assign) float myZt3Height; //专题高度

@property (nonatomic, copy) NSString *zt4Html; //专题推荐
@property (nonatomic, assign) BOOL zt4_isWebViewDidFinishLoad; //专题是否加载完成
@property (nonatomic, assign) float myZt4Height; //专题高度

@property (nonatomic, copy) NSString *zt5Html; //专题推荐
@property (nonatomic, assign) BOOL zt5_isWebViewDidFinishLoad; //专题是否加载完成
@property (nonatomic, assign) float myZt5Height; //专题高度

@property (nonatomic, copy) NSString *zt6Html; //专题推荐
@property (nonatomic, assign) BOOL zt6_isWebViewDidFinishLoad; //专题是否加载完成
@property (nonatomic, assign) float myZt6Height; //专题高度


//下拉刷新
- (void)updateNewData;

//上拉刷新
- (void)updateMoreData;

//初始化
- (void)handerData;

@end
