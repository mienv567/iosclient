//
//  dataModel.h
//  FanweO2O
//
//  Created by zzl on 2017/3/1.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface dataModel : NSObject

@end




//从这里继承的类,如果如果有属性是 mm开头的,就不能序列化
//这个类自动支持序列化
@interface SAutoEx : NSObject

//把nsnull字段干掉
+(NSDictionary*)delNUll:(NSDictionary*)dic;

//把nsnull字段干掉
+(NSArray*)delNullInArr:(NSArray*)arr;


-(id)initWithWithObj:(NSDictionary*)obj;

//-(id)initWithAVObj:(AVObject *)obj;

//-(void)fetchIt:(AVObject*)obj;

-(void)fetchItWithObj:(NSDictionary*)obj;

//userdefault 存储
+(id)loadDataForKey:(NSString*)key;

//保存数据
+(BOOL)saveData:(id)data forkey:(NSString*)key;


//序列化自己...
-(BOOL)dumpSelfToKey:(NSString*)key;


-(BOOL)clearSelfToKey:(NSString*)key;

//加载
+(id)loadSelfFromKey:(NSString*)key;


//测试API用  doseconde 模拟执行多少秒
+(void)forTestCode:(void(^)(int percent))proccess delayseconde:(int)delayseconde codeblock:(void(^)(int vvv))block;


@end

@interface SResBase : NSObject

@property (nonatomic,assign) BOOL       msuccess;//是否成功了
@property (nonatomic,assign) int        mcode;  //错误码
@property (nonatomic,strong) NSString*  mmsg;   //客户端需要显示的提示信息,正确,失败,根据msuccess判断显示错误还是提示,
@property (nonatomic,strong) NSString*  mdebug;
@property (nonatomic,strong) id         mdata;
@property (nonatomic,strong) id         mcoredata;

+(SResBase*)infoWithOKString:(NSString*)okstr;

+(SResBase*)infoWithErrorString:(NSString*)errstr;

+(SResBase*)infoWithEror:(NSError*)error;

+(SResBase*)baseWithData:(NSDictionary*)data;

@end


////////////////////////////////////////////////////////////////////////////////
//以上是基础类,
////////////////////////////////////////////////////////////////////////////////




@interface OTOAddr : SAutoEx<NSCopying>

@property (nonatomic,assign)    int         mId;//	int	地址id
@property (nonatomic,strong)    NSString*   mRegion_lv1_name;//	string	国家
@property (nonatomic,strong)    NSString*   mRegion_lv2_name;//	string	省
@property (nonatomic,strong)    NSString*   mRegion_lv3_name;//	string	市
@property (nonatomic,strong)    NSString*   mRegion_lv4_name;//	string	区/县
@property (nonatomic,assign)    int         mRegion_lv1;//		国家
@property (nonatomic,assign)    int         mRegion_lv2;//		省
@property (nonatomic,assign)    int         mRegion_lv3;//		市
@property (nonatomic,assign)    int         mRegion_lv4;//		区/县
@property (nonatomic,strong)    NSString*   mAddress;//	string	详细地址
@property (nonatomic,assign)    int         mIs_default;//	是否默认地址	0:否 1:是
@property (nonatomic,strong)    NSString*   mConsignee;//	string	收货人姓名
@property (nonatomic,strong)    NSString*   mMobile;//	string	收货人手机
@property (nonatomic,strong)    NSString*   mZip;//	邮编
@property (nonatomic,strong)    NSString*   mFull_address;//显示的全地址
@property (nonatomic,strong)    NSString*   mDoorplate;//门牌号
@property (nonatomic,strong)    NSString*   mStreet;//地图返回的地址

@property (nonatomic,assign)    double      mXpoint;
@property (nonatomic,assign)    double      mYpoint;


//获取地址列表 all ==> OTOAddr
+(void)getAddrList:(void(^)(NSArray* all,SResBase* resb))block;

//编辑添加地址
-(void)addEditAddr:(void(^)(SResBase* resb))block;

//修改默认
-(void)changeDefault:(void(^)(SResBase* resb))block;

//删除
-(void)delThisAddr:(void(^)(SResBase* resb))block;

@end


@interface OTOCollect : SAutoEx

@property (nonatomic,assign)    int         mType;// 0 商品,1 优惠券 ,2 活动
@property (nonatomic,assign)    int         mId;
@property (nonatomic,strong)    NSString*   mTitle;
@property (nonatomic,strong)    NSString*   mSubTitle;
@property (nonatomic,strong)    NSString*   mLogo;
@property (nonatomic,assign)    BOOL        mIsInVaild;//是否无效过期的商品,YES 无效了

@property (nonatomic,strong)    NSString*   mUrl;

//FOR UI
@property (nonatomic,assign)    int         mSelectStated;//0 隐藏,1勾选,2不勾选


+(void)getCollectList:(int)type page:(int)page block:(void(^)(NSArray* all , SResBase* resb))block;


+(void)cancleCollect:(NSArray*)ids type:(int)type block:(void(^)(SResBase* resb))block;


@end









