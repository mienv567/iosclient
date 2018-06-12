//
//  MyAddrVC.m
//  FanweO2O
//
//  Created by zzl on 2017/3/1.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MyAddrVC.h"
#import "addrCell.h"
#import "dataModel.h"
#import "SVProgressHUD.h"
#import "EditAddrVC.h"
#import "PopView.h"
#import "SecondaryNavigationBarView.h"
#import "MessageCenterViewController.h"
#import "ShoppingViewController.h"
#import "DiscoveryViewController.h"
#import "O2OAccountLoginVC.h"
#import "MyCenterViewController.h"
@interface MyAddrVC ()<UITableViewDelegate,UITableViewDataSource,addrCellProtocol,PopViewDelegate,SecondaryNavigationBarViewDelegate>
{
    SecondaryNavigationBarView *nav;
    PopView *pop;
}
@property (nonatomic, strong) NetHttpsManager *httpManager;
@end

@implementation MyAddrVC
{
    NSMutableArray* _mdata;
    OTOAddr*        _selecttoedit;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.httpManager =[NetHttpsManager manager];
    _mdata = NSMutableArray.new;
    
    self.mittab.separatorStyle  = UITableViewCellSeparatorStyleNone;
    
    self.mittab.delegate = self;
    self.mittab.dataSource = self;
    
    UINib* nib = [UINib nibWithNibName:@"addrCell" bundle: nil];
    [self.mittab registerNib:nib forCellReuseIdentifier:@"cell"];
    [self nav];
    [self popView];
    [self loadData];
}

- (void)popView{
    pop =[[PopView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    pop.alpha =0.0;
    pop.delegate =self;
    [self.view bringSubviewToFront:pop];
    [self.view addSubview:pop];
}
- (void)nav{
    nav =[SecondaryNavigationBarView EditNibFromXib];
    nav.frame =CGRectMake(0, 20, kScreenW, 44);
    nav.delegate =self;
    nav.searchText =@"我的收货地址";
    nav.isTitleOrSearch =YES;
    [_navView addSubview:nav];
}
-(void)loadData
{
    ShowIndicatorText(@"加载中...");
    [OTOAddr getAddrList:^(NSArray *all, SResBase *resb) {
        
        HideIndicator();
        
        if( resb.msuccess )
        {
            [_mdata removeAllObjects];
            [_mdata addObjectsFromArray:all];
            [self.mittab reloadData];
        }
        else
        {
            [[HUDHelper sharedInstance] tipMessage:resb.mmsg];
        }
        
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     self.navigationController.navigationBarHidden = NO;
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)popNewView
{
    [self.view bringSubviewToFront:pop];
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
    [self back];
    [self loadData];
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
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[MyCenterViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }
            break;
        case 1:
            [self.navigationController pushViewController:[DiscoveryViewController new] animated:YES];
            break;
        case 2:
        {
            
            [self.navigationController pushViewController:[MessageCenterViewController new] animated:YES];
            
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
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[MyCenterViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }
            break;
        default:
            break;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mdata.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    addrCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    OTOAddr* oneobj = [_mdata objectAtIndex:indexPath.row];
    cell.mname.text = oneobj.mConsignee;
    cell.mtel.text = oneobj.mMobile;
    cell.maddrdesc.text = oneobj.mFull_address;
    if( oneobj.mIs_default )
    {
        [cell.mdefaultbt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cell.mdefaultbt setImage:[UIImage imageNamed:@"ic_addr_gou"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.mdefaultbt setTitleColor:g_defcolor forState:UIControlStateNormal];
        [cell.mdefaultbt setImage:[UIImage imageNamed:@"ic_addr_nogou"] forState:UIControlStateNormal];
    }
    cell.mCellDelegate = self;
    cell.mDataRef = oneobj;
    return cell;
}

//clicked 表明那个被点击了,这个地址界面是 1:默认 2:编辑 3:删除
-(void)addrCellClicked:(NSObject*)dataref clicked:(int)clicked
{
    OTOAddr* oneobj = (OTOAddr*)dataref;
    
    if( clicked == 1 )
    {
        if( oneobj.mIs_default == 1 ) return;
        
        oneobj.mIs_default = oneobj.mIs_default == 1 ?0:1;
        
        ShowIndicatorText(@"操作中...");
        [oneobj changeDefault:^(SResBase *resb) {
            HideIndicator();

            if( resb.msuccess )
            {
                if( oneobj.mIs_default )
                {//如果点击之后是默认,就需要把之前的干掉
                    for( OTOAddr* one in _mdata )
                    {
                        if( one.mId != oneobj.mId ) one.mIs_default = 0;
                    }
                }
                [self.mittab reloadData];
            }
            else
            {
                [[HUDHelper sharedInstance] tipMessage:resb.mmsg];
            }
        }];
    }
    else if( clicked == 2 )
    {
        _selecttoedit = oneobj;
        EditAddrVC* vc = [[EditAddrVC alloc]initWithNibName:@"EditAddrVC" bundle:nil];
        vc.mEditTag = [oneobj copy];
        vc.mItBlock =  ^(int i,OTOAddr* obj){
          
            if( i )
            {
                [self loadData];
            }
            /*
             if( i == 1 )
             {
             if( obj.mIs_default && 0 == _selecttoedit.mIs_default )
             {//如果修改了是默认地址了,并且之前不是
             for( OTOAddr* onesss in _mdata )
             {
             onesss.mIs_default = 0;
             }
             }
             NSInteger index = [_mdata indexOfObject:obj];
             if( index != NSNotFound )
             [_mdata replaceObjectAtIndex:index withObject:obj];
             [self.mittab reloadData];
             }
             else if( i == 2 )
             {
             [self loadData];
             }
             */
            
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if( clicked == 3 )
    {
        ShowIndicatorText(@"删除中...");
        [oneobj delThisAddr:^(SResBase *resb) {
            
            HideIndicator();

            if( resb.msuccess )
            {
                NSInteger x = [_mdata indexOfObject:oneobj];
                [_mdata removeObject:oneobj];
                [self.mittab deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:x inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else
            {
                [[HUDHelper sharedInstance] tipMessage:resb.mmsg];
            }
            
        }];
    }
    
}
- (IBAction)addclicked:(id)sender {
    
    EditAddrVC* vc = [[EditAddrVC alloc]initWithNibName:@"EditAddrVC" bundle:nil];
    vc.mItBlock =  ^(int i,OTOAddr* obj){
        
        if( i )
        {
            [self loadData];
        }
        /*
        if( i == 1 )
        {
            if( obj.mIs_default && 0 == _selecttoedit.mIs_default )
            {//如果修改了是默认地址了,并且之前不是
                for( OTOAddr* onesss in _mdata )
                {
                    onesss.mIs_default = 0;
                }
            }
            NSInteger index = [_mdata indexOfObject:obj];
            if( index != NSNotFound )
                [_mdata replaceObjectAtIndex:index withObject:obj];
            [self.mittab reloadData];
        }
        else if( i == 2 )
        {
            [self loadData];
        }
        */
    };
    
    [self.navigationController pushViewController:vc animated:YES];
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
