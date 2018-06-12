//
//  NetHttpsManager.h
//  AfDemo
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalVariables.h"

@interface NetHttpsManager : NSObject

+(instancetype)manager;

//上传单张图片
- (void )imageResponse:(NSMutableDictionary *)parmDict imageData:(NSData *)data  SuccessBlock:(void (^)(NSDictionary * responseJson))PostSuccess FailureBlock:(void (^)(NSError *error))PostFailure;


/**
 *  paraDic：post参数
 */
-(void)POSTWithParameters:(NSMutableDictionary *)paraDic SuccessBlock:(void (^)(NSDictionary * responseJson))PostSuccess FailureBlock:(void (^)(NSError *error))PostFailure;

/**
 *  urlStr： post时的主域名
 *  paraDic：post参数
 */
-(void)POSTWithUrl:(NSString *)urlStr parameters:(NSMutableDictionary *)parmDict SuccessBlock:(void (^)(NSDictionary * responseJson))PostSuccess FailureBlock:(void (^)(NSError *error))PostFailure;


- (void)GETWithUrl:(NSString *)urlStr headers:(NSDictionary *)headers SuccessBlock:(void (^)(NSDictionary * responseJson))PostSuccess FailureBlock:(void (^)(NSError *error))PostFailure;

/**
 *  NSURLSession同步请求
 *  urlStr： post时的主域名
 *  paraDic：post参数
 */
-(void)syncPostWithUrl:(NSString *)urlStr parameters:(NSMutableDictionary *)parmDict SuccessBlock:(void (^)(NSDictionary * responseJson))PostSuccess FailureBlock:(void (^)(NSError *error))PostFailure;


// by zzl
-(void)postMethod:(NSString*)method ctl:(NSString*)ctl param:(NSDictionary*)param successBlock:(void(^)(NSDictionary* jsonData))successBlock failBlock:(void(^)(NSError* error))failBlock;


//同步 调用接口,不要在主线程调用, by zzl
- (NSDictionary*)postSynchMehtod:(NSString*)method ctl:(NSString*)ctl param:(NSDictionary*)param;



@end

//尽量做2个线程之间的同步,否则可能结果不符合预期,自己看代码
@interface MYNSCondition : NSCondition



@end
