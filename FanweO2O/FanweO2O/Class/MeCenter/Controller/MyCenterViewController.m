//
//  MyCenterViewController.m
//  FanweO2O
//
//  Created by ycp on 17/1/9.
//  Copyright © 2017年 xfg. All rights reserved.
//  我的控制器

#import "MyCenterViewController.h"
#import "GlobalVariables.h"
#import "O2OAccountLoginVC.h"
#import "LogInViewController.h"
#import "WXApi.h"
#import "MyCenterTopTableViewCell.h"
#import "MySectionTableViewCell.h"
#import "MyThirdSectionTableViewCell.h"
#import "MyFourTableViewCell.h"
#import "SetViewController.h"
#import "NetHttpsManager.h"
#import "MyCenterModel.h"
#import "MessageCenterViewController.h"
#import "AccountManagementViewController.h"
#import "BingdingPhoneTableViewCell.h"
#import "NewBindingPhoneViewController.h"
#import "NetHttpsManager.h"
#define iPhone6H 667
@interface MyCenterViewController ()<WXApiDelegate,UITableViewDelegate,UITableViewDataSource,MyCenterTopTableViewCellDelegate,MySectionTableViewCellDelegate,MyThirdSectionTableViewCellDelegate,MyFourTableViewCellDelegate,BingdingPhoneTableViewCellDelegate>
{
    UITableView *_myTableView;
    MyThirdSectionTableViewCell *thirdCell;
    GlobalVariables *_fanweApp;
    NetHttpsManager *_httpManager;
    MyCenterModel *_model;
    int _rowHight;
   
}
@end

@implementation MyCenterViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden =YES;
    [self updateNetwork];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden =NO;
   
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _fanweApp =[GlobalVariables sharedInstance];
    _httpManager =[NetHttpsManager manager];
    
    [self buildTableView];
    [_myTableView registerNib:[UINib nibWithNibName:@"MyCenterTopTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [_myTableView registerClass:[MySectionTableViewCell class] forCellReuseIdentifier:@"sectionCell"];
    [_myTableView registerClass:[MyThirdSectionTableViewCell class] forCellReuseIdentifier:@"thirdSectionCell"];
    [_myTableView registerClass:[MyFourTableViewCell class] forCellReuseIdentifier:@"fourSectionCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"BingdingPhoneTableViewCell" bundle:nil] forCellReuseIdentifier:@"bingCell"];
    //[self updateNetwork];
}
- (void)buildTableView
{
    _myTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
    _myTableView.delegate =self;
    _myTableView.dataSource =self;
    _myTableView.backgroundColor =kWhiteGatyGroundColor;
    _myTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    if (kScreenH>=iPhone6H) {
        _myTableView.scrollEnabled =NO;
    }
    [self.view addSubview:_myTableView];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_fanweApp.is_fx intValue] !=0) {
        return 5;
    }else
    {
        return 4;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 195;
    }else if(indexPath.section ==1){
        if (_rowHight !=0) {
            return _rowHight;
        }else
        {
            return 0;
        }
    }
    else if(indexPath.section ==2){
        return 115;
    }else if(indexPath.section ==3){
        return 132;
    }else if(indexPath.section ==4){
        if ([_model.is_user_fx isEqualToString:@"1"]) {
            return 111;
        }
        else
        {
            return 40;
        }
    }else
    {
        return 0;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==1) {
        return 0;
    }else if(section ==2){
        return 0;
    }else if (section ==3){
        return 10;
    }else if (section ==4){
        return 10;
    }
    else
    {
        return 0;
    }
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *view =[[UIView alloc] init];
    view.backgroundColor =kWhiteGatyGroundColor;
    return view;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        MyCenterTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.delegate =self;
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        if (_model !=nil) {
            cell.model =_model;
        }
        return cell;
    }else if(indexPath.section ==1){
        if (_rowHight !=0) {
            BingdingPhoneTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"bingCell"];
            if (!cell) {
                
                cell =[[BingdingPhoneTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bingCell"];
            }
            cell.delegate =self;
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else if(indexPath.section ==2){
        MySectionTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"sectionCell"];
        if (_model !=nil) {
            cell.model =_model;
        }
        cell.delegate =self;
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section ==3){
        thirdCell  =[tableView dequeueReusableCellWithIdentifier:@"thirdSectionCell"];
        thirdCell.selectionStyle =UITableViewCellSelectionStyleNone;
        if (_model !=nil) {
            thirdCell.model =_model;
        }
        thirdCell.delegate =self;
        return thirdCell;
    }else if(indexPath.section ==4){
        MyFourTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"fourSectionCell"];
        if (_model !=nil) {
            cell.model =_model;
        }
        cell.delegate =self;
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }
    UITableViewCell  *cell =[tableView dequeueReusableCellWithIdentifier:@"110"];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"110"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)updateNetwork
{
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"user_center" forKey:@"ctl"];
    [dic setObject:@"wap_index" forKey:@"act"];
    
    [_httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        //HideIndicatorInView(self.view);
        if ([responseJson toInt:@"status"] ==1) {
            _model = [MyCenterModel mj_objectWithKeyValues:responseJson];
            _fanweApp.vouchersName =_model.coupon_name;
            if (![_model.user_mobile_empty isEqualToString:@"1"]) {
                _rowHight =0;
            }else
            {
                _rowHight =30;
            }
            [_myTableView reloadData];
        }
        
        [GlobalVariables sharedInstance].is_login = [responseJson[@"user_login_status"] boolValue];
        
    } FailureBlock:^(NSError *error) {
         //HideIndicatorInView(self.view);
        [[HUDHelper sharedInstance] tipMessage:kNetErrorMsg];
    }];
     
}

#pragma mark ---------------------------------代理点击事件---------------------------------

- (void)set
{
    [self.navigationController pushViewController:[[SetViewController alloc] init] animated:YES];
    
}
- (void)messageView
{
    if ([_model.user_login_status isEqualToString:@"1"]) {
        MessageCenterViewController *vc = [MessageCenterViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        [self.navigationController pushViewController:[O2OAccountLoginVC new] animated:YES];
    }

}
- (void)nextToLogin
{
    [self.navigationController pushViewController:[O2OAccountLoginVC new] animated:YES];
}
- (void)loginView1
{
    [self.navigationController pushViewController:[O2OAccountLoginVC new] animated:YES];

}
- (void)loginView2
{
    [self.navigationController pushViewController:[O2OAccountLoginVC new] animated:YES];
}
- (void)loginOrRegister
{
    if ([_model.user_login_status isEqualToString:@"1"]) {
       
    }else
    {
//        [self.navigationController pushViewController:[O2OAccountLoginVC new] animated:YES];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[LogInViewController new] animated:YES completion:nil];
    }
    

}
- (void)loginUp
{
    if ([_model.user_login_status isEqualToString:@"1"]) {
        [self.navigationController pushViewController:[AccountManagementViewController new] animated:YES];
    }else
    {
        [self.navigationController pushViewController:[O2OAccountLoginVC new] animated:YES];
    }
}
- (void)close
{
    [UIView animateWithDuration:1 animations:^{
        _rowHight =0;
        [_myTableView reloadData];
    }];

}
- (void)bingPhoneClick
{
    [self.navigationController pushViewController:[NewBindingPhoneViewController new] animated:YES];

}
- (void)newBingPhone
{
     [self.navigationController pushViewController:[NewBindingPhoneViewController new] animated:YES];
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
