//
//  LoginController.m
//  XmppDemo
//
//  Created by clq on 16/1/13.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "LoginController.h"
#import "MyTextFiled.h"
#import "UserOperation.h"
#import "MyTarBarController.h"
#import "RegisterController.h"

#define commonMargin 20
#define marginX 20
#define textFieldWidth (ScreenWidth - 2*marginX)
#define textFieldHeigt 30

@interface LoginController () <UITextFieldDelegate>

@property (nonatomic,weak) UIButton *loginBtn;
@property (nonatomic,weak) MyTextFiled *userNameTextField;
@property (nonatomic,weak) MyTextFiled *passwordTextField;

@end

@implementation LoginController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Login_text_siginWeChat", comment:@"登陆微信");
    //添加子控件
    [self setupChild];
    //添加手势
    [self addGesture];
    //添加通知
    [self addNotification];
}

- (void)setupChild
{
    //1.添加用户输入框
    MyTextFiled *username = [[MyTextFiled alloc] init];
    username.delegate = self;
    username.frame = CGRectMake(marginX, commonMargin, textFieldWidth, textFieldHeigt);
    username.image = @"login_username_icon";
    username.customPlaceholder = NSLocalizedString(@"Login_text_userNameTip", comment:@"请输入用户名/手机号");
    [self.view addSubview:username];
    self.userNameTextField = username;
    //2.添加下划线
    CGFloat fisrtLineY = commonMargin + textFieldHeigt + 10;
    [self addBottomLineWith:CGRectMake(marginX, fisrtLineY, textFieldWidth, 0.5)];
    //3.添加密码输入框
    MyTextFiled *password = [[MyTextFiled alloc] init];
    password.delegate = self;
    password.image = @"login_password_icon";
    CGFloat passwordY = fisrtLineY + 10;
    password.frame = CGRectMake(marginX, passwordY, textFieldWidth, textFieldHeigt);
    password.customPlaceholder = NSLocalizedString(@"Login_text_passwordTip", comment:@"请输入密码");
    [self.view addSubview:password];
    self.passwordTextField = password;
    //4.添加下划线
    CGFloat secondLineY = passwordY + textFieldHeigt + 10;
    [self addBottomLineWith:CGRectMake(marginX, secondLineY, textFieldWidth, 0.5)];
    //5.添加登陆按钮
    CGFloat loginY = secondLineY + 20;
    [self addLoginBtn:CGRectMake(marginX, loginY, textFieldWidth, 40)];
    //6.添加注册按钮
    CGFloat registerW = 40;
    CGFloat registerH = 30;
    CGFloat registerX = (ScreenWidth - registerW) * 0.5;
    CGFloat registerY = self.view.height - 64 - registerH - 10;
    [self addRegisterBtn:CGRectMake(registerX, registerY, registerW, registerH)];
    
}

- (void)addNotification
{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledChage) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addBottomLineWith:(CGRect)bounds
{
    UIImageView *line = [[UIImageView alloc] initWithFrame:bounds];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
}

- (void)addLoginBtn:(CGRect)bounds
{
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:bounds];
    self.loginBtn = loginBtn;
    loginBtn.enabled = NO;
    [loginBtn setBackgroundImage:[UIImage resizedImage:@"common_greenbtn"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage resizedImage:@"common_greenbtnHL"] forState:UIControlStateHighlighted];
    [loginBtn setBackgroundImage:[UIImage resizedImage:@"common_greenbtnDis"] forState:UIControlStateDisabled];
    
    [loginBtn setTitle:NSLocalizedString(@"Login_text_sigin", comment:@"登陆") forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5] forState:UIControlStateDisabled];
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loginBtn];
}

- (void)addRegisterBtn:(CGRect)bounds
{
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:bounds];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [registerBtn setTitle:NSLocalizedString(@"Login_text_register", comment:@"注册") forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor colorWithRed:71/255.0 green:61/255.0 blue:139/255.0 alpha:0.8] forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor colorWithRed:0 green:1.0 blue:1.0 alpha:1.0] forState:UIControlStateHighlighted];
    [registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
}

- (void)textFiledChage
{
    if(self.passwordTextField.text.length != 0 && self.userNameTextField.text.length != 0)
    {
        self.loginBtn.enabled = YES;
    }
    else {
        self.loginBtn.enabled = NO;
    }
}

- (void)addGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
}

- (void)tapClick:(id)sender
{
    [self.view endEditing:YES];
}

- (void)loginBtnClick
{
    NSString *username =   [NSString Trim:self.userNameTextField.text];
    NSString *password = [NSString Trim:self.passwordTextField.text];
    
    UserOperation *user = [UserOperation shareduser];
    user.userName = username;
    user.password = password;
    
    XmppTools *xmpp = [XmppTools sharedxmpp];
    xmpp.registerOperation = NO;
    //把block转成弱应用
    __weak typeof(self) selfVc=self;
    
    //显示登陆中。。。
    [BaseMethod showMessage:NSLocalizedString(@"Login_toast_signining", comment:@"登录中...") toView:self.view];
    [xmpp login:^(XMPPResultType xmppType) {
        [selfVc handle:xmppType];
    }];
    
}

- (void)handle:(XMPPResultType)xmppType
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [BaseMethod hideFormView:self.view];
        
        switch (xmppType) {
            case XMPPResultSuccess:
                {
                    [BaseMethod showSuccess:NSLocalizedString(@"Login_toast_signinSuccess", comment:@"登录成功") toView:self.view];;
                    UserOperation *user = [UserOperation shareduser];
                    [FmbdMessage initWithUser:user.userName];
                    [FmdbTool initWithUser:user.userName];
                    [self enterHome];
                }
                break;
            case XMPPResultFaiture:
                [BaseMethod showError:NSLocalizedString(@"Login_error_signinSuccess", comment:@"用户名或密码错误") toView:self.view];
                break;
            case XMPPResultNetworkErr:
                [BaseMethod showError:NSLocalizedString(@"Login_error_networkSuck", comment:@"网络不给力") toView:self.view];
                break;
            default:
                break;
        }
    });
}

- (void)enterHome
{
    //保存登陆状态
    UserOperation *user = [UserOperation shareduser];
    user.loginStatus = 1;
    
    //清空输入框里面的文字
    self.userNameTextField.text = nil;
    self.passwordTextField.text = nil;
    [self dismissViewControllerAnimated:NO completion:nil];
    
    //跳转到主页面
    MyTarBarController *tabbar = [[MyTarBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabbar;
}

- (void)registerBtnClick
{
    RegisterController *registerVC = [[RegisterController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Login_text_return", comment:@"返回") style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)dealloc
{
    [self removeNotification];
}

@end
