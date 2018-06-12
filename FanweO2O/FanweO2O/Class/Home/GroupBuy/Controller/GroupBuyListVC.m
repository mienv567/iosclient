//
//  GroupBuyListVC.m
//  FanweO2O
//  团购列表
//  Created by hym on 2017/1/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "GroupBuyListVC.h"
#import "ClassSectionView.h"
#import "ClassSectionModel.h"
#import "ClassSectionTableViewCell.h"
#import "ClassSelcectVC.h"
#import "LMDropdownView.h"
#import "NSDictionary+Property.h"
#import "ListRefreshLocationTBCell.h"
#import "StoreListTBCell.h"
#import "StoreListModel.h"
#import "GroupBuyModel.h"
#import "ListRefreshLocationModel.h"
#import "ClassSectionButton.h"
#import "UIView+BlocksKit.h"
#import "CustomGoodsComTBCell.h"
#import "UITableView+CNHEmptyDataSet.h"
#import "FWO2OJumpModel.h"
#import "FWO2OJump.h"
#import "DisplayStarView.h"
#import "PopView.h"
#import "MessageCenterViewController.h"
#import "ShoppingViewController.h"
#import "DiscoveryViewController.h"
#import "O2OAccountLoginVC.h"
#import "HomeViewController.h"

#import "RightLittleButtonOnBottom.h"
#define LMD_VIEW_TAG    2001

#define GRP_SECTION_DEFAULT     2

@interface GroupBuyListVC () <UITableViewDelegate,UITableViewDataSource,ClassSectionTableViewCellDelegate,ClassSelcectVCDelegate,ListRefreshLocationTBCellDelegate,LMDropdownViewDelegate,PopViewDelegate,UIScrollViewDelegate,RightLittleButtonOnBottomDelegate>
{
    PopView *pop;
    RightLittleButtonOnBottom  *_rightLittleButtonOnBottom;
}
@property (nonatomic, strong) NSArray *sectionArray;
@property (strong, nonatomic) LMDropdownView *dropdownView;
@property (nonatomic, strong) ClassBcate_list *selectCommon;
@property (nonatomic, strong) ClassQuan_list *selectArea;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSString *order_type;

@property (nonatomic, strong) ListRefreshLocationModel *location;

@end

@implementation GroupBuyListVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden =YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden =NO;

    HideIndicatorInView(self.view);

    self.title =@"";

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(64);
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.estimatedRowHeight = 44.0f;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    self.tableView.mj_header =  [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
//        self.page = 1;
//        [self.tableView.mj_footer resetNoMoreData];
//        [self.tableView.mj_footer endRefreshing];
//        
//    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{//上拉加载
        [self.tableView.mj_header endRefreshing];
        [self updateMoreData];
    }];
    
    //[self.tableView.mj_header beginRefreshing];
    
    [self updateNewData];
    
    //self.tableView.
    
    
    self.order_type = @"avg_point";


    self.kind =1;
    if (_content !=nil || ![_content isEqualToString:@""]) {
        self.searchText =_content;
    }
    self.judgeNav =NO;
     [self popViewController];
    
}
- (void)setContent:(NSString *)content
{
    _content =content;

}

- (void)popViewController
{
    pop =[[PopView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    pop.alpha =0.0;
    pop.delegate =self;
    [self.view bringSubviewToFront:pop];
    [self.view addSubview:pop];
    
    _rightLittleButtonOnBottom = [RightLittleButtonOnBottom buttonWithType:UIButtonTypeCustom];
    _rightLittleButtonOnBottom.delegate = self;
    _rightLittleButtonOnBottom.hidden = YES;
    _rightLittleButtonOnBottom.kind =0;
    [self.view addSubview:_rightLittleButtonOnBottom];
}

- (void)handerData {
    
    [super handerData];
    
    [self doInitSectionArray];
    
    self.dataArray = [NSMutableArray new];
    
    
    self.tableView.backgroundColor = kBackGroundColor;
    
    [self.tableView reloadData];
    
    //赋于下拉的里效果视图
    self.dropdownView = [[LMDropdownView alloc] init];
    self.dropdownView.contentBackgroundColor = [UIColor clearColor];
    self.dropdownView.closedScale = 1;
    self.dropdownView.delegate = self;
    self.dropdownView.animationDuration = 0.3;

    UIView *dropdownView = [[UIView alloc] initWithFrame:CGRectMake(0, 104, SCREEN_HEIGHT, CGRectGetHeight(self.view.frame) - 104)];

    dropdownView.backgroundColor = kBackGroundColor;
    dropdownView.tag = LMD_VIEW_TAG;
    
    [self.view addSubview:dropdownView];
    [self.view sendSubviewToBack:dropdownView];

    ListRefreshLocationModel *location = [ListRefreshLocationModel new];
    location.location = self.fanweApp.locateName;
    self.location = location;
}

- (void)doInitSectionArray {
    
    ClassSectionModel *model1 = [ClassSectionModel new];
    model1.name = @"全部分类";
    model1.image = @"o2o_classSection_down_icon";
    model1.imageSelect = @"o2o_classSection_up_icon";
    
    ClassSectionModel *model2 = [ClassSectionModel new];
    model2.name = @"全城·热门";
    model2.image = @"o2o_classSection_down_icon";
    model2.imageSelect = @"o2o_classSection_up_icon";
    
    ClassSectionModel *model3 = [ClassSectionModel new];
    model3.name = @"评价最高";
    model3.hsSelect = YES;
    model3.hsChange = YES;
    
    ClassSectionModel *model4 = [ClassSectionModel new];
    model4.name = @"离我最近";
    
    model4.hsChange = YES;
    
    
    self.sectionArray = @[model1,model2,model3,model4];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (void)updateNewData {
    
    self.page = 1;
    self.order_type = @"avg_point";
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"tuan" forKey:@"ctl"];
    [parameters setValue:@"index_v2" forKey:@"act"];
    [parameters setValue:self.order_type forKey:@"order_type"];
    if (_content != nil) {
          [parameters setValue:_content forKey:@"keyword"];
    }
    
    if (self.haselect) {
        //[parameters setValue:_content forKey:@"keyword"];
        
        [parameters setValue:@(self.selectpid) forKey:@"cate_id"];
        
    }
    
    ShowIndicatorTextInView(self.view,@"");
    
    [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
        
        HideIndicatorInView(self.view);
        
        NSLog(@"================");
        
        //NSLog(@"%@",responseJson);
        //[responseJson[@"item"][0][@"deal"][0] createPropertyCode];
        
        NSDictionary *dicPage = responseJson[@"page"];
        
        if (self.page >= [dicPage[@"page_total"] integerValue]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self doInitSectionArray];
        
        self.classSectionModel = [ClassSectionDataModel mj_objectWithKeyValues:responseJson];
        
        if (self.haselect) {
            self.haselect = NO;
            BOOL hsFind = NO;
            for (ClassBcate_list* a in self.classSectionModel.bcate_list) {
                if (a.id == self.selectpid ) {
                    self.selectCommon = a;
                    self.selectCommon.hsSelectModel = [a.bcate_type firstObject];
                    ClassSectionModel *model1 = self.sectionArray[0];
                    model1.name = self.selectCommon.name;
                    //self.selectCommon.hsSelectModel.name = self.selectCommon.name;
                    hsFind = YES;
                }
            }
            if (!hsFind) {
                self.selectCommon = [self.classSectionModel.bcate_list firstObject];
                self.selectCommon.hsSelectModel = [self.selectCommon.bcate_type firstObject];
                
            }
            
            self.selectArea = [self.classSectionModel.quan_list firstObject];
            self.selectArea.hsSelectModel = [self.selectArea.quan_sub firstObject];
            
        }else {
            
            self.selectCommon = [self.classSectionModel.bcate_list firstObject];
            self.selectCommon.hsSelectModel = [self.selectCommon.bcate_type firstObject];
            
            self.selectArea = [self.classSectionModel.quan_list firstObject];
            self.selectArea.hsSelectModel = [self.selectArea.quan_sub firstObject];
        }
        
   
        
        [self.dataArray removeAllObjects];
        
        self.dataArray = [GroupBuyModel mj_objectArrayWithKeyValuesArray:responseJson[@"item"]];
        
        [self.tableView tableViewDisplayWitMsg:@"暂无团购" ifNecessaryForRowCount:self.dataArray.count];
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
    } FailureBlock:^(NSError *error) {
        HideIndicatorInView(self.view);
        [self.tableView.mj_header endRefreshing];
        
    }];
    
}

- (void)updateMoreData {
    self.page ++;
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"tuan" forKey:@"ctl"];
    [parameters setValue:@"index_v2" forKey:@"act"];
    [parameters setValue:self.order_type forKey:@"order_type"];
    [parameters setValue:@(self.page) forKey:@"page"];
    if (_content != nil) {
        [parameters setValue:_content forKey:@"keyword"];
    }
    
    ClassBcate_type *Bcate_type = self.selectCommon.hsSelectModel;
    //团购列表多对一关系，需要穿大类id
    [parameters setValue:@(Bcate_type.id) forKey:@"id"];
    [parameters setValue:@(Bcate_type.cate_id) forKey:@"cate_id"];
    
    ClassQuan_sub *Quan_sub = self.selectArea.hsSelectModel;
    
    [parameters setValue:@(Quan_sub.id) forKey:@"qid"];
    if (_content != nil) {
        [parameters setValue:_content forKey:@"keyword"];
    }
    
    [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
        
        HideIndicatorInView(self.view);
        NSLog(@"================");
        
        
        //[self doInitSectionArray];
        
        /*
         self.classSectionModel = [ClassSectionDataModel mj_objectWithKeyValues:responseJson];
         self.selectCommon = [self.classSectionModel.bcate_list firstObject];
         self.selectCommon.hsSelectModel = [self.selectCommon.bcate_type firstObject];
         
         self.selectArea = [self.classSectionModel.quan_list firstObject];
         self.selectArea.hsSelectModel = [self.selectArea.quan_sub firstObject];
         */
        [self.tableView.mj_footer endRefreshing];
        NSDictionary *dicPage = responseJson[@"page"];
        
        if (self.page >= [dicPage[@"page_total"] integerValue]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        //[self.dataArray removeAllObjects];
        NSArray *array = [GroupBuyModel mj_objectArrayWithKeyValuesArray:responseJson[@"item"]];
        [self.dataArray addObjectsFromArray:array];
        
        //self.title = responseJson[@"page_title"];
        
        [self.tableView reloadData];
        
        
        
    } FailureBlock:^(NSError *error) {
        self.page -- ;
        [self.tableView.mj_footer endRefreshing];
        HideIndicatorInView(self.view);
    }];

}

#pragma mark 选择
- (void)updateSelectData {
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"tuan" forKey:@"ctl"];
    [parameters setValue:@"index_v2" forKey:@"act"];
    [parameters setValue:self.order_type forKey:@"order_type"];
    ClassBcate_type *Bcate_type = self.selectCommon.hsSelectModel;
    //团购列表多对一关系，需要穿大类id
    [parameters setValue:@(Bcate_type.id) forKey:@"id"];
    [parameters setValue:@(Bcate_type.cate_id) forKey:@"cate_id"];
    
    ClassQuan_sub *Quan_sub = self.selectArea.hsSelectModel;
    [parameters setValue:@(Quan_sub.id) forKey:@"qid"];
    if (_content != nil) {
        [parameters setValue:_content forKey:@"keyword"];
    }
    //[parameters setValue:@(Quan_sub.pid) forKey:@"qid"];
    ShowIndicatorTextInView(self.view,@"");
    [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
        
        HideIndicatorInView(self.view);
        NSLog(@"================");
        
        self.page = 1;
        [self.tableView.mj_footer resetNoMoreData];
        //[self doInitSectionArray];
        
        /*
         self.classSectionModel = [ClassSectionDataModel mj_objectWithKeyValues:responseJson];
         self.selectCommon = [self.classSectionModel.bcate_list firstObject];
         self.selectCommon.hsSelectModel = [self.selectCommon.bcate_type firstObject];
         
         self.selectArea = [self.classSectionModel.quan_list firstObject];
         self.selectArea.hsSelectModel = [self.selectArea.quan_sub firstObject];
         */
        
        
        self.classSectionModel = [ClassSectionDataModel mj_objectWithKeyValues:responseJson];
        [self selectDataHandler];

        
        
        
        NSDictionary *dicPage = responseJson[@"page"];
        
        if (self.page >= [dicPage[@"page_total"] integerValue]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.dataArray removeAllObjects];
        
        self.dataArray = [GroupBuyModel mj_objectArrayWithKeyValuesArray:responseJson[@"item"]];
        
        //self.title = responseJson[@"page_title"];
        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
    } FailureBlock:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        HideIndicatorInView(self.view);
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (self.sectionArray.count == 0) {
            return 0;
        }
        return 40;
    }else if (indexPath.section == 1) {
        
        return 36;
    }
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    
    if (section >= GRP_SECTION_DEFAULT) {
        
        
        if (self.dataArray.count == 0 ) {
            return 0.0001f;
        }
        return 55.0f;
    }
    
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section >= GRP_SECTION_DEFAULT) {
        
        GroupBuyModel *model = self.dataArray[section - GRP_SECTION_DEFAULT];
        
        if (model.deal.count > 2) {
            
            if (!model.hsExpanded) {
                return 55;
            }
        }
        
        return 10.0f;
    }
    
    return 0.0001f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 1;
    }
    
    GroupBuyModel *model = self.dataArray[section-GRP_SECTION_DEFAULT];
    
    if (model.deal.count > 2) {
        
        return model.hsExpanded ? model.deal.count : 2;
        
    }
    
    return model.deal.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    
    
    return GRP_SECTION_DEFAULT + self.dataArray.count;
}



#define CLASS_SECTION_TAG   1001

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        ClassSectionTableViewCell *cell = [ClassSectionTableViewCell cellWithTableView:tableView];
        
        cell.delegate = self;
        cell.array = self.sectionArray;
        
        return cell;
        
    }else if (indexPath.section == 1) {
        
        ListRefreshLocationTBCell *cell = [ListRefreshLocationTBCell cellWithTbaleview:tableView];
        
        cell.delegate = self;
        cell.model = self.location;
        return cell;
    }
    
    CustomGoodsComTBCell *cell = [CustomGoodsComTBCell cellWithTbaleview:tableView];
    
    GroupBuyModel *model = self.dataArray[indexPath.section - GRP_SECTION_DEFAULT];

    CustomGoodsModel *goods = model.deal[indexPath.row];
    cell.count = 1;
    cell.goodModel = goods;
    
    //GroupBuyModel *model = self.dataArray[section-GRP_SECTION_DEFAULT];
    
    if (model.deal.count > 2) {
        if (model.hsExpanded) {
            
            if (model.deal.count - 1 == indexPath.row) {
                cell.line.hidden = YES;
            }else {
                cell.line.hidden = NO;
            }
        }else {
            if (indexPath.row == 1) {
                cell.line.hidden = YES;
            }else {
                cell.line.hidden = NO;
            }
            
        }
        
        //return model.hsExpanded ? model.deal.count : 2;
        
    }else {
        
        if (model.deal.count - 1 == indexPath.row)  {
            cell.line.hidden = YES;
        }else {
            cell.line.hidden = NO;
        }

    }
    
    //StoreListModel *model = self.dataArray[indexPath.row];
    
    //StoreListTBCell *cell = [StoreListTBCell cellWithTbaleview:tableView];
    
    //cell.model = model;
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    
    if (section >= GRP_SECTION_DEFAULT) {
        
        GroupBuyModel *model = self.dataArray[section - GRP_SECTION_DEFAULT];
        if (model.deal.count > 2) {
            if (!model.hsExpanded) {
                UIView *bg = [UIView new];
                [bg setBackgroundColor:[UIColor whiteColor]];
                
                UIView *line = [UIView new];
                line.backgroundColor = kLineColor;
                [bg addSubview:line];
                
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(bg.mas_left).with.offset(10);
                    make.right.equalTo(bg.mas_right).with.offset(-10);
                    make.top.equalTo(bg.mas_top).with.offset(0);
                    make.height.mas_offset(0.5);
                }];
                
                ClassSectionButton *btn = [ClassSectionButton new];

                [btn setTitleColor:kAppFontColorComblack forState:UIControlStateNormal];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [btn setTitle:[NSString stringWithFormat:@"其他%ld个团购",model.deal.count - 2] forState:UIControlStateNormal];
                
                __weak GroupBuyListVC *weakSelf = self;
                [btn bk_whenTapped:^{
                    model.hsExpanded = YES;
                    [weakSelf.tableView reloadData];
                }];
                
                [bg addSubview:btn];
                
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(bg.mas_left).with.offset(0);
                    make.right.equalTo(bg.mas_right).with.offset(0);
                    make.top.equalTo(line.mas_bottom).with.offset(0);
                    make.bottom.equalTo(bg.mas_bottom).with.offset(0);
                }];
                
                UIView *view = [UIView new];
                [view setBackgroundColor:kBackGroundColor];
                
                [view addSubview:bg];
                
                [bg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view.mas_left).with.offset(0);
                    make.right.equalTo(view.mas_right).with.offset(0);
                    make.top.equalTo(view.mas_top).with.offset(0);
                    make.bottom.equalTo(view.mas_bottom).with.offset(-10);
                }];
                return view;
            }
        }
       
    }
    
    UIView *view  = [UIView new];
    [view setBackgroundColor:kBackGroundColor];
    
    return view;
}

#define HEADERSECTION_LBNAME            10001
#define HEADERSECTION_DISTANCE          10002
#define HEADERSECTION_LBEVALUATE        10003
#define HEADERSECTION_SATRCONTAINER     10004

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  
    if (section >= GRP_SECTION_DEFAULT) {
        
        //static NSString *viewIdentfier = @"headView";
        //UITableViewHeaderFooterView  *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewIdentfier];
        UIView *view = [UIView new];
        //if (view == nil) {
            //view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:viewIdentfier];
            [view setBackgroundColor:[UIColor whiteColor]];
            //56
            
            UILabel *lbName = [UILabel new];
            [lbName setTextColor:kAppFontColorComblack];
            [lbName setTag:HEADERSECTION_LBNAME];
            [lbName setFont:[UIFont systemFontOfSize:15]];
            [view addSubview:lbName];
            [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view.mas_left).with.offset(10);
                make.top.equalTo(view.mas_top).with.offset(8);
                make.height.mas_offset(24);
                //make.centerY.equalTo(view).with.offset(0);
            }];
            
            UIView *satr = [UIView new];
            [satr setTag:HEADERSECTION_SATRCONTAINER];
            
            UIView *line = [UIView new];
            [line setBackgroundColor:kLineColor];
            
            [view addSubview:line];
            
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view.mas_left).with.offset(10);
                make.bottom.equalTo(view.mas_bottom).with.offset(0);
                make.height.mas_offset(0.5);
                make.right.equalTo(view.mas_right).with.offset(0);
            }];
        
        UILabel *lbDistance = [UILabel new];
        [lbDistance setTextColor:kAppFontColorGray];
        [lbDistance setTag:HEADERSECTION_LBNAME];
        [lbDistance setFont:[UIFont systemFontOfSize:12]];
        [view addSubview:lbDistance];
        [lbDistance mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view.mas_right).with.offset(-10);
            make.bottom.equalTo(view.mas_bottom).with.offset(-5);
            make.height.mas_offset(18);
            //make.centerY.equalTo(view).with.offset(0);
        }];

        
        //}
        
        GroupBuyModel *model = self.dataArray[section - GRP_SECTION_DEFAULT];
        
        //UILabel *lbName = [view viewWithTag:HEADERSECTION_LBNAME];
        lbName.text = model.location_name;
        
        if (model.area_name.length > 0) {
            lbDistance.text = [NSString stringWithFormat:@"%@ %.2fkm",model.area_name,model.distance/1000];
        }else {
            lbDistance.text = [NSString stringWithFormat:@"%.2fkm",model.distance/1000];
        }
        
        
        /*
        if (model.distance < 1000) {
           lbDistance.text = [NSString stringWithFormat:@"%@ %.2fm",model.area_name,model.distance];
        }else {
            lbDistance.text = [NSString stringWithFormat:@"%@ %.2fkm",model.area_name,model.distance/1000];
        }
        */
        
        if (model.avg_point == 0) {
            
            UILabel *lbPoint = [UILabel new];
            [lbPoint setTextColor:kAppFontColorGray];
            [lbPoint setTag:HEADERSECTION_LBNAME];
            [lbPoint setFont:[UIFont systemFontOfSize:12]];
            [view addSubview:lbPoint];
            [lbPoint mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view.mas_left).with.offset(10);
                make.centerY.equalTo(lbDistance).with.offset(0);
                make.height.mas_offset(18);
                //make.centerY.equalTo(view).with.offset(0);
            }];
            
            lbPoint.text = @"暂无评分";

        }else {
            UIView *viewContainer = [UIView new];
            [view addSubview:viewContainer];
            
            [viewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view.mas_left).with.offset(10);
                make.right.equalTo(lbDistance.mas_left).with.offset(20);
                make.bottom.equalTo(view.mas_bottom).with.offset(-5);
                make.height.mas_offset(18);
            }];
            
            
            DisplayStarView *sv = [[DisplayStarView alloc]initWithFrame:CGRectMake(0, 0, 80, 18)];
            [viewContainer addSubview:sv];
            
            sv.showStar = model.avg_point * 20;
            
            /*
            CGFloat left = 0;
            for (int i = 0; i < floor(model.avg_point) ; i++) {
                
                UIImageView *image = [UIImageView new];
                [image setImage:[UIImage imageNamed:@"o2o_star_h_icon"]];
                
                [viewContainer addSubview:image];
                [image mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(viewContainer.mas_left).with.offset(left);
                    make.centerY.equalTo(viewContainer);
                    make.size.mas_equalTo(CGSizeMake(13, 13));
                }];
                
                
                left = left + 15;
            }
            
            for (int j = floor(model.avg_point); j < 5; j++) {
                
                UIImageView *image = [UIImageView new];
                [image setImage:[UIImage imageNamed:@"o2o_star_icon"]];
                
                [viewContainer addSubview:image];
                [image mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(viewContainer.mas_left).with.offset(left);
                    make.centerY.equalTo(viewContainer);
                    make.size.mas_equalTo(CGSizeMake(13, 13));
                }];
                
                left = left + 15;
            }
            */
            UILabel *lbPoint = [UILabel new];
            [lbPoint setFont:[UIFont systemFontOfSize:12]];
            [lbPoint setTextColor:RGB(255, 168, 0)];
            [viewContainer addSubview:lbPoint];
            
            [lbPoint mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(viewContainer.mas_left).with.offset(80 + 5);
                make.centerY.equalTo(viewContainer);
            }];
            
            lbPoint.text = [NSString stringWithFormat:@"%.1f分",model.avg_point];
            
        }
        
        return view;
        
    }
    
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor whiteColor]];
    return view;
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= GRP_SECTION_DEFAULT) {
        
        GroupBuyModel *model = self.dataArray[indexPath.section - GRP_SECTION_DEFAULT];
        
        CustomGoodsModel *goods = model.deal[indexPath.row];
        
        //CustomGoodsModel *goods = model.deal[indexPath.row];
        
        FWO2OJumpModel *jump = [FWO2OJumpModel new];
        //FavorableModel *model = self.dataArray[indexPath.row];
        //ActivityItem *item = self.activityArray[indexPath.row];
        
        jump.type = 0;
    
        jump.url = goods.app_url;
        jump.isHideTabBar = YES;
        jump.isHideNavBar = YES;
        [FWO2OJump didSelect:jump];

    }
}

#pragma marl ClassSectionTableViewCellDelegate

- (void)ClassSectionSelect:(ClassSectionModel *)model {
    
    //[self.view addSubview:vc.view];
    
    if (model.tag == 0) {
        
        ClassSelcectVC *vc = [[ClassSelcectVC alloc] initWithNibName:@"ClassSelcectVC" bundle:nil];
        
        vc.view.frame = CGRectMake(0, 64 + 40 - (SCREEN_HEIGHT - 64 - 40), SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40);
        
        [vc classSelectCommonInitWith:self.selectCommon
                             delegate:self
                           selectType:ClassSelectCommon];
        vc.dataArray = self.classSectionModel.bcate_list;
        
        if (model.hsSelect) {
            if (self.dropdownView.isOpen) {
                
                //[self LMDropdownHide];
                [self.dropdownView hide];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    ClassSectionModel *model1 = self.sectionArray[0];
                    
                    model1.hsSelect = YES;
                    
                    [self.tableView reloadData];
                    
                    UIView *dropdownView = [self.view viewWithTag:LMD_VIEW_TAG];
                    
                    [self.view bringSubviewToFront:dropdownView];
                    
                    [self.dropdownView showInView:dropdownView withContentView:vc.view atOrigin:CGPointMake(0,0)];
                });
                
            }else {
                UIView *dropdownView = [self.view viewWithTag:LMD_VIEW_TAG];
                
                [self.view bringSubviewToFront:dropdownView];
                
                [self.dropdownView showInView:dropdownView withContentView:vc.view atOrigin:CGPointMake(0,0)];
            }
            
        }else {
            [self LMDropdownHide];
        }
    }else if (model.tag == 1) {
        
        
        ClassSelcectVC *vc = [[ClassSelcectVC alloc] initWithNibName:@"ClassSelcectVC" bundle:nil];
        
        
        vc.view.frame = CGRectMake(0, 64 + 40 - (SCREEN_HEIGHT - 64 - 40), SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40);
        
        
        [vc classSelectAreaInitWith:self.selectArea
                           delegate:self
                         selectType:ClassSelectArea];
        
        vc.dataArray = self.classSectionModel.quan_list;
        
        
        if (model.hsSelect) {
            
            if (self.dropdownView.isOpen) {
                
                //[self LMDropdownHide];
                [self.dropdownView hide];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    ClassSectionModel *model1 = self.sectionArray[1];
                    
                    model1.hsSelect = YES;
                    
                    [self.tableView reloadData];
                    
                    UIView *dropdownView = [self.view viewWithTag:LMD_VIEW_TAG];
                    
                    [self.view bringSubviewToFront:dropdownView];
                    
                    [self.dropdownView showInView:dropdownView withContentView:vc.view atOrigin:CGPointMake(0,0)];
                });
                
            }else {
                UIView *dropdownView = [self.view viewWithTag:LMD_VIEW_TAG];
                
                [self.view bringSubviewToFront:dropdownView];
                
                [self.dropdownView showInView:dropdownView withContentView:vc.view atOrigin:CGPointMake(0,0)];
            }
            
            
        }else {
            [self LMDropdownHide];
        }
        
    }else if (model.tag == 2) {
        //距离
        self.order_type = @"avg_point";
        [self LMDropdownHide];
        [self updateSelectData];
        
    }else if (model.tag == 3) {
        self.order_type = @"distance";
        [self LMDropdownHide];
        [self updateSelectData];
    }
    
    //[self.tableView reloadData];
}

#pragma mark ClassSelcectVCDelegate

- (void)ClassSelectModel:(id)model classSelectType:(ClassSelectType)classSelectType{
    
    if (classSelectType == ClassSelectCommon) {
        
        self.selectCommon = (ClassBcate_list *)model;
        
        ClassSectionModel *model1 = self.sectionArray[0];
        
        if (self.selectCommon.hsSelectModel.id == 0) {
            model1.name = self.selectCommon.name;
        }else {
            model1.name = self.selectCommon.hsSelectModel.name;
        }
        
        model1.hsSelect = NO;
        
        ClassSectionModel *model2 = self.sectionArray[1];
        
        model2.hsSelect = NO;
        
    }else if (classSelectType == ClassSelectArea) {
        
        self.selectArea = (ClassQuan_list *)model;
        
        ClassSectionModel *model1 = self.sectionArray[1];
        model1.name = self.selectArea.hsSelectModel.name;
        model1.hsSelect = NO;
        
        ClassSectionModel *model2 = self.sectionArray[0];
        
        model2.hsSelect = NO;
    }
    
    [self updateSelectData];
    
    [self LMDropdownHide];
    
    //[self.tableView reloadData];
}

- (void)LMDropdownHide {
    
    [self.dropdownView hide];
    
    UIView *dropdownView = [self.view viewWithTag:LMD_VIEW_TAG];
    [self.view sendSubviewToBack:dropdownView];
    
}

- (void)dropdownViewWillHide:(LMDropdownView *)dropdownView {
    
    ClassSectionModel *model1 = self.sectionArray[0];
    
    model1.hsSelect = NO;
    
    ClassSectionModel *model2 = self.sectionArray[1];
    
    model2.hsSelect = NO;
    
    [self.tableView reloadData];
}

- (void)startLocation {
    
    self.location.hsStart = YES;
    
    [self.fanweApp startLocation];
    
    [self.tableView reloadData];
}

- (void)locationFun {
    
    self.location.hsStart = NO;
    
    ListRefreshLocationModel *location = [ListRefreshLocationModel new];
    location.location = self.fanweApp.locateName;
    
    self.location = location;
    
    [self updateSelectData];
    //[self.tableView reloadData];
}

- (void)nextToNewViewController{
    [self.view bringSubviewToFront:pop];
    [self noReadMessage];
    [UIView animateWithDuration:0.1 animations:^{
        pop.alpha =1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.2f initialSpringVelocity:0.1f options:UIViewAnimationOptionLayoutSubviews animations:^{
                pop.closeButton .frame =CGRectMake((kScreenW-40)/2, kScreenH-4*40-180, 40, 40);
            } completion:nil];
        });
    }];
}
- (void)noReadMessage

{
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"uc_msg" forKey:@"ctl"];
    [dic setObject:@"countNotRead" forKey:@"act"];
    [self.httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] ==1) {
            pop.no_msg =[responseJson[@"count"] integerValue];
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma make PopViewDelegate
-(void)back
{
   [UIView animateWithDuration:0.1 animations:^{
       pop.alpha =0.0;
       pop.closeButton .frame =CGRectMake((kScreenW-40)/2, kScreenH-4*40-180-80, 40, 40);
   }];
}
- (void)toRefresh
{
     [self LMDropdownHide];
    [self back];
    [self.tableView.mj_header beginRefreshing];
}

- (void)selectButton:(NSInteger)count
{
    NSNumber *number = [NSNumber numberWithInteger:count];
    [self back];
    [self performSelector:@selector(performButtonClick:) withObject:number afterDelay:0.5];
}

- (void)performButtonClick:(NSNumber *)number
{
    NSInteger count =[number integerValue];
    switch (count) {
        case 0:
        {
            self.tabBarController.selectedIndex = 0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:NO];
            });
        }

            break;
        case 1:
            [self.navigationController pushViewController:[DiscoveryViewController new] animated:YES];
            break;
        case 2:
        {
            if (self.fanweApp.is_login ==NO) {
                [self.navigationController pushViewController:[O2OAccountLoginVC new] animated:YES];
            }else
            {
                [self.navigationController pushViewController:[MessageCenterViewController new] animated:YES];
            }
        }
            break;
        case 3:
        {
            ShoppingViewController *shop = [ShoppingViewController webControlerWithUrlString:nil andNavTitle:nil isShowIndicator:NO isHideNavBar:YES isHideTabBar:NO];
            [self.navigationController pushViewController:shop animated:YES];
        }
            break;
        case 4:
        {
            self.tabBarController.selectedIndex = 3;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:NO];
            });
        }
            break;
        default:
            break;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.y > 300) {
        
        _rightLittleButtonOnBottom.hidden =NO;
        
    }else
    {
        _rightLittleButtonOnBottom.hidden =YES;
    }
}
- (void)backToTop
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

- (void)selectDataHandler {
    
    
    //ClassBcate_list *selectCommon = [self.classSectionModel.bcate_list firstObject];
    
    BOOL hsFind = NO;
    for (ClassBcate_list* a in self.classSectionModel.bcate_list) {
        if (a.id == self.selectCommon.id ) {
            
            //self.selectCommon = a;
            //self.selectCommon.hsSelectModel = [a.bcate_type firstObject];
            BOOL hsFind1 = NO;
            for (ClassBcate_type *b in a.bcate_type) {
                
                if (b.id == self.selectCommon.hsSelectModel.id) {
                    
                    self.selectCommon = a;
                    self.selectCommon.hsSelectModel = b;
                    
                    if (b.id == 0) {
                        ClassSectionModel *model1 = self.sectionArray[0];
                        model1.name = self.selectCommon.name;
                        self.selectCommon.hsSelectModel.name = self.selectCommon.name;
                    }
                    hsFind1 = YES;
                    break;
                }
            }
            
            if (!hsFind1) {
                
                self.selectCommon = a;
                self.selectCommon.hsSelectModel = [a.bcate_type firstObject];
                ClassSectionModel *model1 = self.sectionArray[0];
                model1.name = self.selectCommon.name;
                self.selectCommon.hsSelectModel.name = self.selectCommon.name;
            }
            
            
            hsFind = YES;
            break;
        }
    }
    
    if (!hsFind) {
        self.selectCommon = [self.classSectionModel.bcate_list firstObject];
        self.selectCommon.hsSelectModel = [self.selectCommon.bcate_type firstObject];
        
        ClassSectionModel *model1 = self.sectionArray[0];
        model1.name = self.selectCommon.name;
        self.selectCommon.hsSelectModel.name = self.selectCommon.name;
    }
    
    
    
    hsFind = NO;
    
    for (ClassQuan_list *selectArea in self.classSectionModel.quan_list) {
        if (selectArea.id == self.selectArea.id) {
            hsFind = YES;
            BOOL hsFind1 = NO;
            for (ClassQuan_sub *hsSelectModel in selectArea.quan_sub) {
                if (hsSelectModel.id == self.selectArea.hsSelectModel.id) {
                    self.selectArea = selectArea;
                    self.selectArea.hsSelectModel = hsSelectModel;
                    
                    if (hsSelectModel.pid == 0) {
                        ClassSectionModel *model1 = self.sectionArray[1];
                        model1.name = selectArea.name;
                    }
                    
                    
                    hsFind1 = YES;
                    
                    break;
                }
            }
            
            if (!hsFind1) {
                self.selectArea = selectArea;
                self.selectArea.hsSelectModel = [self.selectArea.quan_sub firstObject];
                ClassSectionModel *model1 = self.sectionArray[1];
                model1.name = self.selectArea.name;
                //self.selectArea.hsSelectModel.name = self.selectArea.name;
            }
            
            
            break;
            
        }
    }
    
    if (!hsFind) {
        self.selectArea = [self.classSectionModel.quan_list firstObject];
        self.selectArea.hsSelectModel = [self.selectArea.quan_sub firstObject];
        
        ClassSectionModel *model1 = self.sectionArray[1];
        model1.name = self.selectArea.name;
        //self.selectArea.hsSelectModel.name = self.selectArea.name;
    }
    
}


@end
