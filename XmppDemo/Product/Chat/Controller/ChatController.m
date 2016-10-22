//
//  ChatController.m
//  XmppDemo
//
//  Created by clq on 16/1/13.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "ChatController.h"
#import "ChatCustomView.h"
#import "ChatBottomView.h"
#import "ChatViewCell.h"
#import "SendTextView.h"
#import "MessageFrameModel.h"
#import "MessageModel.h"
#import "ContacterModel.h"
#import "AddOtherView.h"


@interface ChatController ()<UITableViewDataSource, UITableViewDelegate,NSFetchedResultsControllerDelegate, UITextViewDelegate, ChatBottomViewDelegate, LQImgPickerActionSheetDelegate, AddOtherViewDelegate>

//底部栏控件
@property (nonatomic,weak) ChatBottomView *chatBottomView;
@property (nonatomic,weak) SendTextView *sendTextView;
@property (nonatomic,strong) HMEmotionKeyboard *keyboard;
@property (nonatomic,strong) AddOtherView *addOtherView;
@property (nonatomic,strong) LQImgPickerActionSheet *imgPickActionSheet;

//主视图
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSData *headImage;
@property (nonatomic,assign) CGFloat tableViewHeight;
@property (nonatomic,assign) BOOL isChageHeight;
@property (nonatomic,assign) BOOL isChangeKeyboard;

//数据
@property (nonatomic,strong) NSMutableArray *frameModelArr;
@property (nonatomic,strong) NSFetchedResultsController *resultController;

@property (nonatomic,strong) NSMutableDictionary *dateDic; //存储上次时间，用于判断是否显示时间

@end

@implementation ChatController

#pragma 初始化
- (void)viewDidLoad
{
    [super viewDidLoad];
    //1.初始化界面
    [self setupUI];
    //2.添加通知
    [self addNotification];
    //3.添加手势
    [self addGesture];
    //4.加载数据
    [self setupData];
}

- (NSMutableArray *)frameModelArr
{
    if (_frameModelArr == nil) {
        _frameModelArr = [NSMutableArray array];
    }
    
    return _frameModelArr;
}

- (NSMutableDictionary *)dateDic
{
    if (_dateDic == nil) {
        _dateDic = [NSMutableDictionary dictionary];
    }
    
    return _dateDic;
}

- (HMEmotionKeyboard *)keyboard
{
    if (_keyboard == nil) {
        _keyboard = [HMEmotionKeyboard keyboard];
        _keyboard.width = ScreenWidth;
        _keyboard.height = 216;
    }
    
    return _keyboard;
}

- (AddOtherView *)addOtherView
{
    if (_addOtherView == nil) {
        _addOtherView = [AddOtherView defaultView];
        _addOtherView.delegate = self;
    }
    
    return _addOtherView;
}

- (LQImgPickerActionSheet *)imgPickActionSheet
{
    if (_imgPickActionSheet == nil) {
        _imgPickActionSheet = [[LQImgPickerActionSheet alloc] init];
        _imgPickActionSheet.delegate = self;
        _imgPickActionSheet.maxCount = 1;
    }
    
    return _imgPickActionSheet;
}

- (void)setupUI
{
    //1.设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //2.添加tableview
    [self setupTableView];
    //3.添加bottomview
    [self setupBottomView];
    
}

- (void)setupTableView
{
    if (self.tableView == nil) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.allowsSelection = NO; //单元格不可以被选中
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone; //去掉分割线
        tableView.dataSource = self;
        tableView.delegate = self;
        CGFloat tableH = self.view.height - 64 - BOTTOMVIEW_HEIGHT;
        self.tableViewHeight = tableH;
        tableView.frame = CGRectMake(0, 0, ScreenWidth, tableH);
        tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        [self.view addSubview:tableView];
        self.tableView = tableView;
    }
}

- (void)setupBottomView
{
    ChatBottomView *bottomView = [[ChatBottomView alloc] init];
    bottomView.sendTextView.delegate = self;
    bottomView.delegate = self;
    bottomView.x = 0;
    bottomView.y = self.view.height - 64 - bottomView.height;
    [self.view addSubview:bottomView];
    self.chatBottomView = bottomView;
    self.sendTextView = bottomView.sendTextView;
}

- (void)addNotification
{
    //监听键盘显示隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardApear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //监听表情选中
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:HMEmotionDidSelectedNotification object:nil];
    //监听删除按钮点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidDeleted:) name:HMEmotionDidDeletedNotification object:nil];
    //监听表情发送按钮点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(faceSend:) name:FaceSendButton object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addGesture
{
    UITapGestureRecognizer *singleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleClick:)];
    singleGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleGesture];
}

- (void)singleClick:(UITapGestureRecognizer *)recoginzer
{
    [self.view endEditing:YES];
}

- (void)setContacterModel:(ContacterModel *)contacterModel
{
    _contacterModel = contacterModel;
}

//加载聊天数据
- (void)setupData
{
    UserOperation *user = [UserOperation shareduser];
    NSString *myJid = [NSString stringWithFormat:@"%@@%@",user.userName,ServerName];
    
    XmppTools *xmpp = [XmppTools sharedxmpp];
    self.headImage = xmpp.vCard.myvCardTemp.photo;
    
    //1.创建上下文
    NSManagedObjectContext *context = xmpp.messageStroage.mainThreadManagedObjectContext;
    //2.创建请求对象
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    //3.设置过滤条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ and bareJidStr = %@",myJid,_contacterModel.jid.bare];
    fetchRequest.predicate = predicate;
    //4.排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    fetchRequest.sortDescriptors = @[sort];
    //5.查询
    self.resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    self.resultController.delegate = self;
    NSError *error = nil;
    [self.resultController performFetch:&error];
    
    if (error == nil) {
        if (self.resultController.fetchedObjects.count > 0) {
            //1.数据转模型
            [self dataToModel];
            //2.滚到最后一行
            [self scrollToBottom];
        }
    }
    else {
        NSLog(@"fecth error=%@",error.localizedDescription);
    }
}

- (void)dataToModel
{
    for (XMPPMessageArchiving_Message_CoreDataObject *msg in self.resultController.fetchedObjects) {
        MessageFrameModel *msgFrameModel = [self msgToMessageFrameModel:msg];
        [self.frameModelArr addObject:msgFrameModel];
    }
}

- (MessageFrameModel *)msgToMessageFrameModel:(XMPPMessageArchiving_Message_CoreDataObject *)msg
{
    MessageModel *msgModel = [[MessageModel alloc] init];
    msgModel.bodyType = [msg.message attributeStringValueForName:@"bodyType"];
    msgModel.body = msg.body;
    msgModel.time = [NSString stringWithFormat:@"%@",msg.timestamp];
    msgModel.otherPhoto = self.photoImg;
    msgModel.headImage = self.headImage;
    msgModel.to = msg.bareJidStr;
    msgModel.isOwner = [[msg outgoing] boolValue];
    msgModel.isHiddenTime = [self isHiddenTime:msg.timestamp toUser:msg.bareJidStr];
    
    MessageFrameModel *msgFrameModel = [[MessageFrameModel alloc] init];
    msgFrameModel.messageModel = msgModel;
    
    return msgFrameModel;
}

- (void)dataToModelWithMsg:(XMPPMessageArchiving_Message_CoreDataObject *)msg
{
    if (msg.body != nil) {
        MessageFrameModel *msgFrameModel = [self msgToMessageFrameModel:msg];
        [self.frameModelArr addObject:msgFrameModel];
        
        [self.tableView reloadData];
        [self scrollToBottom];
    }
}

- (Boolean)isHiddenTime:(NSDate*) date toUser:(NSString *)user
{
    Boolean isHiddenTime = NO;
    //同一分钟内，只显示一个时间
    NSDate *lastDate = [self.dateDic objectForKey:user];
    if(lastDate != nil)
    {
        BOOL bSameMinute = [date isSameMinute:lastDate];
        if(bSameMinute)
        {
            isHiddenTime = YES;
        }

    }
    
    [self.dateDic setObject:date forKey:user];
    
    return isHiddenTime;
}

- (void)scrollToBottom
{
    if (!(self.frameModelArr.count > 0)) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.frameModelArr.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma 通知事件
- (void)emotionDidSelected:(NSNotification *)notification
{
    HMEmotion *emotion = notification.userInfo[HMSelectedEmotion];
    [self.sendTextView appendEmotion:emotion];
    [self textViewDidChange:self.sendTextView];
}

- (void)emotionDidDeleted:(NSNotification *)notification
{
    [self.sendTextView deleteBackward];
}

- (void)faceSend:(NSNotification *)notification
{
    NSString *str = [NSString Trim:self.sendTextView.text];
    if (str.length < 1) {
        return;
    }
    
    [self sendMsgWithText:self.sendTextView.realText messageType:@"chat" bodyType:@"text"];
    self.sendTextView.text = nil;
}

- (void)keyboardApear:(NSNotification *)notification
{
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect keyboardF = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration animations:^{
        //滚到最后一行
        [self scrollToBottom];
        
        self.chatBottomView.transform = CGAffineTransformMakeTranslation(0, -keyboardF.size.height);
        
        //如果数组中的模型大于5个话，不需要改变tableview的高度，只需要改变位置
        if (self.frameModelArr.count > 5) {
            self.tableView.transform = CGAffineTransformMakeTranslation(0, -keyboardF.size.height);
        }
        else {
            if (self.isChageHeight == NO) {
                if (ScreenHeight < 568) { //iphone4s/4
                    self.tableView.height = self.tableView.height - keyboardF.size.height;
                }
                else { //5/5s/6/6+
                    self.tableView.height = self.tableView.height - BOTTOMVIEW_HEIGHT * 0.5 - keyboardF.size.height;
                }
                
                self.isChageHeight = YES;
            }
        }
        

    }];
}

- (void)keyboardHide:(NSNotification *)notification
{
    if (self.isChangeKeyboard) {
        return;
    }
    
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.chatBottomView.transform = CGAffineTransformIdentity;
        if (self.frameModelArr.count > 5) {
            self.tableView.transform = CGAffineTransformIdentity;
        }
        
        if (self.tableView.height < self.tableViewHeight) {
             self.tableView.height = self.tableViewHeight;
        }
        
        self.isChageHeight = NO;
    }];
}

#pragma 代理委事件
//NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    XMPPMessageArchiving_Message_CoreDataObject *msg = [self.resultController.fetchedObjects lastObject];
    [self dataToModelWithMsg:msg];
    
    //如果是当前用户发送通知
    if ([[msg outgoing] boolValue]) {
        NSString *userName = [NSString cutXmppPre:msg.bareJidStr];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *strDate = [formatter stringFromDate:msg.timestamp];
        
        NSDictionary *dic = @{@"username":userName,@"time":strDate,@"body":msg.body,@"jid":msg.bareJid,@"user":@"this"};
        
        //发送通知到首页
        NSNotification *notification = [[NSNotification alloc] initWithName:SendMsgName object:dic userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}
//UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    self.isChageHeight = YES; //避灾keyboardWillShow里面调整高度导致界面错乱
    
    NSString *body = [NSString Trim:textView.text];
    if ([text isEqualToString:@"\n"]) {
        if (![body isEqualToString:@""]) {
            [self sendMsgWithText:self.sendTextView.realText messageType:@"chat" bodyType:@"text"];
            self.sendTextView.text = nil;
        }
        
        return NO;
    }
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    
}
//发送聊天消息
- (void)sendMsgWithText:(NSString *)text messageType:(NSString *)messageType bodyType:(NSString *)bodyType {
    XMPPMessage *msg = [XMPPMessage messageWithType:messageType to:_contacterModel.jid];
    [msg addAttributeWithName:@"bodyType" stringValue:bodyType];
    [msg addBody:text];
    
    XmppTools *xmpp = [XmppTools sharedxmpp];
    [xmpp.xmppStream sendElement:msg];
}

#pragma mark ChatBottomViewDelegate
- (void)chatBottomView:(ChatBottomView *)bottomView buttonTag:(BottomButtonType)buttonTag
{
    switch (buttonTag) {
        case BottomButtonTypeEmotion:
            [self openEmotion];
            break;
        case BottomButtonTypeAddPicture:
            [self addPicture];
            break;
            
        case BottomButtonTypeAudio:
            break;
        default:
            break;
    }
}
//打开表情键盘
- (void)openEmotion
{
    self.isChangeKeyboard = YES;
    if (self.sendTextView.inputView) {  //自定义的键盘
        self.sendTextView.inputView = nil;
        self.chatBottomView.emotionStatus = NO;
    }
    else { //系统自带的键盘
        self.sendTextView.inputView = self.keyboard;
        self.chatBottomView.emotionStatus = YES;
    }
    
    [self.sendTextView resignFirstResponder];
    self.isChangeKeyboard = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.sendTextView becomeFirstResponder];
    });

}
//打开添加图片
- (void)addPicture
{
    self.isChangeKeyboard = YES;
    if (self.sendTextView.inputView) {  //自定义的键盘
        self.sendTextView.inputView = nil;
        self.chatBottomView.addStatus = NO;
    }
    else { //系统自带的键盘
        self.sendTextView.inputView = self.addOtherView;
        self.chatBottomView.addStatus = YES;
    }
    
    [self.sendTextView resignFirstResponder];
    self.isChangeKeyboard = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.sendTextView becomeFirstResponder];
    });
}

#pragma mark AddOtherViewDelegate

- (void)addOtherView:(AddOtherView *)addOtherView buttonTag:(AddButtonType)buttonTag
{
    switch (buttonTag) {
        case AddButtonTypePhoto:
            [self addPhoto];
            break;
            
        case AddButtonTypeCamera:
            [self openCamera];
            break;
        
        case AddButtonTypeVideo:
            [self addVideo];
            break;
        
        case AddButtonTypeLocation:
            [self openMap];
            break;
    }
}

- (void)addPhoto
{
    [self.imgPickActionSheet showImgPickerActionSheetInView:self];
}

- (void)openCamera
{
    
}

- (void)addVideo
{
    
}

- (void)openMap
{
    
}

#pragma mark LQImgPickerActionSheetDelegate
//相册完成选择得到的图片
- (void)getSelectImgWithALAssetArray:(NSArray*)ALAssetArray thumbnailImgImageArray:(NSArray*)thumbnailImgArray
{
    if (thumbnailImgArray.count > 0) {
        UIImage *image = [thumbnailImgArray objectAtIndex:0];
        NSData *data = UIImageJPEGRepresentation(image, (CGFloat)1.0);
        NSString *base64str = [data base64EncodedStringWithOptions:0];
        [self sendMsgWithText:base64str messageType:@"chat" bodyType:@"image"];
    }
}

#pragma tableview设置
//返回有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.frameModelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatViewCell *cell = [ChatViewCell cellWithTableView:tableView identifier:@"chatviewcell"];
    cell.messageFrameModel = self.frameModelArr[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageFrameModel *msgFrameModel = self.frameModelArr[indexPath.row];
    return msgFrameModel.cellHeight;
}

//当视图滚动的时候，隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)dealloc
{
    [self removeNotification];
}
@end
