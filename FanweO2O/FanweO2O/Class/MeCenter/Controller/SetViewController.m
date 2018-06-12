//
//  SetViewController.m
//  FanweO2O
//
//  Created by ycp on 17/1/4.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "SetViewController.h"
#import "SetButtonTableViewCell.h"
#import "GlobalVariables.h"
#import "NetHttpsManager.h"
#import "SetModel.h"
#import "SetFristTableViewCell.h"

#import "PopView.h"
#import "MessageCenterViewController.h"
#import "ShoppingViewController.h"
#import "DiscoveryViewController.h"
#import "O2OAccountLoginVC.h"
#import "SecondaryNavigationBarView.h"
#import "AbountUsViewController.h"
#import "XNSDKCore.h"
@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource,SetButtonTableViewCellDelegate,PopViewDelegate,SecondaryNavigationBarViewDelegate,UIAlertViewDelegate>
{
    UITableView *_myTableView;
    NSMutableArray *_labelArray;
    NSMutableArray *_datailArray;
    NSInteger   sectionCount;
    GlobalVariables *_fanweApp;
    NetHttpsManager *_httpManager;
    NSArray *modelArray;
    SetModel *_rowModel;
    
    SecondaryNavigationBarView *nav;
    PopView *pop;
    
   
    CGFloat cacheSize;
    
}
@end

@implementation SetViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden =YES;
     self.view.backgroundColor =[UIColor whiteColor];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden =NO;
     HideIndicatorInView(self.view);
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _fanweApp =[GlobalVariables sharedInstance];
    _httpManager =[NetHttpsManager manager];
    
     [self bulidNav];
    _labelArray =[NSMutableArray arrayWithObjects:@"当前版本",@"清除缓存",@"客服电话",@"客服邮箱", nil];
    [self bulidTableView];
    [self updateNetWork];
    [_myTableView registerClass:[SetFristTableViewCell class] forCellReuseIdentifier:@"firstCell"];
    
    [_myTableView registerClass:[SetButtonTableViewCell class] forCellReuseIdentifier:@"setCell"];
    
    
}



- (void)bulidNav
{
    nav =[SecondaryNavigationBarView EditNibFromXib];
    nav.frame =CGRectMake(0, 20, kScreenW, 44);
    nav.delegate =self;
    nav.searchText =@"设置";
    nav.isTitleOrSearch =YES;
    [self.view addSubview:nav];
    
}
-(void)bulidTableView
{
    _myTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH-64) style:UITableViewStylePlain];
    _myTableView.scrollEnabled =NO;
    _myTableView.backgroundColor =kGaryGroundColor;
    _myTableView.delegate =self;
    _myTableView.dataSource =self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    sectionCount =2;
    [self.view addSubview:_myTableView];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [_myTableView setTableFooterView:v];
    
    pop =[[PopView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    pop.alpha =0.0;
    pop.delegate =self;
    [self.view bringSubviewToFront:pop];
    [self.view addSubview:pop];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section ==0) {
        return _labelArray.count;
    }else
    {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (sectionCount ==2) {
        return 2;
    }else
    {
        return 3;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return 0;
    }else if (section ==1){
        return 0;
    }
    else
    {
        return 10;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        SetFristTableViewCell *cell =[[SetFristTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"firstCell"];
        cell.textLabel.text = _labelArray[indexPath.row];
        if (indexPath.row ==1) {
            cell.detailTextLabel.text =[NSString stringWithFormat:@"%.0f M",[self filePath]];
        }
        if (_rowModel!=nil) {
            
            if (indexPath.row == 0) {
                
                UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(lpGR:)];
                
                //设定最小的长按时间 按不够这个时间不响应手势
                
                longPressGR.minimumPressDuration = 1;
                
                [cell addGestureRecognizer:longPressGR];
                
            cell.detailTextLabel.text = _rowModel.DB_VERSION;
            }else if (indexPath.row == 2) {
             cell.detailTextLabel.text = _rowModel.SHOP_TEL;
            }else if (indexPath.row == 3) {
            cell.detailTextLabel.text = _rowModel.REPLY_ADDRESS;
            }
        }
        return cell;
 
    }else if (indexPath.section ==1){
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"secondCell"];
        if (cell ==nil) {
            cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"secondCell"];
            cell.textLabel.font = KAppTextFont13;
            cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text =@"关于我们";
        return cell;
    }
    else
    {
        SetButtonTableViewCell *cell =[[SetButtonTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"setCell"];
        cell.delegate =self;
        cell.separatorInset =UIEdgeInsetsMake(0, kScreenW, 0, 0);
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==1) {
        AbountUsViewController *vc =[AbountUsViewController new];
        UINavigationController *my =[[UINavigationController alloc] initWithRootViewController:vc];
        vc.htmlContent =_rowModel.APP_ABOUT_US;
        [self presentViewController:my animated:YES completion:nil];
    }else if(indexPath.section ==0){
        if (indexPath.row ==1) {
            if ([self filePath] <=0.99) {
                return;
            }else
            {
                if ([[UIDevice currentDevice].systemVersion floatValue] >=8.0) {
                    UIAlertController *alertController =[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定要清除缓存吗?" preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        return ;
                    }]];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self clearFile];
                    }]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self presentViewController: alertController animated: YES completion: nil];
                    });
                    
                }else
                {
                    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定要清除缓存吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alert show];
                }
            
            }
            
            
            
        }
        
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==0) {
        return;
    }else
    {
        [self clearFile];
    }
}
- (void)updateNetWork
{
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"setting" forKey:@"ctl"];
    if (_fanweApp.session_id ==nil) {
        [dic setObject:@"" forKey:@"session_id"];
    }else{
        [dic setObject:_fanweApp.session_id forKey:@"session_id"];
    }
    ShowIndicatorTextInView(self.view,@"");
    [_httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        
       HideIndicatorInView(self.view);
        
        if ([responseJson toInt:@"status"] ==1) {
            _user_login_status =[responseJson[@"user_login_status"] intValue];
            _rowModel =[SetModel mj_objectWithKeyValues:responseJson];
            
            if (_user_login_status ==1) {
                sectionCount =3;
            }else{
                sectionCount =2;
            }
            [_myTableView reloadData];
        }
        
    } FailureBlock:^(NSError *error) {
        HideIndicatorInView(self.view);
        [[HUDHelper sharedInstance] tipMessage:kNetErrorMsg];
    }];
    
}
- (void)loginOutEnd
{
    NSMutableDictionary *Parameters = [NSMutableDictionary new];
    [Parameters setObject:@"loginout" forKey:@"act"];
    [Parameters setObject:@"user" forKey:@"ctl"];
       ShowIndicatorTextInView(self.view,@"");
    [_httpManager POSTWithParameters:Parameters SuccessBlock:^(NSDictionary *responseJson) {
        HideIndicatorInView(self.view);
        if ([responseJson[@"status"] integerValue] == 1) {
            self.fanweApp.user_id = @"";
            self.fanweApp.user_email = @"";
            self.fanweApp.user_name = @"";
            self.fanweApp.user_mobile = @"";
            self.fanweApp.user_pwd = @"";
            self.fanweApp.session_id = @"";
            self.fanweApp.is_login =NO;
            [[XNSDKCore sharedInstance] logout];
            [self.navigationController popViewControllerAnimated:YES];
        }
        [[HUDHelper sharedInstance] tipMessage:responseJson[@"info"]];
        
    } FailureBlock:^(NSError *error) {
      HideIndicatorInView(self.view);
        [[HUDHelper sharedInstance] tipMessage:kNetErrorMsg];
    }];
}
- (void)popNewView
{
    [self noReadMessage];
    [UIView animateWithDuration:0.1 animations:^{
        pop.alpha =1.0;
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
             self.tabBarController.selectedIndex =0;
            [self.navigationController popViewControllerAnimated:YES];
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
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            break;
    }
}

// 显示缓存大小
-( float )filePath
{
    
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    return [ self folderSizeAtPath :cachPath];
    
}
//1:首先我们计算一下 单个文件的大小

- ( long long ) fileSizeAtPath:( NSString *) filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    
    return 0 ;
    
}
//2:遍历文件夹获得文件夹大小，返回多少 M（提示：你可以在工程界设置（)m）

- ( float ) folderSizeAtPath:( NSString *) folderPath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    
    NSString * fileName;
    
    long long folderSize = 0 ;
    
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
        
    }
    
    return folderSize/( 1024.0 * 1024.0 );
    
}




// 清理缓存

- (void)clearFile
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    
    NSLog ( @"cachpath = %@" , cachPath);
    
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
            
        }
        
    }
    [_myTableView reloadData];

    
}

- (void)lpGR:(UILongPressGestureRecognizer *)lpGR
{
    //长按收拾
    
    if (lpGR.state == UIGestureRecognizerStateBegan)//手势结束
        
    {
        [HUDHelper alert:API_BASE_URL cancel:@"知道啦~"];
        
    }
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
