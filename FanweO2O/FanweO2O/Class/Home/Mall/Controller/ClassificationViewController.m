//
//  ClassificationCollectionViewController.m
//  FanweO2O
//
//  Created by ycp on 16/12/12.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ClassificationViewController.h"
#import "ClassificationCollectionViewCell.h"
#import "LeftTableViewCell.h"
#import "CustomTitleView.h"
#import "NetHttpsManager.h"
#import "ClassificationModelFirst.h"
#import "ClassificationModelSecond.h"
#import "DiscoveryViewController.h"
#import "FWO2OJumpModel.h"
#import "FWO2OJump.h"
#import "HomeViewController.h"
#import "MallListVC.h"

#import "SecondaryNavigationBarView.h"
#import "PopView.h"
#import "MessageCenterViewController.h"
#import "ShoppingViewController.h"
#import "DiscoveryViewController.h"
#import "O2OAccountLoginVC.h"
#import "RightLittleButtonOnBottom.h"
@interface ClassificationViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CustomTitleViewDelegate,PopViewDelegate,RightLittleButtonOnBottomDelegate,SecondaryNavigationBarViewDelegate>
{
    NSMutableArray  *_dateArray;
    PopView *pop;
    SecondaryNavigationBarView *nav;
}

@property (nonatomic,strong) UICollectionView *rightCollectionView;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) NSArray *myData;
@property (nonatomic,assign) NSInteger selectedIndex;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) BOOL isRelate;
@property (nonatomic,strong) CustomTitleView *customView;
@property (nonatomic,strong)NetHttpsManager *manager;
@property (nonatomic,strong)GlobalVariables *fanweApp;
@end

static NSString * const reuseIdentifier = @"CollectionCell";
static NSString * const leftTableViewIdentifier =@"LeftCell";
@implementation ClassificationViewController




- (UITableView *)leftTableView
{
    if (_tableView ==nil) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 64, 82, kScreenH-64) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor =[UIColor whiteColor];
        _tableView.delegate=self;
        _tableView.dataSource =self;
        _tableView.rowHeight =44;
        [_tableView registerClass:[LeftTableViewCell class] forCellReuseIdentifier:leftTableViewIdentifier];
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}
- (UICollectionView *)CollectionView
{
    if (!_rightCollectionView) {
        UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc] init];
//        flowLayout.sectionInset =UIEdgeInsetsMake(5, 5, 5, 5);
        //左右间距
        flowLayout.minimumInteritemSpacing = 5;
        //上下间距
        flowLayout.minimumLineSpacing = 5;

        flowLayout.sectionInset =UIEdgeInsetsMake(5, 5, 5, 5);
        flowLayout.scrollDirection =UICollectionViewScrollDirectionVertical;
        _rightCollectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(82, 64, kScreenW-82, kScreenH-64) collectionViewLayout:flowLayout];
        _rightCollectionView.backgroundColor =[UIColor grayColor];
        _rightCollectionView.delegate =self;
        _rightCollectionView.dataSource =self;
        _rightCollectionView.backgroundColor =[UIColor colorWithRed:0.900 green:0.900 blue:0.900 alpha:1.00];
        [self.view addSubview:_rightCollectionView];
        [_rightCollectionView registerNib:[UINib nibWithNibName:@"ClassificationCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    }
    return _rightCollectionView;
}
- (UIView *)customNavView
{
    if (!nav) {
        nav =[SecondaryNavigationBarView EditNibFromXib];
        nav.frame =CGRectMake(0, 20, kScreenW, 44);
        nav.delegate =self;
        nav.searchText =nil;
        nav.isTitleOrSearch =NO;
        [self.view addSubview:nav];
    }
    return nav;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden =YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     HideIndicatorInView(self.view);
    self.navigationController.navigationBar.hidden =NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    _selectedIndex =0;
    _isRelate =YES;
    _manager =[NetHttpsManager manager];
    _dateArray =[NSMutableArray new];
    _fanweApp =[GlobalVariables sharedInstance];
    [self updateDate];
    [self leftTableView];
    [self CollectionView];
    [self customNavView];
    
    pop =[[PopView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    pop.alpha =0.0;
    pop.delegate =self;
    [self.view bringSubviewToFront:pop];
    [self.view addSubview:pop];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dateArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LeftTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:leftTableViewIdentifier forIndexPath:indexPath];
    if (_dateArray.count !=0) {
        ClassificationModelFirst *modelFirst =[_dateArray objectAtIndex:indexPath.row];
        cell.name.text =modelFirst.name;
        
    }
    
    return cell;
}
// tableview cell 选中
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    _selectedIndex =indexPath.row;
    [_rightCollectionView scrollRectToVisible:CGRectMake(0, 0, self.rightCollectionView.frame.size.width, self.rightCollectionView.frame.size.height) animated:YES];
    
    [_rightCollectionView reloadData];
    
}

#pragma mark------CollectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (_dateArray.count !=0) {
        ClassificationModelFirst *a = [_dateArray objectAtIndex:_selectedIndex];
        return [a.bcate_type count];

    }
    return 0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ClassificationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    ClassificationModelFirst *a = [_dateArray objectAtIndex:_selectedIndex];
    ClassificationModelSecond *b = a.bcate_type[indexPath.row];
    cell.collectionLabel.text =b.name;
    if ([b.cate_img isEqualToString:@""]) {
        cell.collectionImageView.image =[UIImage imageNamed:@"no_pic"];
    }else
    {
        [cell.collectionImageView sd_setImageWithURL:[NSURL URLWithString:b.cate_img]];
    }
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"%ld,%ld",indexPath.section,indexPath.row);
    ClassificationModelFirst *a = [_dateArray objectAtIndex:_selectedIndex];
    ClassificationModelSecond *b = a.bcate_type[indexPath.row];
    MallListVC *vc = [MallListVC new];
    vc.haselect = YES;
    vc.selectpid = [a.id integerValue];
    vc.selectLevelPid =[b.id integerValue];
    NSLog(@"------------>>>>%@",a.id);
    [[AppDelegate sharedAppDelegate] pushViewController:vc];
//    FWO2OJumpModel *jump = [FWO2OJumpModel new];
//    jump.type = 0;
//    jump.url = b.app_url;
//    jump.isHideNavBar = YES;
//    jump.isHideTabBar = YES;
//    [FWO2OJump didSelect:jump];
  
}

- (void)updateDate
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"cate" forKey:@"ctl"];
    ShowIndicatorTextInView(self.view,@"");
    [_manager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
        HideIndicatorInView(self.view);
        if ([responseJson toInt:@"status"] ==1) {
            [_dateArray removeAllObjects];
            NSArray *dic = responseJson[@"bcate_list"];
            for (NSDictionary *str in dic) {
                ClassificationModelFirst *modelFirst =[ClassificationModelFirst mj_objectWithKeyValues:str];
                [_dateArray addObject:modelFirst];
            }
            
            [_tableView reloadData];
            [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            [_rightCollectionView reloadData];
        }
        
    } FailureBlock:^(NSError *error) {
         HideIndicatorInView(self.view);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----CustomTitleViewDelegate
- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBtn
{
    DiscoveryViewController *dv =[DiscoveryViewController new];

    [self.navigationController pushViewController:dv animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width=(self.view.bounds.size.width-20-82)/3;
    return CGSizeMake(width, width+30);
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
- (void)goToDiscovery
{
     [self.navigationController pushViewController:[DiscoveryViewController new] animated:YES];
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
    
    [_manager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        
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
    [self updateDate];
    
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
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[HomeViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
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
            self.tabBarController.selectedIndex =3;
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[HomeViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
            break;
        default:
            break;
    }
}

@end
