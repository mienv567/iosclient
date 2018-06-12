//
//  MessageCenterViewController.m
//  FanweO2O
//
//  Created by ycp on 17/1/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "MessageCenterTableViewCell.h"
#import "NetHttpsManager.h"
#import "MessageModel.h"

#import "PopView.h"
#import "MessageCenterViewController.h"
#import "ShoppingViewController.h"
#import "DiscoveryViewController.h"
#import "O2OAccountLoginVC.h"
#import "SecondaryNavigationBarView.h"
#import "ClassificationMessageViewController.h"
@interface MessageCenterViewController ()<UITableViewDelegate,UITableViewDataSource,PopViewDelegate,SecondaryNavigationBarViewDelegate>
{
    UITableView *_myTableView;
    NSArray *photoArray;
    NSArray *titleArray;
    NSMutableArray *contentArray;
    NSArray *timerArray;
    NetHttpsManager *_httpManager;
    MessageModel *_model;
    
    SecondaryNavigationBarView *nav;
    PopView *pop;
}
@end

@implementation MessageCenterViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.navigationBar.hidden =YES;
     self.view.backgroundColor =[UIColor whiteColor];
    [self updateNetWork];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden =NO;
    HideIndicatorInView(self.view);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.titleTextAttributes =@{NSFontAttributeName:KAppTextFont15};
    [self bulidNav];
    _httpManager =[NetHttpsManager manager];
    titleArray =[NSArray arrayWithObjects:@"物流消息",@"通知消息",@"资产消息",@"验证消息", nil];
    contentArray =[NSMutableArray array];
    photoArray =[NSArray arrayWithObjects:@"my_ logistics",@"my_noticeIcon",@"my_ assetsIcon",@"my_ validationIcon", nil];
    [self buildTableView];
    [_myTableView registerNib:[UINib nibWithNibName:@"MessageCenterTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self updateNetWork];
}
- (void)buildTableView
{
    _myTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH-64) style:UITableViewStylePlain];
    _myTableView.delegate =self;
    _myTableView.dataSource =self;
    _myTableView.scrollEnabled =NO;
    _myTableView.rowHeight =74.0f;
    [self.view addSubview:_myTableView];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [_myTableView setTableFooterView:v];
    
    pop =[[PopView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    pop.alpha =0.0;
    pop.delegate =self;
    [self.view bringSubviewToFront:pop];
    [self.view addSubview:pop];
}
- (void)bulidNav
{
    nav =[SecondaryNavigationBarView EditNibFromXib];
    nav.frame =CGRectMake(0, 20, kScreenW, 44);
    nav.delegate =self;
    nav.searchText =@"消息中心";
    nav.isTitleOrSearch =YES;
    [self.view addSubview:nav];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MessageCenterTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
  
    cell.titleLabel.text =titleArray[indexPath.row];

//    cell.contentLabel.text =[NSString stringWithFormat:@"%@%@",_model.]
    if (_model !=nil) {
        Info *info;
        if (indexPath.row ==0) {
            info =_model.delivery;
        }else if(indexPath.row ==1){
            info =_model.notify;
        }else if(indexPath.row ==2){
            info =_model.account;
        }else {
            info =_model.confirm;
        }

        if (info.content ==nil) {
            cell.contentLabel.text =@"暂无消息";
            [contentArray addObject:cell.contentLabel.text];
        }else
        {
             NSLog(@"info.content = %@",info.content);
             cell.contentLabel.text =[NSString stringWithFormat:@"%@! %@",info.title,info.content];
             [contentArray addObject:cell.contentLabel.text];
        }
        if (info.unread ==nil || [info.unread intValue]<1) {
            cell.angleIcon.hidden = YES;
        }else
        {
            cell.angleIcon.hidden =NO;
            if ([info.unread intValue]>=10) {
                cell.angleIcon.text =@"9+";
            }else
            {
                cell.angleIcon.text =info.unread;
            }
            
        }
       
        cell.timerLbael.text =info.create_time;
    }

    cell.photoIcon.image = [UIImage imageNamed:photoArray[indexPath.row]];
    cell.separatorInset = UIEdgeInsetsMake(0, -50, 0, 0);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_model !=nil) {
        if ([contentArray[indexPath.row] isEqualToString:@"暂无消息"]) {
            return;
        }else
        {
            NSArray *array=[NSArray arrayWithObjects:@"delivery",@"notify",@"account",@"confirm", nil];
            if (kOlderVersion > 2) {
                ClassificationMessageViewController *vc =[ClassificationMessageViewController new];
                
                NSArray *arrayName=[NSArray arrayWithObjects:@"物流消息",@"通知消息",@"资产消息",@"验证消息", nil];
                vc.type =array[indexPath.row];
                vc.typeName =arrayName[indexPath.row];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else {
                
                FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
                NSString *urlString =[NSString stringWithFormat:@"%@?ctl=uc_msg&act=cate&type=%@",
                                      API_LOTTERYOUT_URL,array[indexPath.row]];
                jumpModel.url =urlString;
                jumpModel.type = 0;
                jumpModel.isHideNavBar = YES;
                jumpModel.isHideTabBar = YES;
                [FWO2OJump didSelect:jumpModel];
            }
            
            

        }
    }
}
- (void)updateNetWork
{
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"uc_msg" forKey:@"ctl"];
     ShowIndicatorTextInView(self.view,@"");
    [_httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        HideIndicatorInView(self.view);
        if ([responseJson toInt:@"status"] ==1) {
            _model =[MessageModel mj_objectWithKeyValues:responseJson[@"data"]];
            [_myTableView reloadData];
        }
    } FailureBlock:^(NSError *error) {
        HideIndicatorInView(self.view);
        [[HUDHelper sharedInstance] tipMessage:kNetErrorMsg];
    }];
}
- (void)popNewView
{
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
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)noReadMessage
{
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"uc_msg" forKey:@"ctl"];
    [dic setObject:@"countNotRead" forKey:@"act"];
    [_httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] ==1) {
            pop.no_msg =[responseJson[@"count"] integerValue];
        }
    } FailureBlock:^(NSError *error) {
        [[HUDHelper sharedInstance] tipMessage:kNetErrorMsg];
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
    [self back];
    [self updateNetWork];
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
            self.tabBarController.selectedIndex =0;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        case 1:
            [self.navigationController pushViewController:[DiscoveryViewController new] animated:YES];
            break;
        case 2:
        {
            
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
            if (_comeCount==0) {
                self.tabBarController.selectedIndex =3;
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
            
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
