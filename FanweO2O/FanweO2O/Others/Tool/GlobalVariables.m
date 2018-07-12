//
//  GlobalVariables.m
//  FanweApp
//
//  Created by mac on 16/2/15.
//  Copyright © 2016年 xfg. All rights reserved.
//
#import "GlobalVariables.h"
#import "DB.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKGeoCodeSearch.h>

#define O2O_LOCATION_LIMITS     @"_o2o_location_limits_"

@interface GlobalVariables ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKGeneralDelegate> {
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_search;
    BMKMapManager *_mapManager;
    NSMutableString *strCity;
}

@end

@implementation GlobalVariables

+ (GlobalVariables *)sharedInstance
{
    static GlobalVariables *myInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        myInstance = [[self alloc] init];

        AppModel *appModel = [[AppModel alloc]init];
        myInstance.appModel = appModel;
        
        [myInstance mapInit];
    });
    return myInstance;
}

- (void)mapInit {
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];

    BOOL ret = [_mapManager start:BaiMapKey  generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    
    //百度地图定位
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    
    
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    
    
    
    
    
    //[_locService stopUserLocationService];
    
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    self.latitude = userLocation.location.coordinate.latitude;
    
    self.longitude = userLocation.location.coordinate.longitude;
    
    [_locService stopUserLocationService];

    _search = [[BMKGeoCodeSearch alloc]init];
    _search.delegate = self;
    BMKReverseGeoCodeOption *rever = [[BMKReverseGeoCodeOption alloc]init];
    rever.reverseGeoPoint = userLocation.location.coordinate;
    //这段代码不要删
    BOOL flag = [_search reverseGeoCode:rever];
    if(flag)
    {
      NSLog(@"反geo检索发送成功");
    }
    else
    {
      NSLog(@"反geo检索发送失败");
    }
    NSLog(@"heading is %@",userLocation.heading);
    

}

#pragma mark GeoCodeResult 返回地理位置
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
        if (result.addressDetail.city != nil) {
            strCity = [[NSMutableString alloc] initWithString:result.addressDetail.city];
            
            NSRange  range = [strCity rangeOfString:@"市"];
            
            if (range.location != NSNotFound) {
                [strCity deleteCharactersInRange:range];
                self.city = strCity;
                self.locateName = result.address;
                self.province = result.addressDetail.province;
                NSLog(@"%@== %@",result.addressDetail.city, result.address);
                
                for (City *city in self.O2OConfig.citylist) {
                    if ([city.name isEqualToString:strCity]) {
                        [[NSUserDefaults standardUserDefaults] setObject:city.id forKey:@"city_id"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                    }
                }
                
                [self performSelector:@selector(delayCity) withObject:nil afterDelay:1.0];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:FW_O2O_LOCATION_SUCCESS
                                                                object:nil
                                                              userInfo:nil];
        }
    
}

- (void)delayCity
{
    [self promptBox];
}
//提示框
- (void)promptBox
{
    if (self.city != nil) {
        
        BOOL isbool =NO;
        City *city;
        for (city in self.O2OConfig.citylist) {
            NSLog(@"---->%@",city.name);
            if ([city.name isEqualToString:strCity]) {
                if ([self.city_name isEqualToString:strCity]) {
                    return;
                }else
                {
                    isbool =YES;
                    
                }
            }
        }
        if ( isbool ==YES) {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示:" message:[NSString stringWithFormat:@"系统定位到您在%@,需要切换至%@吗?",strCity,strCity] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 10001) {
        
        if (buttonIndex == 1) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        
    }else {
        if (buttonIndex ==0) {
            return;
        }else
        {
            self.city_name = strCity;
            //        NSString *firstName = [[NSUserDefaults standardUserDefaults] objectForKey:@"city_id"];
            self.city_id =[[[NSUserDefaults standardUserDefaults] objectForKey:@"city_id"] integerValue];
            [[NSNotificationCenter defaultCenter] postNotificationName:FW_O2O_MYWEBVIEW_CHANGE_CITY
                                                                object:nil                                                          userInfo:nil];
            
        }

    }
    
   
}

//判断是否为整形：
- (BOOL)isPureInt:(NSString*) string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt: &val] && [scan isAtEnd];
}

-(NSString *) toValue:(NSString *) value{
    if ( [value isKindOfClass:[NSNull class]] || value == NULL){
        return @"";
        //return;
    }
    @try {
        if ([self isPureInt:value]){
            return value;//[NSString stringWithFormat:@"%d",  [youhui comment_count]]
        }else{
            @try {
                if (!value || value == nil ||![value respondsToSelector:@selector(length)] || [value length] == 0){
                    return @"";
                }else {
                    return value;
                }
            } @catch (NSException* e) {
                return @"";
            }  
        }
    } @catch (NSException* e) {
        return @"";        
    }
}

- (void)startLocation {
    
    
    
    if ([self initCLLocationManager]) {
        [_locService startUserLocationService];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:FW_O2O_LOCATION_SUCCESS
                                                            object:nil
                                                          userInfo:nil];
    }
    
    
}


- (BOOL)initCLLocationManager
{
    
    BOOL enable = [CLLocationManager locationServicesEnabled];
    NSInteger status=[CLLocationManager authorizationStatus];
    if(!enable || status<3)
    {
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8)
        {
            CLLocationManager  *locationManager = [[CLLocationManager alloc] init];
            [locationManager requestAlwaysAuthorization];
            [locationManager requestWhenInUseAuthorization];
        }
        
        BOOL hsInit = [[NSUserDefaults standardUserDefaults] objectForKey:O2O_LOCATION_LIMITS];
        
        if (hsInit) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"定位服务未开启"
                                                                message:@"请进入系统［设置］> [隐私] > [定位服务]中打开开关，并允许使用定位服务"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"取消",@"立即开启", nil];
            alertView.tag = 10001;
            [alertView show];
            enable = NO;

        }else {
            
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:O2O_LOCATION_LIMITS];
        }
        
        
    }
    
    return enable;
}



@end




