//
//  CommonBaseListVC.h
//  FanweO2O
//
//  Created by hym on 2017/1/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassSectionDataModel.h"
@interface CommonBaseListVC : UIViewController

@property (nonatomic, assign) NSInteger selectpid;          //一级id

@property (nonatomic, assign) NSInteger selectLevelPid;     //二级id

@property (nonatomic, assign) BOOL haselect;                //是否有id传入

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *classArray;
@property (nonatomic, strong) NetHttpsManager *httpManager;
@property (nonatomic, strong) GlobalVariables *fanweApp;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger page_total;
@property (nonatomic, strong) ClassSectionDataModel *classSectionModel;
@property (nonatomic, assign) int kind; //1:有二级导航栏 2:只有系统导航栏;
@property (nonatomic,copy)NSString *searchText; //搜索导航栏和默认导航栏的内容
@property (nonatomic,assign)BOOL judgeNav; //NO:搜索导航栏 YES:默认导航栏

//下拉刷新
- (void)updateNewData;

//上拉刷新
- (void)updateMoreData;

//初始化
- (void)handerData;

- (void)nextToNewViewController;

- (void)locationFun;

@end
