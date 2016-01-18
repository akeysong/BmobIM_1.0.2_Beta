//
//  PersonalProfileViewController.m
//  BmobIMDemo
//
//  Created by Bmob on 14-7-26.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import "PersonalProfileViewController.h"
#import "BmobIMDemoConfig.h"
#import <BmobIM/BmobChatManager.h>

@interface PersonalProfileViewController (){
    NearInfo   *_myNearInfo;
}

@end

@implementation PersonalProfileViewController

#pragma mark -- life cycle

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

-(instancetype)initWithInfomation:(NearInfo*)info{
    self = [super init];
    
    if (self) {
        _myNearInfo = [[NearInfo alloc] init];
        _myNearInfo = info;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(242, 242, 246, 1);
    self.navigationItem.titleView = [CommonUtil navigationTitleViewWithTitle:@"详细资料"];
    
    [self setupViews];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.tag            = kMBProgressTag;
    [self.view addSubview:hud];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goback{
    [super goback];
    
    _myNearInfo = nil;
}

#pragma mark - some action
-(void )setupViews{
    UIView *headView             = [[UIView alloc] initWithFrame:CGRectMake(0, ViewOriginY, 320, 71)];
    headView.backgroundColor     = [UIColor whiteColor];
    //头像
    UIImageView *avatarImageView = [[UIImageView alloc] init];
    avatarImageView.frame        = CGRectMake(11, 10, 50, 50);
    [avatarImageView.layer setMasksToBounds:YES];
    [avatarImageView.layer setCornerRadius:25];
    [headView addSubview:avatarImageView];
    [avatarImageView sd_setImageWithURL:[NSURL URLWithString:_myNearInfo.avatarString] placeholderImage:[UIImage imageNamed:@"setting_head"]];
    
    //名字
    UILabel *nameLabel           = [[UILabel alloc] init];
    nameLabel.backgroundColor    = [UIColor clearColor];
    nameLabel.textColor          = RGB(60, 60, 60, 1.0f);
    nameLabel.font               = [UIFont boldSystemFontOfSize:17];
    nameLabel.frame              = CGRectMake(75, 19, 75, 18);
    [nameLabel setText:_myNearInfo.name];
    [headView addSubview:nameLabel];
    
    //性别
    UIImageView *genderImageView = [[UIImageView alloc] init];
    genderImageView.frame        = CGRectMake(150, 19, 15, 15);
    [headView addSubview:genderImageView];

    [self.view addSubview:headView];


    UIButton *askButton         = [UIButton buttonWithType:UIButtonTypeCustom];
    askButton.frame             = CGRectMake(15, ViewOriginY+90, 290, 44);
    [askButton setBackgroundImage:[UIImage imageNamed:@"login_btn"] forState:UIControlStateNormal];
    [askButton setBackgroundImage:[UIImage imageNamed:@"login_btn_"] forState:UIControlStateHighlighted];
    [askButton setTitle:@"添加好友" forState:UIControlStateNormal];
    [askButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[askButton titleLabel] setFont:[UIFont boldSystemFontOfSize:18]];
    [askButton addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:askButton];
}


-(void)addFriend{
    MBProgressHUD *hud =(MBProgressHUD*) [self.view viewWithTag:kMBProgressTag];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"添加好友中";
    [hud show:YES];
    [hud hide:YES afterDelay:10.0f];
    
    [[BmobChatManager currentInstance] sendMessageWithTag:TAG_ADD_CONTACT targetId:_myNearInfo.objectId block:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"添加请求已发送";
            [hud hide:YES afterDelay:0.7f];
        }else{
            hud.mode = MBProgressHUDModeText;
            hud.labelText =[[error userInfo] objectForKey:@"error"];
            [hud hide:YES afterDelay:0.7f];
        }
    }];
}

@end
