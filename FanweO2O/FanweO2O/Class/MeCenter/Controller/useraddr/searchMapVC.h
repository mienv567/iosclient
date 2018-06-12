//
//  searchMapVC.h
//  FanweO2O
//
//  Created by zzl on 2017/3/6.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
 
@interface searchMapVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *minputsearch;
@property (weak, nonatomic) IBOutlet UITableView *mittab;
@property (weak, nonatomic) IBOutlet UIView *mtopmapview;

@property (weak, nonatomic) IBOutlet UIView *msearchwaper;


@property (nonatomic,strong)    void(^mItBlock)(NSString* name,NSString*addr,CLLocationCoordinate2D ll);

@end
