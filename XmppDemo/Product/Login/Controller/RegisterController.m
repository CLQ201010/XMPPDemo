//
//  RegisterController.m
//  XmppDemo
//
//  Created by clq on 16/1/15.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "RegisterController.h"
#import "MyTextFiled.h"
#import "MyTarBarController.h"

#define commonMargin 20
#define marginX 20
#define textFieldWidth (ScreenWidth - 2*marginX)
#define textFieldHeigt 30

@interface RegisterController ()<UITextFieldDelegate>

@property (nonatomic,weak) UIButton *registerBtn;
@property (nonatomic,weak) MyTextFiled *usernameTextField;
@property (nonatomic,weak) MyTextFiled *passwordTextField;

@end

@implementation RegisterController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Register_text_register", <#comment#>:@"注册");
    self.view.backgroundColor = [UIColor whiteColor];
    //1.添加子空间
    [self setupChild];
    //2.添加手势
    [self addGestrue];
    //3.添加通知
    [self addNotification];
}

- (void)setupChild
{
    //1.添加用户输入框
    MyTextFiled *username = [[MyTextFiled alloc] init];
    username.delegate = self;
    username.frame = CGRectMake(marginX, commonMargin, textFieldWidth, textFieldHeigt);
    username.image = @"login_username_icon";
    username.customPlaceholder = NSLocalizedString(@"Register_text_userNameTip", <#comment#>:@"请输入用户名/手机号");
    [self.view addSubview:username];
    self.usernameTextField = username;
    //2.添加下划线
    CGFloat fisrtLineY = commonMargin + textFieldHeigt + 10;
    [self addBottomLineWith:CGRectMake(marginX, fisrtLineY, textFieldWidth, 0.5)];
    //3.添加密码输入框
    MyTextFiled *password = [[MyTextFiled alloc] init];
    password.delegate = self;
    password.image = @"login_password_icon";
    CGFloat passwordY = fisrtLineY + 10;
    password.frame = CGRectMake(marginX, passwordY, textFieldWidth, textFieldHeigt);
    password.customPlaceholder = NSLocalizedString(@"Register_text_passwordTip", <#comment#>:@"请输入密码");
    [self.view addSubview:password];
    self.passwordTextField = password;
    //4.添加下划线
    CGFloat secondLineY = passwordY + textFieldHeigt + 10;
    [self addBottomLineWith:CGRectMake(marginX, secondLineY, textFieldWidth, 0.5)];
    //5.添加注册按钮
    CGFloat registerY = secondLineY + 20;
    [self addRegisterBtn:CGRectMake(marginX, registerY, textFieldWidth, 40)];
}

- (void)addRegisterBtn:(CGRect)bounds
{
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:bounds];
    self.registerBtn = registerBtn;
    registerBtn.enabled = NO;
    [registerBtn setBackgroundImage:[UIImage resizedImage:@"common_greenbtn"] forState:UIControlStateNormal];
    [registerBtn setBackgroundImage:[UIImage resizedImage:@"common_greenbtnHL"] forState:UIControlStateHighlighted];
    [registerBtn setBackgroundImage:[UIImage resizedImage:@"common_greenbtnDis"] forState:UIControlStateDisabled];
    
    [registerBtn setTitle:NSLocalizedString(@"Register_text_register", <#comment#>:@"注册") forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5] forState:UIControlStateDisabled];
    [registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:registerBtn];
}

- (void)addBottomLineWith:(CGRect)bounds
{
    UIImageView *line = [[UIImageView alloc] initWithFrame:bounds];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
}

- (void)addGestrue
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClcik:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
}

- (void)registerBtnClick
{
    NSString *username = [NSString Trim:self.usernameTextField.text];
    NSString *password = [NSString Trim:self.passwordTextField.text];
    //登陆的方法
    UserOperation *user = [UserOperation shareduser];
    user.userName = username;
    user.password = password;
    
    XmppTools *xmpp = [XmppTools sharedxmpp];
    xmpp.registerOperation = YES;
    //把block转成弱应用
   // __weak typeof(self) selfVc=self;
    //显示登陆中
    [BaseMethod showMessage:NSLocalizedString(@"Register_text_registering", <#comment#>:@"注册中...") toView:self.view];
    [self.view endEditing:YES];
    [xmpp regist:^(XMPPResultType xmppType) {
        [self handle:xmppType];
    }];
}

- (void)handle:(XMPPResultType)xmppType
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [BaseMethod hideFormView:self.view];
        switch (xmppType) {
            case XMPPResultRegisterSuccess:
                //[BaseMethod showMessage:@"恭喜您，注册成功" toView:self.view];
                [self endterHome];
                break;
            case XMPPResultRegisterFailture:
                [BaseMethod showError:NSLocalizedString(@"Register_error_registerFaild", <#comment#>:@"抱歉，注册失败，请重试...") toView:self.view];
                break;
            case XMPPResultRegisterExist:
                [BaseMethod showError:NSLocalizedString(@"Register_error_userExist", <#comment#>:@"用户已存在!") toView:self.view];
                break;
            case XMPPResultNetworkErr:
                [BaseMethod showError:NSLocalizedString(@"Register_error_networkAnomaly", <#comment#>:@"网络异常，请检查网络后重试") toView:self.view];
                break;
            default:
                break;
        }
    });
}

- (void)endterHome
{
    UserOperation *user = [UserOperation shareduser];
    user.loginStatus = 1; //登陆成功保存登陆状态
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    MyTarBarController *tabbar = [[MyTarBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabbar;
}

- (void)tapClcik:(id)sender
{
    [self.view endEditing:YES];
}

- (void)textFiledChage
{
    if(self.passwordTextField.text.length != 0 && self.usernameTextField.text.length != 0)
    {
        self.registerBtn.enabled = YES;
    }
    else {
        self.registerBtn.enabled = NO;
    }
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledChage) name:UITextFieldTextDidChangeNotification  object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    [self removeNotification];
}

@end
