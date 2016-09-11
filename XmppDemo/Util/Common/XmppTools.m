//
//  XmppTools.m
//  微信
//
//  Created by Think_lion on 15/6/16.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import "XmppTools.h"
#import "UserOperation.h"
#import "DDXMLDocument.h"
#import "UserSearchModel.h"
#import "SubscribeOperation.h"
#import "ContacterOperation.h"


@interface XmppTools ()<XMPPStreamDelegate,XMPPRosterDelegate>
{
    //定义这个block
    XMPPResultBlock _resultBlock;
    //自动连接对象
    XMPPReconnect *_reconnect;
    //定义一个消息对象
    XMPPMessageArchiving *_messageArching;
   //电子名片存贮
    XMPPvCardCoreDataStorage *_vCardStorage;
  
}


@end

@implementation XmppTools
SingletonM(xmpp);



#pragma mark 初始化xmppstream
-(void)setupXmppStream
{
    _xmppStream=[[XMPPStream alloc]init];
//#warning 每一个模块添加都要激活
    //1.添加自动连接模块
    _reconnect=[[XMPPReconnect alloc]init];
    [_reconnect activate:_xmppStream];
//    //2.添加电子名片模块
    _vCardStorage=[XMPPvCardCoreDataStorage sharedInstance];
    _vCard=[[XMPPvCardTempModule alloc]initWithvCardStorage:_vCardStorage];
    [_vCard activate:_xmppStream];  //激活
    
//    //3.添加头像模块
    _avatar=[[XMPPvCardAvatarModule alloc]initWithvCardTempModule:_vCard];
    [_avatar activate:_xmppStream];
//    //4.添加花名册模块
    _rosterStorage=[[XMPPRosterCoreDataStorage alloc]init];
    _roster=[[XMPPRoster alloc]initWithRosterStorage:_rosterStorage];
    [_roster activate:_xmppStream];  //激活
//    //5.添加聊天模块    XMPPMessageArchivingCoreDataStorage
    _messageStroage=[[XMPPMessageArchivingCoreDataStorage alloc]init];
    _messageArching=[[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:_messageStroage];
    [_messageArching activate:_xmppStream];

    
    //添加代理   把xmpp流放到子线程
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    [_roster addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];

}
#pragma mark 连接到服务器
-(void)connectToHost
{
    if(!_xmppStream){
        [self setupXmppStream];
    }
    //设置用户的jid
    UserOperation *user=[UserOperation shareduser];
    NSString *username=user.userName;
    XMPPJID *myJid=[XMPPJID jidWithUser:username domain:ServerName resource:nil];
    self.jid=myJid;  //参数赋值
    _xmppStream.myJID=myJid;
    //设置服务器域名或ip地址
    _xmppStream.hostName=ServerAddress;  //IP地址或域名都可以
    _xmppStream.hostPort=ServerPort;
    
    NSError *error=nil;
    //连接到服务器
    if(![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]){
        NSLog(@"%@",error);
    }
    
    
}
#pragma mark 连接成功调用这个方法
-(void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"连接主机成功");
    //想服务器端发送密码
    
    //判断是登录还是注册
    if(self.isRegisterOperation) {  //注册操作
        
        UserOperation *user=[UserOperation shareduser];
        NSString *password=user.password;//
        //调用注册方法  （这个方法会调用代理方法）
        [_xmppStream registerWithPassword:password error:nil];
    }else{  //登录操作
        [self sendPwdToHost];
    }
    
}

#pragma mark 连接失败的方法
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    if(error && _resultBlock){
        _resultBlock(XMPPResultNetworkErr);  //网路出现问题的时候
    }
    NSLog(@"连接断开");
}
#pragma mark .连接到服务器后 在发送密码
-(void)sendPwdToHost
{
    NSError *error=nil;
    UserOperation *user=[UserOperation shareduser];
    NSString *password=user.password;
    //验证密码
    [_xmppStream authenticateWithPassword:password error:&error];
    if(error){
        NSLog(@"授权失败%@",error);
    }
}
#pragma mark 验证成功 （就是密码正确）
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"验证成功");
    //发送在线消息
    [self sendOnlineMessage];
    if(_resultBlock){
        _resultBlock(XMPPResultSuccess);
    }
}

#pragma mark 验证失败 （就是密码错误）
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"验证失败");
    if(_resultBlock){
        _resultBlock(XMPPResultFaiture);
    }
}

#pragma mark 验证成功后 发送在线消息
-(void)sendOnlineMessage
{
    XMPPPresence *presence=[XMPPPresence presence];
    NSLog(@"%@",presence);
    //把在线情况发送给服务器
    [_xmppStream sendElement:presence];
}
//离线消息
- (void)goOffline
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    
    [_xmppStream sendElement:presence];
}

#pragma mark 登录的方法
-(void)login:(XMPPResultBlock)xmppBlock
{
    //把block存起来
  
    _resultBlock=xmppBlock;
    //断开服务器重新连接
    [_xmppStream disconnect];
    //连接到主机
    [self connectToHost];
}
#pragma mark 退出登录的操作
-(void)xmppLoginOut
{
    [self goOffline];
    [_xmppStream disconnect];
    
    UserOperation *user=[UserOperation shareduser];
    user.userName=nil;
    user.password=nil;
    user.loginStatus=NO; //退出登录状态
    
    SubscribeOperation *subscribe = [SubscribeOperation sharedSubscribe];
    [subscribe clear];
}
#pragma mark 调用注册的方法
-(void)regist:(XMPPResultBlock)xmppType
{
    //把block保存起来
    _resultBlock=xmppType;
    //断开连接
    [_xmppStream disconnect];
    //连接主机
    [self connectToHost];
    
    
    
}
#pragma mark 注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    NSLog(@"注册成功");
    if(_resultBlock){
        _resultBlock(XMPPResultRegisterSuccess);
    }
}
#pragma mark 注册失败
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    
    NSLog(@"注册失败 %@",error);
    if(_resultBlock){
        DDXMLElement *errorElemment = [error elementForName:@"error"];
        int code = [errorElemment attributeIntValueForName:@"code"];
        if(code == 409) { //用户已存在
            _resultBlock(XMPPResultRegisterExist);
        }
        else {
            _resultBlock(XMPPResultRegisterFailture);
        }
        
    }
}
#pragma mark 接收到消息的事件
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
   // NSLog(@"有消息了! %@",message);
    // NSLog(@"接收到的离线信息是：%@",[self getDelayStampTime:message]);
    NSDate *date=[self getDelayStampTime:message];
    //如果不是消息的话
    if(date==nil){
        date=[NSDate date];
    }
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate=[formatter stringFromDate:date];
    //NSLog(@"离线消息 ：(%@)",strDate);
    
    XMPPJID *jid=[message from];
  
    
    //[jid user]; 通过这个行为可获得用户名
    //获得body里面的内容
    NSString *body=[[message elementForName:@"body"] stringValue];
    //NSLog(@"xmpp   %@",body);
    //body=[NSString stringWithFormat:@"%@:%@ %@",[jid user],body,strDate];
    //本地通知
    UILocalNotification *local=[[UILocalNotification alloc]init];
    local.alertBody=body;
    local.alertAction=body;
    //声音
    local.soundName=[[NSBundle mainBundle] pathForResource:@"shake_match" ofType:@"mp3"];
    //时区  根据用户手机的位置来显示不同的时区
    local.timeZone=[NSTimeZone defaultTimeZone];
    //开启通知
    [[UIApplication sharedApplication] scheduleLocalNotification:local];
    //发送一个通知
    if(body){
        NSDictionary *dict=@{@"username":[jid user],@"time":strDate,@"body":body,@"jid":jid,@"user":@"other"};
        NSNotification *note=[[NSNotification alloc]initWithName:SendMsgName object:dict userInfo:nil];
        [Mynotification postNotification:note];
    }
}

#pragma mark 发送消息的函数
-(void)sendMessage:(NSString *)_msg to:(NSString *)_toName{
    //创建一个xml
    //创建元素
    NSXMLElement *message=[[NSXMLElement alloc]initWithName:@"message"];
    //定制根元素的属性
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"from" stringValue:@"jack@localhost"];
    [message addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@%@",_toName,ServerName]];
    //创建一个子元素
    NSXMLElement *body=[[NSXMLElement alloc]initWithName:@"body"];
    [body setStringValue:_msg];
    [message addChild:body];
    //发送信息
    [_xmppStream sendElement:message];
    NSLog(@"%@",message);
}
#pragma mark 获得离线消息的时间

-(NSDate *)getDelayStampTime:(XMPPMessage *)message{
    //获得xml中德delay元素
    XMPPElement *delay=(XMPPElement *)[message elementsForName:@"delay"];
    if(delay){  //如果有这个值 表示是一个离线消息
        //获得时间戳
        NSString *timeString=[[ (XMPPElement *)[message elementForName:@"delay"] attributeForName:@"stamp"] stringValue];
        //创建日期格式构造器
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        //按照T 把字符串分割成数组
        NSArray *arr=[timeString componentsSeparatedByString:@"T"];
        //获得日期字符串
        NSString *dateStr=[arr objectAtIndex:0];
        //获得时间字符串
        NSString *timeStr=[[[arr objectAtIndex:1] componentsSeparatedByString:@"."] objectAtIndex:0];
        //构建一个日期对象 这个对象的时区是0
        NSDate *localDate=[formatter dateFromString:[NSString stringWithFormat:@"%@T%@+0000",dateStr,timeStr]];
        return localDate;
    }else{
        return nil;
    }
    
}

#pragma mark 获取所有注册的用户
- (void)searchByUserName:(NSString *)userName;
{
    //1.创建查询字段
    NSString *userBare1 = [[_xmppStream myJID] bare];
    NSXMLElement *query = [NSXMLElement elementWithName:@"query"];
    [query addAttributeWithName:@"xmlns" stringValue:@"jabber:iq:search"];
    
    //2.拓展字段，设置需要查询的字段（Username、Name、Email）
    NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:@"jabber:x:data"];
    [x addAttributeWithName:@"type" stringValue:@"submit"];
     [query addChild:x];
    
    NSXMLElement *formType = [NSXMLElement elementWithName:@"field"];
    [formType addAttributeWithName:@"type" stringValue:@"hidden"];
    [formType addAttributeWithName:@"var" stringValue:@"FORM_TYPE"];
    [formType addChild:[NSXMLElement elementWithName:@"value" stringValue:@"jabber:iq:search"]];
    [x addChild:formType];
    
    //设置需要查询用户名字段
    NSXMLElement *userNameElement = [NSXMLElement elementWithName:@"field"];
    [userNameElement addAttributeWithName:@"var" stringValue:@"Username"];
    [userNameElement addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
    [x addChild:userNameElement];
    
    //设置需要查询用户昵称
    NSXMLElement *nameElement = [NSXMLElement elementWithName:@"field"];
    [nameElement addAttributeWithName:@"var" stringValue:@"Name"];
    [nameElement addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
    [x addChild:nameElement];
    
    //设置需要查询邮箱字段
    NSXMLElement *emailElement = [NSXMLElement elementWithName:@"field"];
    [emailElement addAttributeWithName:@"var" stringValue:@"Email"];
    [emailElement addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
    [x addChild:emailElement];
    //Here in the place of SearchString we have to provide registered user name or emailid or username(if it matches in Server it provide registered user details otherwise Server provides response as empty)
    
    //3.设置查询内容
    NSXMLElement *search = [NSXMLElement elementWithName:@"field"];
    [search addAttributeWithName:@"var" stringValue:@"search"];
    [search addChild:[NSXMLElement elementWithName:@"value" stringValue:[NSString stringWithFormat:@"%@", userName]]];
    [x addChild:search];
    
    //4.设置iq
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    [iq addAttributeWithName:@"type" stringValue:@"set"];
    [iq addAttributeWithName:@"id" stringValue:SEARCH_BY_USERNAME];
    [iq addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"search.%@",ServerName]];
    [iq addAttributeWithName:@"from" stringValue:userBare1];
    [iq addChild:query];
    [_xmppStream sendElement:iq];
}

#pragma mark 服务器返回请求结果
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    NSString *id = [iq elementID];

    if ([SEARCH_BY_USERNAME  isEqual: id]) //用户搜索
    {
        NSMutableArray *dataArray = [self parseUserSearchXml:iq];
        [[NSNotificationCenter defaultCenter] postNotificationName:RESULT_USERNAME_SEARCH object:dataArray];
    }
   
    return true;
}

#pragma mark 解析用户搜索返回的结果
- (NSMutableArray *)parseUserSearchXml:(XMPPIQ *)iq
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    
    NSXMLElement *queryElement = [iq elementForName:@"query"];
    NSXMLElement *xElement = [queryElement elementForName:@"x" xmlns:@"jabber:x:data"];
    NSArray *array = [xElement elementsForName:@"item"];
    
    for (NSUInteger i = 0; i < array.count; i++)
    {
        NSXMLElement *itemElement = array[i];
        NSArray *filedArray = [itemElement elementsForName:@"field"];
        
        UserSearchModel *userModel = [[UserSearchModel alloc] init];
        for (NSUInteger j = 0; j < filedArray.count; j++)
        {
            NSXMLElement *filedElement = filedArray[j];
            NSString *var = [filedElement attributeStringValueForName:@"var"];
            if ([var isEqualToString:@"Email"])
            {
                userModel.email = [filedElement stringValue];
            }
            else if([var isEqualToString:@"jid"])
            {
                userModel.jid = [XMPPJID jidWithString:[filedElement stringValue]];
            }
            else if([var isEqualToString:@"Username"])
            {
                userModel.userName = [filedElement stringValue];
            }
            else if ([var isEqualToString:@"Name"])
            {
                userModel.nickName = [filedElement stringValue];
            }
        }
        
        UserOperation *user = [UserOperation shareduser];
        NSString *meName = user.userName;
        if ([meName isEqualToString:userModel.userName])
        {
            userModel.isOwn = YES;
        }
        else
        {
            userModel.isOwn = NO;
        }
        
        XmppTools *xmpp = [XmppTools sharedxmpp];
        
        if ([xmpp.rosterStorage userExistsWithJID:[XMPPJID jidWithUser:userModel.userName domain:ServerName resource:nil] xmppStream:xmpp.xmppStream])
        {
            userModel.isAdded = YES;
        }
        else
        {
            userModel.isAdded = NO;
        }

        [mutableArray addObject:userModel];
    }

    return mutableArray;
}

- (void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender withVersion:(NSString *)version
{
    NSLog(@"XmppTools 开始检索好友列表");
    [[ContacterOperation sharedcontacter] clear];
}


- (void)xmppRosterDidEndPopulating:(XMPPRoster *)sender
{
     NSLog(@"XmppTools 好友列表检索完毕");
    [[NSNotificationCenter defaultCenter] postNotificationName:FRIEND_POPULATED object:nil];
}


- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(NSXMLElement *)item
{
    [[ContacterOperation sharedcontacter] addItem:item];
   
}

#pragma mark 收到好友请求
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    SubscribeOperation *subscribe = [SubscribeOperation sharedSubscribe];
    if([subscribe addUser:presence.from])
    {
        //添加好友一定会订阅对方，但是接受订阅不一定要添加对方为好友
        [[NSNotificationCenter defaultCenter] postNotificationName:REQUEST_ADD_FPRIEND object:presence.from];
    }

}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    //unavailable需要处理，当用户不在线的时候，不要影响通讯录个数，只可以显示是否在线
    if ([presence.type isEqualToString:@"unsubscribe"]) {
    }
    
    //收到对方取消定阅我得消息
    if ([presence.type isEqualToString:@"unsubscribe"]) {
        //从我的本地通讯录中将他移除
        [self.roster removeUser:presence.from];
    } else if ([presence.type isEqualToString:@"subscribed"]) {
        //通知通讯录发生变化
    }
}

//#pragma mark  当对象销毁的时候
-(void)teardownXmpp
{
    //1.移除代理
    [_xmppStream removeDelegate:self];
    //2.停止模块
    [_reconnect deactivate];
    [_vCard deactivate];
    [self.vCard deactivate];
    [_avatar deactivate];
    [_reconnect deactivate];
    [_roster deactivate];
    //3.断开连接
    [_xmppStream disconnect];
    //4 清空对象
    _reconnect=nil;
    _vCard=nil;
    _vCardStorage=nil;
    _avatar=nil;
    _rosterStorage=nil;
    _roster=nil;
    _xmppStream=nil;
}
-(void)dealloc
{
    [self teardownXmpp];
}



@end
