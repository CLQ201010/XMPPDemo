//
//  FmdbTool.m
//  微信
//
//  Created by Think_lion on 15/6/30.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import "FmdbTool.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "HomeModel.h"

static FMDatabaseQueue *_queue;

@implementation FmdbTool

+(void)initialize
{
    NSString *path= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path=[NSString stringWithFormat:@"%@/XmppDemo/user/",path];
    
    BOOL bResult = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    if (!bResult) {
       NSLog(@"create dir error,path=%@",path);
    }
}

+(void)initWithUser:(NSString *)jid
{
    if (_queue != nil) {
        [_queue close];
    }
    
    NSString *path= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path=[NSString stringWithFormat:@"%@/XmppDemo/user/%@.sqlite",path,jid];
    
    _queue=[FMDatabaseQueue databaseQueueWithPath:path];
    //创建表
    [_queue inDatabase:^(FMDatabase *db) {
        BOOL b=[db executeUpdate:@"create table if not exists message(ID integer primary key autoincrement,head blob,uname text,detailname text,time text,badge text,jid blob)"];
        if(!b){
            NSLog(@"创建表失败");
        }
    }];
    NSLog(@"%@",path);
}

//数据库添加数据
+(BOOL)addHead:(NSData *)head uname:(NSString *)uname detailName:(NSString *)detailName time:(NSString *)time badge:(NSString *)badge xmppjid:(XMPPJID *)jid
{
    __block  BOOL b;
    [_queue inDatabase:^(FMDatabase *db) {
        //将对象转为二进制
         NSData *xmjid=[NSKeyedArchiver archivedDataWithRootObject:jid];
        b=[db executeUpdate:@"insert into message(head,uname,detailname,time,badge,jid) values(?,?,?,?,?,?)",head,uname,detailName,time,badge,xmjid];
    }];
    return b;
}
//判断用户是否已经存在
+(BOOL)selectUname:(NSString *)uname
{
    __block BOOL b=NO;
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result=[db executeQuery:@"select * from message where uname=?",uname];
        
        while ([result next]) {
            b=YES;
           
        }
    }];
   
    return b;
}

//更新数据
+(BOOL)updateWithName:(NSString *)uname detailName:(NSString *)detailName time:(NSString *)time badge:(NSString *)badge
{
    __block BOOL b;
    
    [_queue inDatabase:^(FMDatabase *db) {
        b=[db executeUpdate:@"update message set detailname=?, time=? ,badge=? where uname=?",detailName,time,badge,uname];
    }];
    
    return b;
}
/*
  NSDictionary *dict=@{@"username":[jid user],@"time":strDate,@"body":body,@"jid":jid};
 */
//查询所有的数据
+(NSArray *)selectAllData
{
    __block NSMutableArray *arr=nil;
    
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result=[db executeQuery:@"select * from message order by time desc"];
        if(result){
            //创建数组
            arr=[NSMutableArray array];
            while ([result next]) {
                
               //添加模型
                HomeModel *model=[[HomeModel alloc]init];
                model.username=[result stringForColumn:@"uname"];
                model.body=[result stringForColumn:@"detailname"];
                model.time=[result stringForColumn:@"time"];
                model.badgeValue=[result stringForColumn:@"badge"];
                model.headerIcon=[result dataForColumn:@"head"];
                //获得XmppJid
                model.jid=[NSKeyedUnarchiver unarchiveObjectWithData:[result dataForColumn:@"jid"]];
                
                [arr addObject:model];
                
            }
        }
      
    }];
   
    
    return arr;
}
//清除小红点
+(void)clearRedPointwithName:(NSString *)uname
{
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"update message set badge='' where uname=?",uname];
    }];
}
#pragma mark 删除聊天数据的方法
+(void)deleteWithName:(NSString *)uname
{
    [_queue inDatabase:^(FMDatabase *db) {
        BOOL b=[db executeUpdate:@"delete  from message where uname=?",uname];
        if(!b){
            NSLog(@"删除失败");
        }
    }];
}

+(void)close
{
    if (_queue != nil) {
        [_queue close];
        _queue = nil;
    }
}

@end
