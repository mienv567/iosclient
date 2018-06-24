//
//  NetHttpsManager.m
//  AfDemo
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NetHttpsManager.h"
#import "AFNetworking.h"
#import "FanweMessage.h"
#import "ApiLinkModel.h"
#import "O2OAccountLoginVC.h"
#import "DataTool.h"
#define SavePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"user.archive"]

#define kOvertime 30     // 请求超时时间

@implementation NetHttpsManager
static id _httpsManager;
+(instancetype)manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _httpsManager =[[self alloc] init];
    });
    return _httpsManager;
}




#pragma mark 判断当前网络状态
+(BOOL)isExistenceNetwork
{
    BOOL isExistenceNetwork = YES;
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
            isExistenceNetwork = YES;
            break;
        case AFNetworkReachabilityStatusNotReachable:
            isExistenceNetwork = NO;
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
            
        default:
            break;
    }
    
    return isExistenceNetwork;
}

#pragma mark 异步请求
-(void)POSTWithParameters:(NSMutableDictionary *)parmDict SuccessBlock:(void (^)(NSDictionary * responseJson))PostSuccess FailureBlock:(void (^)(NSError *error))PostFailure
{
    GlobalVariables *fanweApp = [GlobalVariables sharedInstance];
    
    
    NSString *urlString = API_BASE_URL;

    if (parmDict == nil) {
        parmDict = [NSMutableDictionary new];
    }
    
    [parmDict setObject:@"1" forKey:@"r_type"];
    //[parmDict setObject:@"0" forKey:@"i_type"];
    [parmDict setObject:@"app" forKey:@"from"];
    if (fanweApp.latitude != 0 && fanweApp.longitude != 0) {
        [parmDict setObject:@(fanweApp.longitude) forKey:@"m_longitude"];
        [parmDict setObject:@(fanweApp.latitude) forKey:@"m_latitude"];
    }
    if (fanweApp.city_id != 0) {
        [parmDict setObject:@(fanweApp.city_id) forKey:@"city_id"];
    }
    if (fanweApp.session_id) {
        NSLog(@"%@",fanweApp.session_id);
        [parmDict setObject:fanweApp.session_id forKey:@"sess_id"];
    }
    [self POSTWithUrl:urlString parameters:parmDict SuccessBlock:PostSuccess FailureBlock:PostFailure];
}

#pragma mark 异步请求
-(void)POSTWithUrl:(NSString *)urlStr parameters:(NSMutableDictionary *)parmDict SuccessBlock:(void (^)(NSDictionary * responseJson))PostSuccess FailureBlock:(void (^)(NSError *error))PostFailure
{
    
    if (![NetHttpsManager isExistenceNetwork])
    {
        NSLog(@"请检查当前网络");
    }else{
        
        NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:kMyCookies];
        if([cookiesdata length]) {
            NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
            NSHTTPCookie *cookie;
            for (cookie in cookies) {
                if (![cookie.name isEqualToString:@""] && ![cookie.value isEqualToString:@""] ) {
                    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
                }
                
            }
        }
        

        
        [[DataTool shareDataTool] POST:urlStr parameters:parmDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSHTTPCookie *sessinCookie;
            NSHTTPCookieStorage *sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            NSArray *cookies = [sharedHTTPCookieStorage cookiesForURL:[NSURL URLWithString:urlStr]];
            NSEnumerator *enumerator = [cookies objectEnumerator];
            NSHTTPCookie *cookie;
            while (cookie = [enumerator nextObject]) {
                if (![cookie.name isEqualToString:@""] && ![cookie.value isEqualToString:@""])
                {
                    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
                    if ([cookie.name isEqualToString:@"PHPSESSID2"]) {
                        sessinCookie = cookie;
                    }
                }
            }
            
            
            NSDictionary *resposeJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if(1) {
                NSLog(@"\n \n/*******************************/ \n url = %@ \n dict = %@\n \n response = %@ \n /**************返回结果结束*****************/\n",urlStr,parmDict,resposeJson);
            }
            if (resposeJson) {
                if([resposeJson count]){
                    
                    if ([[resposeJson allKeys] containsObject:@"user_login_status"])
                    { //判断字典中是否含有这个key
                        if ([resposeJson toInt:@"user_login_status"] == 1) { //判断是否登录状态
                            if (PostSuccess!=nil) {
                                PostSuccess(resposeJson);
                            }
                            
                        }else{
                            //未登录
                            
//                            O2OAccountLoginVC *vc = [[O2OAccountLoginVC alloc] initWithNibName:@"O2OAccountLoginVC" bundle:nil];
//                            
//                            [[AppDelegate sharedAppDelegate] pushViewController:vc];
                            //[self.navigationController pushViewController:vc animated:YES];
                            
                            if (PostSuccess!=nil) {
                                PostSuccess(resposeJson);
                            }
                        }
                    }else{
                        if (PostSuccess!=nil) {
                            PostSuccess(resposeJson);
                        }
                    }
                    
                }else {
                    if (PostSuccess!=nil) {
                        PostSuccess(resposeJson);
                    }
                }
            }
//            else{
//                if (PostSuccess!=nil) {
//                    PostSuccess(resposeJson);
//                }
//            }

            
            //NSLog(@"========================resposeJson:%@",resposeJson);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            DebugLog(@"%@",error);
            if (PostFailure!=nil) {
                PostFailure(error);
            }
        }];
//        [manager POST:urlStr parameters:parmDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSHTTPCookie *sessinCookie;
//            NSHTTPCookieStorage *sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//            NSArray *cookies = [sharedHTTPCookieStorage cookiesForURL:[NSURL URLWithString:urlStr]];
//            NSEnumerator *enumerator = [cookies objectEnumerator];
//            NSHTTPCookie *cookie;
//            while (cookie = [enumerator nextObject]) {
//                if (![cookie.name isEqualToString:@""] && ![cookie.value isEqualToString:@""])
//                {
//                    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//                    if ([cookie.name isEqualToString:@"PHPSESSID2"]) {
//                        sessinCookie = cookie;
//                    }
//                }
//            }
//            
//            NSDictionary *resposeJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//            //            NSLog(@"========================resposeJson:%@",resposeJson);
//            
//            if (resposeJson) {
//                if([resposeJson count]){
//                    if ([[resposeJson allKeys] containsObject:@"user_login_status"])
//                    { //判断字典中是否含有这个key
//                        if ([resposeJson toInt:@"user_login_status"] == 1) { //判断是否登录状态
//                            if (PostSuccess!=nil) {
//                                PostSuccess(resposeJson);
//                            }
//                        }else{
//                            
//                        }
//                    }else{
//                        if (PostSuccess!=nil) {
//                            PostSuccess(resposeJson);
//                        }
//                    }
//                }
//            }else{
//                if (PostSuccess!=nil) {
//                    PostSuccess(resposeJson);
//                }
//            }
//            
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            if (PostFailure!=nil) {
//                PostFailure(error);
//            }
//        }];
        
//        [manager POST:urlStr parameters:parmDict progress:^(NSProgress * _Nonnull uploadProgress) {
//
//
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//            
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            if (PostFailure!=nil) {
//                PostFailure(error);
//            }
//        }];
        
    }
}

#pragma mark GET异步请求
- (void)GETWithUrl:(NSString *)urlStr headers:(NSDictionary *)headers SuccessBlock:(void (^)(NSDictionary * responseJson))PostSuccess FailureBlock:(void (^)(NSError *error))PostFailure{
    
//    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"mycookies"];
//    if([cookiesdata length]) {
//        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
//        NSHTTPCookie *cookie;
//        for (cookie in cookies) {
//            if (![cookie.name isEqualToString:@""] && ![cookie.value isEqualToString:@""] ) {
//                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//            }
//            
//        }
//    }
    
    AFHTTPSessionManager *manager;
    
    NSURL *baseURL = [NSURL URLWithString:urlStr];
    
    if (headers) {
        //设置和加入头信息
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        [config setHTTPAdditionalHeaders:headers];
        
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL sessionConfiguration:config];
    }else{
        manager = [[AFHTTPSessionManager alloc]initWithBaseURL:baseURL];
    }
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = kOvertime;
//    manager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    
    [manager GET:@"" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary *resposeJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        PostSuccess(resposeJson);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if (PostFailure!=nil) {
            PostFailure(error);
        }
    }];
}

////上传单张图片
- (void )imageResponse:(NSMutableDictionary *)parmDict imageData:(NSData *)data SuccessBlock:(void (^)(NSDictionary * responseJson))PostSuccess FailureBlock:(void (^)(NSError *error))PostFailure
{

    GlobalVariables *fanweApp = [GlobalVariables sharedInstance];
    
    NSString *urlString = API_BASE_URL;
    


    [parmDict setObject:@"1" forKey:@"r_type"];
    //[parmDict setObject:@"0" forKey:@"i_type"];
    [parmDict setObject:@"app" forKey:@"from"];
    if (fanweApp.latitude != 0 && fanweApp.longitude != 0) {
        [parmDict setObject:@(fanweApp.longitude) forKey:@"m_longitude"];
        [parmDict setObject:@(fanweApp.latitude) forKey:@"m_latitude"];
    }
    if (fanweApp.city_id != 0) {
        [parmDict setObject:@(fanweApp.city_id) forKey:@"city_id"];
    }
    if (fanweApp.session_id) {
        [parmDict setObject:fanweApp.session_id forKey:@"sess_id"];
    }

    //    NSString *imageFile = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    //    NSString *photoName = [imageFile stringByAppendingPathComponent:@"image_head.jpg"];



    if (![NetHttpsManager isExistenceNetwork]){
        NSLog(@"请检查当前网络");
    }
    else{

        NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:kMyCookies];
        if([cookiesdata length]) {
            NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
            NSHTTPCookie *cookie;
            for (cookie in cookies) {
                if (![cookie.name isEqualToString:@""] && ![cookie.value isEqualToString:@""] ) {
                    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
                }

            }
        }



        //        manager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;

        [[DataTool shareDataTool] POST:urlString parameters:parmDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            if(data) {
                [formData appendPartWithFileData:data name:@"file" fileName:@"image_head.jpg"mimeType:@"image/jpg"];
             
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {



        }  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"上传成功  349")
            NSHTTPCookie *sessinCookie;
            NSHTTPCookieStorage *sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            NSArray *cookies = [sharedHTTPCookieStorage cookiesForURL:[NSURL URLWithString:urlString]];
            NSEnumerator *enumerator = [cookies objectEnumerator];
            NSHTTPCookie *cookie;
            while (cookie = [enumerator nextObject]) {
                if (![cookie.name isEqualToString:@""] && ![cookie.value isEqualToString:@""])
                {
                    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
                    if ([cookie.name isEqualToString:@"PHPSESSID2"]) {
                        sessinCookie = cookie;
                    }
                }
            }


            NSDictionary *resposeJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"上传成功  %@",resposeJson);

            if (resposeJson) {
                if([resposeJson count]){

                    if ([[resposeJson allKeys] containsObject:@"user_login_status"])
                    { //判断字典中是否含有这个key
                        if ([resposeJson toInt:@"user_login_status"] == 1) { //判断是否登录状态
                            if (PostSuccess!=nil) {
                                PostSuccess(resposeJson);
                            }

                        }else{
                                                        //未登录
                                                        if (PostSuccess!=nil) {
                                                            PostSuccess(resposeJson);
                                                        }
                        }
                    }else{
                        if (PostSuccess!=nil) {
                            PostSuccess(resposeJson);
                        }
                    }

                }else {
                    if (PostSuccess!=nil) {
                        PostSuccess(resposeJson);
                    }
                }
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            DebugLog(@"%@",error);
            NSLog(@"上传失败  400")

            if (PostFailure!=nil) {
                PostFailure(error);
            }

        }];



    }

}

#pragma mark NSURLSession同步请求
-(void)syncPostWithUrl:(NSString *)urlStr parameters:(NSMutableDictionary *)parmDict SuccessBlock:(void (^)(NSDictionary * responseJson))PostSuccess FailureBlock:(void (^)(NSError *error))PostFailure
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(10000); //创建信号量
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //(1)构造Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //(2)设置为POST请求
    [request setHTTPMethod:@"POST"];
    
    //(3)超时
    [request setTimeoutInterval:kOvertime];
    
    //(4)设置请求头
    //[request setAllHTTPHeaderFields:nil];
    
    //(5)设置请求体
    NSMutableString *params = nil;
    if(nil != parmDict){
        params = [[NSMutableString alloc] init];
        for(id key in parmDict){
            NSString *encodedkey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            CFStringRef value = (__bridge CFStringRef)[[parmDict objectForKey:key] copy];
            CFStringRef encodedValue = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, value,NULL,(CFStringRef)@";/?:@&=+$", kCFStringEncodingUTF8);
            [params appendFormat:@"%@=%@&", encodedkey, encodedValue];
            CFRelease(value);
            CFRelease(encodedValue);
        }
        [params deleteCharactersInRange:NSMakeRange([params length] - 1, 1)];
    }
    
    NSData *bodyData = [params dataUsingEncoding:NSUTF8StringEncoding];
    
    //    if (bodyData)
    //    {
    //        [request setValue:[NSString stringWithFormat:@"%ld",(long)[bodyData length]] forHTTPHeaderField:@"Content-Length"];
    //        [request setHTTPMethod:@"POST"];
    //        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    //        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    [request setHTTPBody:bodyData];
    //    }
    
    //(6)构造Session
    NSURLSession *session = [NSURLSession sharedSession];
    
    //(7)task
    __block NSDictionary *resposeDict = nil;
    __block NSError *tmperror = nil;
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        resposeDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"dict:%@",resposeDict);
        tmperror = error;
        
        dispatch_semaphore_signal(semaphore);   //发送信号
        
    }];
    
    [task resume];
    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);  //等待
    
    if (!tmperror)
    {
        if (resposeDict)
        {
            if([resposeDict count])
            {
                if (PostSuccess!=nil) {
                    PostSuccess(resposeDict);
                }
            }
            else
            {
                if (PostFailure!=nil)
                {
                    PostFailure(tmperror);
                }
            }
        }
        else
        {
            if (PostFailure!=nil)
            {
                PostFailure(tmperror);
            }
        }
    }
    else
    {
        if (PostFailure!=nil)
        {
            PostFailure(tmperror);
        }
    }
}


// by zzl
-(void)postMethod:(NSString*)method ctl:(NSString*)ctl param:(NSDictionary*)param successBlock:(void(^)(NSDictionary* jsonData))successBlock failBlock:(void(^)(NSError* error))failBlock
{
    NSMutableDictionary* postdir = NSMutableDictionary.new;
    if( param )
        [postdir setDictionary:param];
    [postdir setObject:method forKey:@"act"];
    [postdir setObject:ctl forKey:@"ctl"];
    [self POSTWithParameters:postdir SuccessBlock:successBlock FailureBlock:failBlock];
}

//同步 调用接口,不要在主线程调用, by zzl
-(NSDictionary*)postSynchMehtod:(NSString*)method ctl:(NSString*)ctl param:(NSDictionary*)param
{
    
    MYNSCondition* itlock = [[MYNSCondition alloc] init];//搞个事件来同步下
    
    __block NSDictionary* itret = nil;

    
    [self postMethod:method ctl:ctl param:param successBlock:^(NSDictionary *jsonData) {
        
        itret = jsonData;
        
        [itlock lock];
        
        [itlock signal];//设置事件,下面那个等待就可以收到事件返回了
        
        [itlock unlock];
        
        
    } failBlock:^(NSError *error) {
        
        NSLog(@"postSynchMehtod eror:%@",error);
        
        [itlock lock];
        
        [itlock signal];//设置事件,下面那个等待就可以收到事件返回了
        
        [itlock unlock];
    }];
    
    
    
    [itlock lock];//启动AFNETWORKING之后就等待事件
    
    [itlock wait];
    
    [itlock unlock];
    
    
    
    return  itret;
}

@end


//重新该类,原因是 如果 wait 类 函数 后于 signal调用,就会一直等待,,,就是说,signal 线程比 wait 快执行
@implementation MYNSCondition
{
    __volatile int _waitcounts;
}
-(void)wait
{
    _waitcounts +=1;
    if( _waitcounts <= 0 )
        return;//本来一进入应该是等于1的,如果其他地方已经有signal了,就直接返回了,
    [super wait];
}
-(BOOL)waitUntilDate:(NSDate *)limit
{
    _waitcounts +=1;
    if( _waitcounts <= 0 )
        return YES;//本来一进入应该是等于1的,如果其他地方已经有signal了,就直接返回了,
    return [super waitUntilDate:limit];
}
-(void)signal
{
    [super signal];
    _waitcounts -=1;
}


- (void)broadcast
{
    [super broadcast];
    _waitcounts =-1;
}







@end

