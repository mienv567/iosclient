//
//  dataModel.m
//  FanweO2O
//
//  Created by zzl on 2017/3/1.
//  Copyright © 2017年 xfg. All rights reserved.
//


#import "dataModel.h"
#import <objc/message.h>
#import "NSObject+myobj.h"
#import "Util.h"
#import "NSData+ImageContentType.h"
#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"
#import "WXApi.h"
#import "NetHttpsManager.h"



@implementation dataModel

@end

@implementation SResBase

+(SResBase*)infoWithOKString:(NSString*)okstr
{
    SResBase* retobj = SResBase.new;
    
    retobj.msuccess = YES;
    retobj.mcode = 0;
    retobj.mmsg = okstr;
    
    return retobj;
}

+(SResBase*)infoWithErrorString:(NSString*)errstr
{
    SResBase* retobj = SResBase.new;
    if( errstr )
    {
        retobj.msuccess = NO;
        retobj.mcode =1;
        retobj.mmsg = errstr;
    }
    else
    {
        retobj.msuccess = YES;
        retobj.mcode = 0;
        retobj.mmsg = @"操作成功";
    }
    return retobj;
}

+(SResBase*)infoWithEror:(NSError*)error
{
    SResBase* retobj = SResBase.new;
    if( error )
    {
        retobj.msuccess = NO;
        retobj.mcode = (int)error.code;
        //retobj.mmsg = error.description;
        retobj.mmsg = @"网络链接失败";
    }
    else
    {
        retobj.msuccess = YES;
        retobj.mcode = 0;
        retobj.mmsg = @"操作成功";
    }
    return retobj;
}

+(SResBase*)baseWithData:(NSDictionary*)data
{
    if( data == nil ) return [SResBase infoWithErrorString:@"网络链接失败"];
    
    if( [data isKindOfClass:[NSString class]] )
    {
        NSError*    jsonerrr=nil;
        data = [NSJSONSerialization JSONObjectWithData:[(NSString*)data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonerrr];
        if( data == nil )
        {
            data = @{@"code":@(1),@"msg":@"无效的数据"};
        }
    }
    
    SResBase* retobj = SResBase.new;
    id xx = [data objectForKey:@"code"];
    if( xx == nil )
    {
        return [SResBase infoWithErrorString:@"网络链接失败"];
    }
    else
    {
        retobj.mcode = [xx intValue];
        retobj.mmsg = [data objectForKey:@"msg"];
        retobj.msuccess = retobj.mcode == 0;
        retobj.mdata = [data objectForKeyMy:@"data"];
        retobj.mcoredata = data;
        
        return retobj;
    }
}



@end

@interface SAutoEx()<NSCoding>

@end

@implementation SAutoEx


+(NSDictionary*)delNUll:(NSDictionary*)dic
{
    NSArray* allk = dic.allKeys;
    NSMutableDictionary* tmp = NSMutableDictionary.new;
    for ( NSString* onek in allk ) {
        id v = [dic objectForKey:onek];
        if( [v isKindOfClass:[NSNull class] ] )
        {//如果是nsnull 不要
            continue;
        }
        
        if( [v isKindOfClass:[NSArray class]] || [v isKindOfClass: [NSMutableArray class]] )
        {
            NSArray* ta = [SAutoEx delNullInArr:v] ;
            [tmp setObject:ta forKey:onek];
            continue;
        }
        if( [v isKindOfClass:[NSDictionary class]] || [v isKindOfClass:[NSMutableDictionary class]] )
        {
            NSDictionary* td = [SAutoEx delNUll:v];
            [tmp setObject:td forKey:onek];
            continue;
        }
        [tmp setObject:v forKey:onek];
    }
    return tmp;
}
+(NSArray*)delNullInArr:(NSArray*)arr
{
    NSMutableArray* tmp = NSMutableArray.new;
    for ( id v in arr ) {
        if( [v isKindOfClass:[NSNull class] ] )
        {//如果是nsnull 不要
            continue;
        }
        if( [v isKindOfClass:[NSArray class]] || [v isKindOfClass: [NSMutableArray class]] )
        {
            NSArray* ta = [SAutoEx delNullInArr:v] ;
            [tmp addObject:ta];
            continue;
        }
        if( [v isKindOfClass:[NSDictionary class]] || [v isKindOfClass:[NSMutableDictionary class]] )
        {
            NSDictionary* td = [SAutoEx delNUll:v];
            [tmp addObject:td];
            continue;
        }
        [tmp addObject:v];
    }
    return tmp;
}

//userdefault 存储
+(id)loadDataForKey:(NSString*)key
{
    NSUserDefaults* st = [NSUserDefaults standardUserDefaults];
    if( st == nil ) return nil;
    return [st objectForKey:key];
}


+(BOOL)saveData:(id)data forkey:(NSString*)key
{
    if( data == nil && key == nil ) return NO;
    
    NSUserDefaults* st = [NSUserDefaults standardUserDefaults];
    if( data == nil && key != nil ){
        [st removeObjectForKey:key];
        return [st synchronize];
    }
    
    id fordump = data;
    if( [data isKindOfClass:[NSDictionary class]] )
    {
        fordump = [SAutoEx delNUll:data];
    }
    else
        if( [data isKindOfClass:[NSArray class]] )
        {
            fordump = [SAutoEx delNullInArr:data];
        }
    
    [st setObject:fordump forKey:key];
    return [st synchronize];
    
}

-(BOOL)clearSelfToKey:(NSString*)key
{
    if( key == nil ) return NO;
    NSUserDefaults* st = [NSUserDefaults standardUserDefaults];
    
    [st removeObjectForKey:key];
    return [st synchronize];
    
}
//序列化自己...
-(BOOL)dumpSelfToKey:(NSString*)key
{
    return [SAutoEx saveData:[NSKeyedArchiver archivedDataWithRootObject:self] forkey:key];
}

//加载
+(id)loadSelfFromKey:(NSString*)key
{
    id vv = [SAutoEx loadDataForKey:key];
    if( vv == nil ) return nil;
    return  [NSKeyedUnarchiver unarchiveObjectWithData:vv];
}

//测试API用
+(void)forTestCode:(void(^)(int percent))proccess delayseconde:(int)delayseconde codeblock:(void(^)(int vvv))block;
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        if( proccess != nil )
        {
            NSTimeInterval ff = delayseconde /100.0f;
            for( int j = 0 ; j < 100 ;j ++ )
            {
                dispatch_async( dispatch_get_main_queue(), ^{
                    
                    proccess( j );
                });
                
                [NSThread sleepForTimeInterval:ff];
            }
        }
        else
        {
            [NSThread sleepForTimeInterval:delayseconde];
        }
        
        dispatch_async( dispatch_get_main_queue(), ^{
            
            block( arc4random() );
            
        });
        
        
    });
}


-(id)initWithWithObj:(NSDictionary*)obj
{
    self = [super init];
    if( self )
    {
        [self fetchItWithObj:obj];
    }
    return self;
}

-(void)fetchItWithObj:(NSDictionary*)obj
{
    if( obj == nil ) return;
    if( ![obj isKindOfClass:[NSDictionary class]] && ![obj isKindOfClass:[NSMutableDictionary class]] ) return;
    
    NSMutableDictionary* nameMapProp = NSMutableDictionary.new;
    id leaderClass = [self class];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(leaderClass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
        [nameMapProp setObject:[NSString stringWithFormat:@"%s",property_getAttributes(property)] forKey:propName];
    }
    if( properties )
    {
        free( properties );
    }
    
    if( nameMapProp.count == 0 ) return;
    
    NSArray* allnames = [nameMapProp allKeys];
    for ( NSString* oneName in allnames ) {
        if( ![oneName hasPrefix:@"m"] ) continue;
        
        NSString* jsonkey = [oneName stringByReplacingCharactersInRange:NSMakeRange(1, 1) withString:[[oneName substringWithRange:NSMakeRange(1, 1)] lowercaseString] ];
        //mId ==> mid;
        jsonkey = [jsonkey substringFromIndex:1];
        
        id itobj = [obj objectForKeyMy:jsonkey];
        
        if( itobj == nil ) continue;
        
        NSString* thispropclass = [self getPropCustomClassName:[nameMapProp objectForKey:oneName]];
        if( thispropclass.length )
        {//如果自己定义的类型就尝试用 initWithObj 处理下,,
            Class tclass = NSClassFromString(thispropclass);
            if( [tclass instancesRespondToSelector:@selector(initWithWithObj:)] )
            {
                id tobj = [[tclass alloc] initWithWithObj:itobj];
                if( tobj )
                    [self setValue:tobj forKey:oneName];
                else
                    [self setValue:itobj forKey:oneName];
            }
            else
                [self setValue:itobj forKey:oneName];
        }
        else
        {
            NSString* sssa = [nameMapProp objectForKey:oneName];
            if( [sssa hasPrefix:@"Tc"] )
                [self setValue:@([itobj boolValue]) forKey:oneName];
            else
                [self setValue:itobj forKey:oneName];
        }
    }
}
/*
 -(id)initWithAVObj:(AVObject *)obj
 {
 self = [super init];
 if( self )
 {
 [self fetchIt:obj];
 }
 return self;
 }
 */
//mCertificateImg = "T@\"NSString\",&,N,V_mCertificateImg";
//mCountGoods = "Ti,N,V_mCountGoods";
//mCateIds = "T@\"NSArray\",&,N,V_mCateIds";
//获取自定义的类型,系统的,INT FLOAT 这种不要
-(NSString*)getPropCustomClassName:(NSString*)propInfo
{
    if( propInfo.length != 0  && [propInfo hasPrefix:@"T@\"OTO"] )
    {//如果是 TJ开头的classs,,就是我们的,应该
        NSArray* t = [propInfo componentsSeparatedByString:@"\""];
        if( t.count > 1 )
        {
            return t[1];
        }
    }
    return nil;
}
/*
 -(void)fetchIt:(AVObject*)obj
 {
 if( obj == nil ) return;
 NSMutableDictionary* nameMapProp = NSMutableDictionary.new;
 id leaderClass = [self class];
 unsigned int outCount, i;
 objc_property_t *properties = class_copyPropertyList(leaderClass, &outCount);
 for (i = 0; i < outCount; i++) {
 objc_property_t property = properties[i];
 NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
 [nameMapProp setObject:[NSString stringWithFormat:@"%s",property_getAttributes(property)] forKey:propName];
 }
 if( properties )
 {
 free( properties );
 }
 
 if( nameMapProp.count == 0 ) return;
 
 NSArray* allnames = [nameMapProp allKeys];
 for ( NSString* oneName in allnames ) {
 if( ![oneName hasPrefix:@"m"] ) continue;
 NSString* jsonkey = oneName;
 
 id itobj = nil;
 if( [obj isKindOfClass:[AVObject class]] )
 itobj = [(AVObject*)obj objectForKey:jsonkey];
 else
 itobj = [obj objectForKeyMy:jsonkey];
 
 if( itobj == nil ) continue;
 
 NSString* thispropclass = [self getPropCustomClassName:[nameMapProp objectForKey:oneName]];
 if( thispropclass.length )
 {//如果自己定义的类型就尝试用 initWithObj 处理下,,
 Class tclass = NSClassFromString(thispropclass);
 if( [tclass instancesRespondToSelector:@selector(initWithAVObj:)] )
 {
 id tobj = [[tclass alloc] initWithAVObj:itobj];
 if( tobj )
 [self setValue:tobj forKey:oneName];
 else
 [self setValue:itobj forKey:oneName];
 }
 else
 [self setValue:itobj forKey:oneName];
 }
 else
 [self setValue:itobj forKey:oneName];
 }
 }
 */
-(NSArray*)getClassAllPropNameForCoder
{
    NSMutableDictionary* nameMapProp = NSMutableDictionary.new;
    id leaderClass = [self class];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(leaderClass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
        if( [propName hasPrefix:@"mm"] ) continue;//这种字段不需要保存
        
        [nameMapProp setObject:[NSString stringWithFormat:@"%s",property_getAttributes(property)] forKey:propName];
    }
    if( properties )
    {
        free( properties );
    }
    return [nameMapProp allKeys];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSArray* allprop = [self getClassAllPropNameForCoder];
    for ( NSString* one in allprop ) {
        id v = [self valueForKey:one];
        if( v == nil ) continue;
        [aCoder encodeObject: v  forKey:one];
    }
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    NSArray* allprop = [self getClassAllPropNameForCoder];
    for ( NSString* one in allprop ) {
        
        id k = [aDecoder decodeObjectForKey: one];
        if( k )
            [self setValue:k forKey:one];
        
    }
    
    return self;
}


+(void)netWaper:(NSMutableDictionary *)parmDict SuccessBlock:(void (^)( SResBase* resb))PostSuccess
{
    [[NetHttpsManager manager]POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
       
        int status = [[responseJson objectForKeyMy:@"status"] intValue];
        NSString* info = [responseJson objectForKeyMy:@"info"];
        if( status == 1 )
        {
            SResBase* resb = SResBase.new;
            resb.msuccess = YES;
            resb.mcode =0;
            resb.mmsg = info;
            resb.mdata = responseJson;
            PostSuccess( resb );
            
        }
        else
        {//失败
            if( info == nil || [info isEqualToString:@""] )
                info = @"网络连接失败";
            
            PostSuccess( [SResBase infoWithErrorString:info] );
        }
        
    } FailureBlock:^(NSError *error) {
        
        NSLog(@"post err:%@",error);
        PostSuccess( [SResBase infoWithErrorString:@"网络连接失败"] );

    }];
}

@end




////////////////////////////////////////////////////////////////////////////////
//以上是基础类,
////////////////////////////////////////////////////////////////////////////////

@implementation OTOAddr
-(BOOL)isEqual:(id)object
{
    BOOL b = [super isEqual:object];
    if( !b )
    {
        b = self.mId == ((OTOAddr*)object).mId;
    }
    return b;
}
- (id)copyWithZone:(NSZone *)zone{
    
    OTOAddr* copy = [[OTOAddr allocWithZone:zone] init];
    if( copy )
    {
        copy.mId = self.mId;
        copy.mRegion_lv1_name = [self.mRegion_lv1_name copy];//	string	国家
        copy.mRegion_lv2_name = [self.mRegion_lv2_name copy];//	string	省
        copy.mRegion_lv3_name = [self.mRegion_lv3_name copy];//	string	市
        copy.mRegion_lv4_name = [self.mRegion_lv4_name copy];//	string	区/县
        copy.mAddress = [self.mAddress copy];//	string	详细地址
        copy.mIs_default = self.mIs_default;//	是否默认地址	0:否 1:是
        copy.mConsignee = [self.mConsignee copy];//	string	收货人姓名
        copy.mMobile = [self.mMobile copy];//	string	收货人手机
        copy.mZip = [self.mZip copy];//	邮编
        copy.mFull_address = [self.mFull_address copy];//	全地址
        copy.mDoorplate = [self.mDoorplate copy];
        copy.mStreet = [self.mStreet copy];
        copy.mRegion_lv1 = self.mRegion_lv1;
        copy.mRegion_lv2 = self.mRegion_lv2;
        copy.mRegion_lv3 = self.mRegion_lv3;
        copy.mRegion_lv4 = self.mRegion_lv4;
        copy.mXpoint = self.mXpoint;
        copy.mYpoint = self.mYpoint;
        
    }
    return copy;
}

-(void)fetchItWithObj:(NSDictionary *)obj
{
    [super fetchItWithObj:obj];
    
}

//获取地址列表 all ==> OTOAddr
+(void)getAddrList:(void(^)(NSArray* all,SResBase* resb))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:@"uc_address" forKey:@"ctl"];
    [SAutoEx netWaper:param SuccessBlock:^(SResBase *resb) {
       
        if( resb.msuccess )
        {
            NSArray* arr = [resb.mdata objectForKeyMy:@"consignee_list"];
            NSMutableArray* t = NSMutableArray.new;
            for( NSDictionary* one in arr )
            {
                [t addObject:[[OTOAddr alloc]initWithWithObj:one]];
            }
            block( t , resb );
        }
        else
        {
            block( nil, resb );
        }
        
    }];
    
}
-(void)changeDefault:(void(^)(SResBase* resb))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:@"uc_address" forKey:@"ctl"];
    [param setObject:@"set_default" forKey:@"act"];
    [param setObject:@(self.mId) forKey:@"id"];
    [param setObject:@(self.mIs_default) forKey:@"is_default"];
    
    [SAutoEx netWaper:param SuccessBlock:^(SResBase *resb) {
        if( !resb.msuccess )
        {
            self.mIs_default = self.mIs_default == 1?0:1;
        }
        block(  resb );
        
    }];
    
}
-(void)addEditAddr:(void(^)(SResBase* resb))block
{
    BOOL badd = self.mId == 0;
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:@"uc_address" forKey:@"ctl"];
    [param setObject:@"save" forKey:@"act"];
    if( !badd )
        [param setObject:@(self.mId) forKey:@"id"];
    
    [param setObject:self.mConsignee forKey:@"consignee"];
    [param setObject:self.mMobile forKey:@"mobile"];
    if( self.mRegion_lv1 == 0 )
        [param setObject:@(1) forKey:@"region_lv1"];
    else
        [param setObject:@(self.mRegion_lv1) forKey:@"region_lv1"];
    
    [param setObject:@(self.mRegion_lv2) forKey:@"region_lv2"];
    [param setObject:@(self.mRegion_lv3) forKey:@"region_lv3"];
    [param setObject:@(self.mRegion_lv4) forKey:@"region_lv4"];
    [param setObject:self.mAddress forKey:@"address"];
    [param setObject:self.mStreet forKey:@"street"];
    [param setObject:self.mDoorplate forKey:@"doorplate"];
    [param setObject:@(self.mIs_default) forKey:@"is_default"];
    [param setObject:@(self.mXpoint) forKey:@"xpoint"];
    [param setObject:@(self.mYpoint) forKey:@"ypoint"];
    
    [SAutoEx netWaper:param SuccessBlock:^(SResBase *resb) {
        
        if( resb.msuccess )
        {
            block( resb );
        }
        else
        {
            block( resb );
        }
        
    }];
}


-(void)delThisAddr:(void(^)(SResBase* resb))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:@"uc_address" forKey:@"ctl"];
    [param setObject:@"del" forKey:@"act"];
    [param setObject:@(self.mId) forKey:@"id"];
    [SAutoEx netWaper:param SuccessBlock:block];
}


@end


@implementation OTOCollect
-(BOOL)isEqual:(id)object
{
    BOOL b = [super isEqual:object];
    if( !b )
    {
        b = self.mId == ((OTOCollect*)object).mId;
    }
    return b;
}

-(void)fetchItWithObj:(NSDictionary *)obj
{
    self.mIsInVaild = [[obj objectForKeyMy:@"out_time"] intValue];
    if( self.mType == 0 )
    {
        float vv = [[obj objectForKeyMy:@"current_price"]floatValue];
        self.mSubTitle = [NSString stringWithFormat:@"¥%.2f",vv];
        self.mSubTitle = [self.mSubTitle stringByReplacingOccurrencesOfString:@".00" withString:@""];
    }
    else if( self.mType == 1 || self.mType == 2 )
    {
        int v = [[obj objectForKeyMy:@"score_limit"] intValue];
        self.mSubTitle = [NSString stringWithFormat:@"%d 积分",v];
        if( v == 0 )
        {
            v = [[obj objectForKeyMy:@"point_limit"] intValue];
            if( v == 0 )
                self.mSubTitle = nil;
            else
                self.mSubTitle = [NSString stringWithFormat:@"%d 经验",v];
        }
    }
    
    self.mId = [[obj objectForKeyMy:@"id"] intValue];
    self.mTitle = [obj objectForKeyMy:@"name"];
    self.mLogo = [obj objectForKeyMy:@"icon"];
    
    self.mUrl = [obj objectForKeyMy:@"url"];
}

+(void)getCollectList:(int)type page:(int)page block:(void(^)(NSArray* all , SResBase* resb))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:@"uc_collect" forKey:@"ctl"];
    [param setObject:@"wap_index" forKey:@"act"];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@(type) forKey:@"sc_status"];
    [SAutoEx netWaper:param SuccessBlock:^(SResBase *resb) {
        
        if( resb.msuccess )
        {
            NSMutableArray* t = NSMutableArray.new;
            NSArray* tmp = [resb.mdata objectForKeyMy:@"item"];
            for( NSDictionary* one in  tmp )
            {
                OTOCollect* oneobj = OTOCollect.new;
                oneobj.mType = type;
                [oneobj fetchItWithObj:one];
                [t addObject:oneobj];
            }
            block(t,resb);
        }
        else
        {
            block( nil, resb );
        }
        
    }];
}

+(void)cancleCollect:(NSArray*)ids type:(int)type block:(void(^)(SResBase* resb))block
{
    NSArray* xx = @[ @"deal",@"youhui",@"event" ];
    
    NSMutableString* itids = NSMutableString.new;
    for( id v in ids )
    {
        [itids appendFormat:@",%d",[v intValue]];
    }
    if( itids.length == 0 )
    {
        block( [SResBase infoWithOKString:@"参数错误"] );
        return;
    }
    [itids replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:@"uc_collect" forKey:@"ctl"];
    [param setObject:@"del_collect" forKey:@"act"];
    [param setObject:[NSString stringWithString:itids] forKey:@"id"];
    [param setObject:xx[type] forKey:@"type"];
    [SAutoEx netWaper:param SuccessBlock:block];
    
}


@end




