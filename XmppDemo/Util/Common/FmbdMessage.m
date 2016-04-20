//
//  FmbdMessage.m
//  微信
//
//  Created by Think_lion on 15/7/5.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import "FmbdMessage.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

static FMDatabaseQueue *_queue = nil;

@implementation FmbdMessage

+(void)initialize
{
    NSString *path= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path=[NSString stringWithFormat:@"%@/XmppDemo/XMPPMessageArchiving/",path];
    
    BOOL bResult = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    if (!bResult) {
        NSLog(@"create dir error,path=%@",path);
    }
}

+(void)initWithUser:(NSString*)jid
{
    if (_queue != nil) {
        [_queue close];
    }
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] ;
    path=[NSString stringWithFormat:@"%@/XmppDemo/XMPPMessageArchiving/%@.sqlite",path,jid];
    _queue =[FMDatabaseQueue databaseQueueWithPath:path];
}

+(void)deleteChatData:(NSString*)jid
{
    [_queue inDatabase:^(FMDatabase *db) {
        BOOL b=[db executeUpdate:@"delete from ZXMPPMESSAGEARCHIVING_MESSAGE_COREDATAOBJECT where ZBAREJIDSTR=?",jid];
        if(!b){
            NSLog(@"删除聊天数据失败");
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
