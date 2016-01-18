//
//  LoginViewController.m
//  BmobIMDemo
//
//  Created by Bmob on 14-6-25.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import "LoginViewController.h"
#import "CommonUtil.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD.h"
#import "RegisterViewController.h"
#import <BmobIM/BmobUserManager.h>
#import "Location.h"
#import "UserService.h"
@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationController.navigationBarHidden = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor  = [UIColor whiteColor];
    
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.frame        = CGRectMake(95, StatueBarHeight+45, 130, 27);
    logoImageView.image        = [UIImage imageNamed:@"logo"];
    [self.view addSubview:logoImageView];
    
    UIImageView  *loginBackgroundImageView = [[UIImageView alloc] init];
    loginBackgroundImageView.frame         = CGRectMake(0, StatueBarHeight + 110, 320, 85);
    loginBackgroundImageView.image         = [[UIImage imageNamed:@"login_input"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [self.view addSubview:loginBackgroundImageView];
    
    UIImageView     *ncBackgroundImageView =[[UIImageView alloc] init];
    ncBackgroundImageView.frame  = CGRectMake(16, StatueBarHeight + 125,21, 21);
    ncBackgroundImageView.image  = [UIImage imageNamed:@"login_admin"];
    [self.view addSubview:ncBackgroundImageView];
    
    
    
    UITextField     *ncTextField = [[UITextField alloc] init];
    ncTextField.frame            = CGRectMake(54, StatueBarHeight + 125, 240, 20);
    ncTextField.font             = [CommonUtil setFontSize:14];
    ncTextField.backgroundColor  = [UIColor clearColor];
    ncTextField.clearButtonMode  = UITextFieldViewModeWhileEditing;
    ncTextField.placeholder      = @"请输入账号";
    ncTextField.returnKeyType    = UIReturnKeyNext;
    //    ncTextField.keyboardType     = UIKeyboardTypeNumberPad;
    ncTextField.delegate         = self;
    [self.view addSubview:ncTextField];
    
    ncTextField.tag              = 101;
    
    
    
    
    UIImageView   *lineImageView = [[UIImageView alloc] init];
    lineImageView.frame          = CGRectMake(51, StatueBarHeight + 152, 304, 1);
    lineImageView.image          = [UIImage imageNamed:@"common_line"];
    [self.view addSubview:lineImageView];
    
    UIImageView  *pswBackgroundImageView = [[UIImageView alloc] init];
    pswBackgroundImageView.frame         = CGRectMake(16, StatueBarHeight + 162,21, 21);
    pswBackgroundImageView.image         = [UIImage imageNamed:@"login_key"];
    [self.view addSubview:pswBackgroundImageView];
    
    UITextField     *pwsTextField = [[UITextField alloc] init];
    pwsTextField.frame            = CGRectMake(54, StatueBarHeight + 162, 240, 20);
    pwsTextField.font             = [CommonUtil setFontSize:14];
    pwsTextField.backgroundColor  = [UIColor clearColor];
    pwsTextField.clearButtonMode  = UITextFieldViewModeWhileEditing;
    pwsTextField.placeholder      = @"请输入密码";
    pwsTextField.returnKeyType    = UIReturnKeyDone;
    pwsTextField.secureTextEntry  = YES;
    pwsTextField.delegate         = self;
    [self.view addSubview:pwsTextField];
    pwsTextField.tag              = 102;
    
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame     = CGRectMake(13, StatueBarHeight + 240, 294, 43);
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"login_btn"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"login_btn_"] forState:UIControlStateHighlighted];
    
    loginBtn.tag       = 103;
    [self.view addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.enabled   = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldIsNull:) name:UITextFieldTextDidChangeNotification object:nil];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.tag = kMBProgressTag;
    [self.view addSubview:hud];

    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(13, StatueBarHeight + 300, 294, 33);
    [[registerBtn titleLabel] setFont:[CommonUtil setFontSize:14]];
    [registerBtn setTitle:@"还没有账号?前去注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:RGB(71, 156, 245, 1.0) forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(toRegisterMember) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];

    [self.view bringSubviewToFront:hud];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (IS_iOS7) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (IS_iOS7) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSUserDefaults standardUserDefaults ] setObject:[NSNumber numberWithBool:YES] forKey:@"isLogin"];
    
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)dealloc{
    [self.view endEditing:YES];
    [[NSUserDefaults standardUserDefaults ] setObject:[NSNumber numberWithBool:NO] forKey:@"isLogin"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
//    [[Location shareInstance] setDelegate:nil];
}

-(void)dismissSelf{
    [self.view endEditing:YES];
    [[NSUserDefaults standardUserDefaults ] setObject:[NSNumber numberWithBool:NO] forKey:@"isLogin"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark some action

-(void)toRegisterMember{
    RegisterViewController *rvc = [[RegisterViewController alloc] init];
   
    
    [self.navigationController pushViewController:rvc animated:YES];
    
     self.navigationController.navigationBarHidden = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

-(void)login{
    
    [self.view endEditing:YES];
    
    MBProgressHUD *hud = (MBProgressHUD *)[self.view viewWithTag:kMBProgressTag];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"登陆中...";
    [hud show:YES];
    [hud hide:YES afterDelay:10.0f];
    
    
    UITextField *tmpTextField = (UITextField *)[self.view viewWithTag:102];
    UITextField *tmpNcTextField = (UITextField *)[self.view viewWithTag:101];
    __weak typeof(self) weakSelf = self;
    //登陆
    [UserService logInWithUsernameInBackground:tmpNcTextField.text password:tmpTextField.text block:^(BmobUser *user, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                hud.labelText = [[error userInfo] objectForKey:@"error"];
                hud.mode = MBProgressHUDModeText;
                [hud show:YES];
                [hud hide:YES afterDelay:0.7f];
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
                [weakSelf dismissSelf];
            });
            
            [UserService saveFriendsList];
        }
    }];
    
    
//    [[Location shareInstance] startUpdateLocation];
//    [[Location shareInstance] setDelegate:self];
   
    
}

//-(void)didUpdateLocation:(Location *)loc{
//    
//}
//
//-(void)didFailWithError:(NSError *)error location:(Location *)loc{
//    [self loginAfterLocate];
//}
//
//-(void)loginAfterLocate{
//    NSLog(@"loginAfterLocate");
//    
//}

-(void)textFieldIsNull:(NSNotification*)noti{
    UITextField *tmpTextField = (UITextField *)[self.view viewWithTag:102];
    UITextField *tmpNcTextField = (UITextField *)[self.view viewWithTag:101];
    UIButton *loginBtn = (UIButton*)[self.view viewWithTag:103];
    if ([tmpNcTextField.text length ] == 0 ||[tmpTextField.text length ]==0 ) {
        loginBtn.enabled = NO;
    }else{
        loginBtn.enabled = YES;
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 101) {
        UITextField *tmpTextField = (UITextField *)[self.view viewWithTag:102];
        [tmpTextField becomeFirstResponder];
    }
    if (textField.tag == 102) {
        [self login];
    }
    
    return YES;
}

@end
