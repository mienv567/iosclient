#import "DB.h"

#define DB_NAME @"fanwe.db"


@implementation DB

+(id)initFanweDb:(BOOL) debug{
	BOOL success,has_init;
	NSError *error;
	NSFileManager *fm = [NSFileManager defaultManager];
	NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"fanwe.db"];
	
	has_init = NO;
	success = [fm fileExistsAtPath:writableDBPath];
	
	if(!success){
		NSString *defaultDBPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"fanwe.db"];
        NSLog(@"%@",defaultDBPath);
		success = [fm copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
		if(!success){
			NSLog(@"error: %@", [error localizedDescription]);
		}
		success = YES;
		has_init = YES;
	}
	
	if(success){
		FMDatabase *db = [[self alloc] initWithPath:writableDBPath];
		if (debug) {
			db.logsErrors = YES;
			db.traceExecution = YES;
		}
		if ([db open]) {
			[db setShouldCacheStatements:YES];
		}else{
			NSLog(@"Failed to open database.");
			success = NO;
		}
		
		//初始化数据库
		if (success && has_init) {
			[db executeUpdate:@"drop table if exists sys_conf;"];
			[db executeUpdate:@"create table sys_conf(id integer PRIMARY KEY autoincrement, name nvarchar(60) NULL,val nvarchar(2000));"];
			
			
			[db executeUpdate:@"insert into sys_conf(name,val) values('region_version','0');"];
			[db executeUpdate:@"insert into sys_conf(name,val) values('host','')"];			
			[db executeUpdate:@"insert into sys_conf(name,val) values('domain','')"];
			[db executeUpdate:@"insert into sys_conf(name,val) values('api','')"];
			[db executeUpdate:@"insert into sys_conf(name,val) values('user_id','0')"];
			[db executeUpdate:@"insert into sys_conf(name,val) values('user_name','')"];
			[db executeUpdate:@"insert into sys_conf(name,val) values('user_pwd','')"];
            [db executeUpdate:@"insert into sys_conf(name,val) values('user_email','')"];
            [db executeUpdate:@"insert into sys_conf(name,val) values('user_mobile','')"];
            [db executeUpdate:@"insert into sys_conf(name,val) values('session_id','')"];
            [db executeUpdate:@"insert into sys_conf(name,val) values('user_is_tmp','')"];
            [db executeUpdate:@"insert into sys_conf(name,val) values('is_third_login','0')"];
            [db executeUpdate:@"insert into sys_conf(name,val) values('versionCode','')"];
			[db executeUpdate:@"insert into sys_conf(name,val) values('user_tel','')"];
            [db executeUpdate:@"insert into sys_conf(name,val) values('supplier_name','')"];
            [db executeUpdate:@"insert into sys_conf(name,val) values('supplier_id','')"];
            [db executeUpdate:@"insert into sys_conf(name,val) values('the_last_time_ity','')"];
            [db executeUpdate:@"insert into sys_conf(name,val) values('is_first_installation','1')"];
            [db executeUpdate:@"insert into sys_conf(name,val) values('pageCount','0')"];
            

			[db executeUpdate:@"drop table if exists data_cached;"];
			[db executeUpdate:@"create table data_cached(id integer PRIMARY KEY autoincrement,urlmd5 nvarchar(50) NOT NULL, data_json text);"];
			[db executeUpdate:@"create index inx_data_cached_001 on data_cached(`urlmd5`);"];
			
			[db executeUpdate:@"drop table if exists region_conf;"];
			[db executeUpdate:@"create table region_conf(id nvarchar(50) NOT NULL PRIMARY KEY, name nvarchar(60) NULL,pid nvarchar(6) NULL,postcode nvarchar(10) NULL,py nvarchar(50) NULL);"];
		}
		
		return db;
	}else {
		return nil;
	}
}

@end
