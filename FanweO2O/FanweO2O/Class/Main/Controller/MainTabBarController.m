//
//  MainTabBarController.m
//  FanweO2O
//
//  Created by ycp on 16/11/24.
//  Copyright © 2016年 fanwe. All rights reserved.
//

#import "MainTabBarController.h"
#import "HomeViewController.h"
#import "DiscoveryViewController.h"
#import "ShoppingViewController.h"
#import "MyViewController.h"
#import "BaseNavigationController.h"
#import "MyCenterViewController.h"
@interface MainTabBarController ()<UITabBarDelegate>

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //去除tabbar的横线
    [self.tabBar setClipsToBounds:NO];
    [self bulidTabBarController];
    
}
- (void)bulidTabBarController
{
    [self setupChildViewController:@"首页" viewController:[HomeViewController new] image:@"first_normal" selectedImage:@"first_selected"];
    
    [self setupChildViewController:@"分类" viewController:[[UIViewController alloc] init] image:@"category" selectedImage:@"category_selected"];
    
    DiscoveryViewController *vc =[DiscoveryViewController new];
    [self setupChildViewController:@"发现" viewController:vc image:@"second_normal" selectedImage:@"second_selected"];
    
    ShoppingViewController *shop = [ShoppingViewController webControlerWithUrlString:nil andNavTitle:nil isShowIndicator:NO isHideNavBar:YES isHideTabBar:NO];
    [self setupChildViewController:@"订单" viewController:shop image:@"third_normal" selectedImage:@"third_selected"];
    if (kOlderVersion == 1) {
        MyViewController *myVC = [MyViewController webControlerWithUrlString:nil andNavTitle:nil isShowIndicator:NO isHideNavBar:YES isHideTabBar:NO];
        [self setupChildViewController:@"我的" viewController:myVC image:@"four_normal" selectedImage:@"four_selected"];
    } else {
       [self setupChildViewController:@"我的" viewController:[MyCenterViewController new] image:@"four_normal" selectedImage:@"four_selected"];
    }
    
}

- (void)setupChildViewController:(NSString *)title viewController:(UIViewController *)controller image:(NSString *)image selectedImage:(NSString *)selectedImage {
    UITabBarItem *item = [[UITabBarItem alloc]init];
    item.image = [[UIImage imageNamed:image]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [[UIImage imageNamed:selectedImage]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.title = title;
    [item setTitlePositionAdjustment:UIOffsetMake(0, -5)];
    controller.tabBarItem = item;
    BaseNavigationController *navController = [[BaseNavigationController alloc]initWithRootViewController:controller];
    //传图片名字
    navController.imageName =@"goback";
   
    [self addChildViewController:navController];
    
}


//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
//{
//    //获得选中的item
//    NSUInteger tabIndex = [tabBar.items indexOfObject:item];
//    /*
//    if (tabIndex == 3) {
//        MyViewController *myVC = [MyViewController webControlerWithUrlString:nil andNavTitle:nil isShowIndicator:NO isHideNavBar:YES isHideTabBar:YES];
//        [[AppDelegate sharedAppDelegate] pushViewController:myVC];
//
//    }*/
//    if (tabIndex != self.selectedIndex) {
//        //设置最近一次变更
//        _lastSekectdIndex = self.selectedIndex;
//        NSUserDefaults *user =[NSUserDefaults standardUserDefaults];
//        [user setInteger:_lastSekectdIndex forKey:@"tabBarItemCount"];
//        [user synchronize];
//    }
//}





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
