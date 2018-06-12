//
//  DiscoveryViewController.m
//  FanweO2O
//
//  Created by ycp on 16/11/23.
//  Copyright © 2016年 fanwe. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "MerchantSearchView.h"
#import "ActivityListVC.h"
#import "GroupBuyListVC.h"
#import "MallListVC.h"
#import "StoreListVC.h"
#import "MerchantSearchTextFieldView.h"
@interface DiscoveryViewController ()<MerchantSearchViewDelegate>
{
    MerchantSearchView * merView;
}
@end

@implementation DiscoveryViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    merView.isNil =YES;
    merView.isReload =YES;
    [self judgeIsComing];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)judgeIsComing
{
    NSArray *viewcontrollers=self.navigationController.viewControllers;
    if (viewcontrollers .count >1) {
        merView.isHidden =NO;
    }else
    {
        merView.isHidden =YES;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    [self hiddenNavigationToTbarBarAndBulidNewNavigation];
    
}
- (void)hiddenNavigationToTbarBarAndBulidNewNavigation
{
    merView = [[MerchantSearchView alloc] initSearchViewWithFrame:CGRectMake(0, 0,kScreenW, kScreenH) Parament:nil search:^(NSString *string) {
    }];
    merView.delegate = self;
    [self.view addSubview:merView];

    
   
    
}
- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)navToViewController:(int)VC andContent:(NSString*)content
{
    switch (VC) {
        case 1:
        {
            GroupBuyListVC *vc =[GroupBuyListVC new];
            vc.content =content;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            
            break;
        case 2:
        {
            MallListVC *vc =[MallListVC new];
            vc.content =content;
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
            break;
        case 3:
        {
            ActivityListVC *vc =[ActivityListVC new];
            vc.content =content;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 4:
        {
            StoreListVC *vc =[StoreListVC new];
            vc.content =content;
            [self.navigationController pushViewController:vc animated:YES];
            
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




@end
