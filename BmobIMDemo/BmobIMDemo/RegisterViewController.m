//
//  RegisterViewController.m
//  BmobIMDemo
//
//  Created by Bmob on 14-6-25.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import "RegisterViewController.h"
#import "CommonUtil.h"
#import "MBProgressHUD.h"
#import <BmobSDK/Bmob.h>
#import <BmobIM/BmobUserManager.h>
#import <BmobSDK/BmobGPSSwitch.h>
#import "Location.h"
#import "UserService.h"

@interface RegisterViewController ()<UITextFieldDelegate,LocationDelegate>

@end

@implementation RegisterViewController

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
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.titleView = [CommonUtil navigationTitleViewWithTitle:@"注册"];
    UIImageView  *loginBackgroundImageView = [[UIImageView alloc] init];
    loginBackgroundImageView.frame         = CGRectMake(0, ViewOriginY + 24, 320, 125);
    loginBackgroundImageView.image         = [[UIImage imageNamed:@"login_input"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [self.view addSubview:loginBackgroundImageView];
    
    UILabel *ncLabel                  = [[UILabel alloc] init];
    ncLabel.backgroundColor           = [UIColor clearColor];
    ncLabel.font                      = [UIFont boldSystemFontOfSize:15];
    ncLabel.textColor                 = RGB(60, 60, 60, 1.0f);//[CommonUtil setColorByR:60 G:60 B:60];
    ncLabel.frame                     = CGRectMake(12, ViewOriginY + 42,70, 14);
    ncLabel.text                      = @"用户名";
    ncLabel.textAlignment             = NSTextAlignmentRight;
    [self.view addSubview:ncLabel];
    
    UITextField     *ncTextField = [[UITextField alloc] init];
    ncTextField.frame            = CGRectMake(88, ViewOriginY + 39, 210, 17.5);
    ncTextField.font             = [CommonUtil setFontSize:14];
    ncTextField.backgroundColor  = [UIColor clearColor];
    ncTextField.clearButtonMode  = UITextFieldViewModeWhileEditing;
    ncTextField.placeholder      = @"请输入用户名";
    ncTextField.returnKeyType    = UIReturnKeyNext;
    //    ncTextField.keyboardType = UIKeyboardTypeNumberPad;
    ncTextField.delegate         = self;
    [self.view addSubview:ncTextField];
    ncTextField.tag              = 101;
    
    UIImageView   *lineImageView = [[UIImageView alloc] init];
    lineImageView.frame = CGRectMake(0, ViewOriginY + 67, 320, 1);
    lineImageView.image = [UIImage imageNamed:@"common_line"];
    [self.view addSubview:lineImageView];
    UILabel *pswLabel                  = [[UILabel alloc] init];
    pswLabel.backgroundColor           = [UIColor clearColor];
    pswLabel.font                      = [UIFont boldSystemFontOfSize:15];
    pswLabel.textColor                 = RGB(60, 60, 60, 1.0f);//[CommonUtil setColorByR:60 G:60 B:60];
    pswLabel.frame                     = CGRectMake(12,ViewOriginY + 82,70, 17);
    pswLabel.text                      = @"密码";
    pswLabel.textAlignment             = NSTextAlignmentRight;
    [self.view addSubview:pswLabel];
    UITextField     *pwsTextField = [[UITextField alloc] init];
    pwsTextField.frame            = CGRectMake(88, ViewOriginY + 82, 210, 17);
    pwsTextField.font             = [CommonUtil setFontSize:14];
    pwsTextField.backgroundColor  = [UIColor clearColor];
    pwsTextField.clearButtonMode  = UITextFieldViewModeWhileEditing;
    pwsTextField.placeholder      = @"请输入密码";
    pwsTextField.returnKeyType    = UIReturnKeyNext;
    pwsTextField.secureTextEntry  = YES;
    pwsTextField.delegate         = self;
    [self.view addSubview:pwsTextField];
    pwsTextField.tag              = 102;
    UIImageView   *lineImageView1 = [[UIImageView alloc] init];
    lineImageView1.frame = CGRectMake(0, ViewOriginY + 108, 320, 1);
    lineImageView1.image = [UIImage imageNamed:@"common_line"];
    [self.view addSubview:lineImageView1];
    UILabel *pswLabel1                  = [[UILabel alloc] init];
    pswLabel1.backgroundColor           = [UIColor clearColor];
    pswLabel1.font                      = [UIFont boldSystemFontOfSize:15];
    pswLabel1.textColor                 = RGB(60, 60, 60, 1.0f);//[CommonUtil setColorByR:60 G:60 B:60];
    pswLabel1.frame                     = CGRectMake(12,ViewOriginY + 120,70, 17);
    pswLabel1.text                      = @"确认密码";
    [self.view addSubview:pswLabel1];
    pswLabel1.textAlignment             = NSTextAlignmentRight;
    
    UITextField     *pwsTextField1 = [[UITextField alloc] init];
    pwsTextField1.frame            = CGRectMake(88, ViewOriginY + 120, 210, 17);
    pwsTextField1.font             = [CommonUtil setFontSize:14];
    pwsTextField1.backgroundColor  = [UIColor clearColor];
    pwsTextField1.clearButtonMode  = UITextFieldViewModeWhileEditing;
    pwsTextField1.placeholder      = @"请再次新密码";
    pwsTextField1.returnKeyType    = UIReturnKeyDone;
    pwsTextField1.secureTextEntry  = YES;
    pwsTextField1.delegate         = self;
    [self.view addSubview:pwsTextField1];
    pwsTextField1.tag              = 103;
    
    MBProgressHUD *hud             = [[MBProgressHUD alloc] initWithView:self.view];
    hud.tag                        = kMBProgressTag;
    [self.view addSubview:hud];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goback{
    [super goback];
    self.navigationController.navigationBarHidden = YES;
}

-(void)dealloc{
    [Location shareInstance].delegate = nil;
}

-(void)registerToBeAMember{
    
    //启动定位
//    [[Location shareInstance] startUpdateLocation];
//    [Location shareInstance].delegate = self;
//    [self performSelector:@selector(registerAfterStartLocation) withObject:nil afterDelay:0.6f];
    
    UITextField     *ncTextField   = (UITextField *)[self.view viewWithTag:101];
    UITextField     *pwsTextField  = (UITextField *)[self.view viewWithTag:102];
    UITextField     *pwsTextField1 = (UITextField *)[self.view viewWithTag:103];
    
    MBProgressHUD *hud = (MBProgressHUD*)[self.view viewWithTag:kMBProgressTag];
    if (![pwsTextField.text isEqualToString:pwsTextField1.text]) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"两次输入的密码不一样!";
        [hud show:YES];
        [hud hide:YES afterDelay:0.7f];
        return;
    }
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"注册中...";
    [hud show:YES];
    [hud hide:YES afterDelay:10.0f];
    [UserService registerWithUsernameInBackground:ncTextField.text
                                         password:pwsTextField.text
                                  locateSucessful:NO
                                            block:^(BOOL isSuccessful, NSError *error) {
                                                
                                                [[Location shareInstance] stopUpateLoaction];
                                                if (isSuccessful) {
                                                    hud.mode = MBProgressHUDModeText;
                                                    hud.labelText = @"注册成功";
                                                    [hud hide:YES afterDelay:0.7f];
                                                    
                                                    [self dismissViewControllerAnimated:YES completion:^{
                                                    }];
                                                    
                                                }else{
                                                    hud.mode = MBProgressHUDModeText;
                                                    hud.labelText =[[error userInfo] objectForKey:@"error"];
                                                    [hud hide:YES afterDelay:0.7f];
                                                }
                                            }];
}

#pragma locationDelegate
-(void)didUpdateLocation:(Location *)loc{
    [self registerAfterStartLocation:YES];
}

-(void)didFailWithError:(NSError *)error location:(Location *)loc{
    [self registerAfterStartLocation:NO];
}

-(void)registerAfterStartLocation:(BOOL)successful{
   
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    UITextField     *pwsTextField  = (UITextField *)[self.view viewWithTag:102];
    UITextField     *pwsTextField1 = (UITextField *)[self.view viewWithTag:103];
    if (textField.tag == 101) {
        [pwsTextField becomeFirstResponder];
    }else if (textField.tag == 102){
        [pwsTextField1 becomeFirstResponder];
    }else{
        [self registerToBeAMember];
    }
    return YES;
}

@end
