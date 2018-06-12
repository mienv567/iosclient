//
//  searchMapVC.m
//  FanweO2O
//
//  Created by zzl on 2017/3/6.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "searchMapVC.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import "AddAddressCell.h"

@interface searchMapVC ()<BMKMapViewDelegate,BMKPoiSearchDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) BMKMapView *mitmap;


@end

@implementation searchMapVC
{
    BMKPoiSearch*   _poisearch;
    BOOL            _searching;
    
    NSMutableArray* _data;
    
    BMKPointAnnotation* _userloc;
    
    BMKGeoCodeSearch*   _geosearch;
    
    NSDate*             _dotime;
    
    NSString*           _nowcenterprov;
    NSString*           _nowcentercity;
    NSString*           _nowcenterdist;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mitmap.delegate = self;
    
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"选择地址";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"goback"] style:UIBarButtonItemStyleDone target:self action:@selector(leftClicked)];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:121/255.0f green:123/255.0f blue:135/255.0f alpha:1];
    
}
-(void)leftClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.mitmap.delegate = nil;
    _geosearch.delegate = nil;
    _poisearch.delegate = nil;
}
- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mitmap = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW*0.8f)];
    [self.mtopmapview insertSubview:self.mitmap atIndex:0];
    [self.mitmap setZoomLevel:16.0f];
    [self.mitmap setShowMapPoi:YES];
    
    _data = NSMutableArray.new;
    
    _poisearch = [[BMKPoiSearch alloc] init];
    _poisearch.delegate = self;
    
    [[GlobalVariables sharedInstance] startLocation];
    
    self.minputsearch.delegate = self;
    
    self.msearchwaper.layer.masksToBounds = YES;
    self.msearchwaper.layer.borderColor = [UIColor colorWithRed:197/255.0f green:196/255.0f blue:202/255.0f alpha:1.000]
.CGColor;
    self.msearchwaper.layer.borderWidth = 0.8;
    self.msearchwaper.layer.cornerRadius = 5;
    
    _userloc = [[BMKPointAnnotation alloc]init];
    _userloc.title = @"正在获取位置信息";
    _userloc.subtitle = @"正在获取位置信息";
    
    UINib* nib = [UINib nibWithNibName:@"AddAddressCell" bundle:nil];
    [self.mittab registerNib:nib forCellReuseIdentifier:@"cell"];
    self.mittab.delegate = self;
    self.mittab.dataSource = self;
    
    ShowIndicatorText(@"正在定位中...");
    [self performSelector:@selector(delayLoc) withObject:nil afterDelay:2];
    
}

- (void)delayLoc
{
    HideIndicator();
    
    CLLocationCoordinate2D ll;
    ll.latitude = [GlobalVariables sharedInstance].latitude;
    ll.longitude = [GlobalVariables sharedInstance].longitude;
    
    if( ll.latitude == 0.0f && ll.longitude == 0.0f )
    {
        [[HUDHelper sharedInstance] tipMessage:@"定位失败,请稍后再试"];
        return;
    }
    
    [self.mitmap setCenterCoordinate:ll  animated:YES];
    _userloc.coordinate = ll;
    [self reUserLocToAddr];
}

-(void)reUserLocToAddr
{
    
    ShowIndicatorText(@"正在获取位置信息...");
    if( _geosearch == nil )
    {
        _geosearch = [[BMKGeoCodeSearch alloc]init];
        _geosearch.delegate = self;
    }
    
    BMKReverseGeoCodeOption *rever = [[BMKReverseGeoCodeOption alloc]init];
    rever.reverseGeoPoint = _userloc.coordinate;
    _userloc.title = @"正在获取位置信息";
    _userloc.subtitle = @"正在获取位置信息";
    
    [_geosearch reverseGeoCode:rever];
    
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    HideIndicator();
    if( error == BMK_SEARCH_NO_ERROR )
    {
        _nowcenterprov = result.addressDetail.province;
        _nowcentercity = result.addressDetail.city;
        _nowcenterdist = result.addressDetail.district;
        
        _userloc.title = result.sematicDescription;
        _userloc.subtitle = result.address;
        [self addAnInfo:result.poiList];
    }
    else
    {
        _userloc.title = @"获取位置信息失败";
        _userloc.subtitle = @"获取位置信息失败";
        [[HUDHelper sharedInstance] tipMessage:@"获取地址新失败,请稍后再试"];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if( textField.text.length == 0 )
    {
        [[HUDHelper sharedInstance] tipMessage:@"请先输入搜索关键字"];
        return NO;
    }
    
    [self searchNearby:_userloc.coordinate keywords:textField.text];
    [textField resignFirstResponder];
    
    return YES;
}


- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ( [annotation isKindOfClass:[BMKPointAnnotation class]] ) {
        
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"itan"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    CLLocationCoordinate2D ll = mapView.centerCoordinate;
    double difx = ll.latitude - _userloc.coordinate.latitude;
    double dify = ll.longitude - _userloc.coordinate.longitude;
    
    if( fabs(difx) < 0.0001 && fabs(dify) < 0.0001 )
    {
        return ;
    }
    
    _userloc.coordinate = ll;
    [self reUserLocToAddr];
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    if( self.mItBlock )
    {
        NSString* retadd = [view.annotation subtitle];
        
        if( _nowcenterprov.length )
            retadd = [retadd stringByReplacingOccurrencesOfString:_nowcenterprov withString:@""];
        if( _nowcentercity.length )
            retadd = [retadd stringByReplacingOccurrencesOfString:_nowcentercity withString:@""];
        if( _nowcenterdist.length )
            retadd = [retadd stringByReplacingOccurrencesOfString:_nowcenterdist withString:@""];
        
        
        self.mItBlock( [view.annotation title],retadd,[view.annotation coordinate] );
        [self leftClicked];
    }
}

- (void)searchNearby:(CLLocationCoordinate2D)loc keywords:(NSString*)keywords{
    if( _searching ) return;
    
    _searching = YES;
    ShowIndicatorText(@"正在搜索...");
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 50;
    option.location = loc;
    option.keyword = keywords;
    BOOL flag = [_poisearch poiSearchNearBy:option];
    if( !flag )
    {
        HideIndicator();
        _searching = NO;
        [[HUDHelper sharedInstance] tipMessage:@"搜索位置信息失败"];
    }
}
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
      _searching = NO;
    if( errorCode == BMK_SEARCH_NO_ERROR )
    {
        HideIndicator();
   
        [self addAnInfo:poiResult.poiInfoList];
        
    }
    else {
        
        HideIndicator();

        [[HUDHelper sharedInstance] tipMessage:@"搜索位置信息失败"];
    }
}
-(void)addAnInfo:(NSArray*)allinfo
{
    
    [self.mitmap removeAnnotations:_data];
    [_data removeAllObjects];
    
    for( BMKPoiInfo * one in  allinfo )
    {
        BMKPointAnnotation * itone = [[BMKPointAnnotation alloc]init];
        itone.coordinate = one.pt;
        itone.title = one.name;
        itone.subtitle = one.address;
        [_data addObject: itone];
    }
    
    _dotime = [NSDate date];
    
    [self.mitmap addAnnotations:_data];
    //[self.mitmap showAnnotations:_data animated:YES];
    [self.mittab reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count+1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddAddressCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BMKPointAnnotation* one = nil;
    if( indexPath.row == 0 )
    {
        one = _userloc;
        cell.mTitle.textColor = [UIColor redColor];
    }
    else
    {
        one = _data[ indexPath.row - 1 ];
        cell.mTitle.textColor = [UIColor colorWithRed:75/255.0f green:82/255.0f blue:93/255.0f alpha:1];
    }
    
    if( indexPath.row == 0 )
    {
        cell.mTitle.text = [NSString stringWithFormat:@"[当前]%@",one.title];
    }
    else
        cell.mTitle.text = one.title;
    
    cell.mAddress.text = one.subtitle;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BMKPointAnnotation* one = nil;
    if( indexPath.row == 0 )
    {
        one = _userloc;
    }
    else
    {
        one = _data[ indexPath.row - 1 ];
    }
    
    if( self.mItBlock )
    {
        NSString* retadd = [one subtitle];
        
        if( _nowcenterprov.length )
            retadd = [retadd stringByReplacingOccurrencesOfString:_nowcenterprov withString:@""];
        if( _nowcentercity.length )
            retadd = [retadd stringByReplacingOccurrencesOfString:_nowcentercity withString:@""];
        if( _nowcenterdist.length )
            retadd = [retadd stringByReplacingOccurrencesOfString:_nowcenterdist withString:@""];
        
        self.mItBlock( [one title],retadd,[one coordinate] );
        [self leftClicked];
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
