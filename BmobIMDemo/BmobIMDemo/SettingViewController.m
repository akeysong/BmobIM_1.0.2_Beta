//
//  SettingViewController.m
//  BmobIMDemo
//
//  Created by Bmob on 14-6-25.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import "SettingViewController.h"
#import "CommonUtil.h"
#import <BmobSDK/Bmob.h>
#import <BmobIM/BmobDB.h>
#import "RecentTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    NSMutableDictionary     *_infoDic;
    UITableView             *_infoTableView;
    
}

@end

@implementation SettingViewController

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
        if (IS_iOS7) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [CommonUtil navigationTitleViewWithTitle:@"设置"];

    UIButton    *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame        = CGRectMake(13, ViewOriginY + 300, 294, 44);
    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"logout_btn"] forState:UIControlStateNormal];
    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"logout_btn_"] forState:UIControlStateHighlighted];
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [[logoutBtn titleLabel] setFont:[UIFont boldSystemFontOfSize:18]];
    [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:logoutBtn];
    
    _infoTableView                = [[UITableView alloc] init];
    _infoTableView.frame          = CGRectMake(0, ViewOriginY+20, 320, 152);
    _infoTableView.dataSource     = self;
    _infoTableView.delegate       = self;

    [self.view addSubview:_infoTableView];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)logout{

    [BmobUser logout];
    
    [[BmobDB currentDatabase] clearAllDBCache];
    
    [CommonUtil needLoginWithViewController:self animated:NO];
}

#pragma mark - UITableView Datasource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 65;
    }
    return 43;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        UILabel *firstLabel                 = [[UILabel alloc] init];
        firstLabel.backgroundColor = [UIColor clearColor];
        firstLabel.textColor       = RGB(60, 60, 60, 1.0f);
        firstLabel.font            = [UIFont boldSystemFontOfSize:15];
        [cell.contentView addSubview:firstLabel];
        firstLabel.tag = 100;
        
        UILabel *secLabel                 = [[UILabel alloc] init];
        secLabel.backgroundColor = [UIColor clearColor];
        secLabel.textColor       = RGB(136, 136, 136, 1.0f);
        secLabel.font            = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:secLabel];
        secLabel.tag = 101;
        
        UIImageView *avatarImageView = [[UIImageView alloc] init];
        [avatarImageView.layer setMasksToBounds:YES];
        [avatarImageView.layer setCornerRadius:20];
        [cell.contentView addSubview:avatarImageView];
        avatarImageView.tag = 102;
        
        [avatarImageView setHidden:YES];
    }
    
    UILabel *firstLabel = (UILabel*)[cell.contentView viewWithTag:100];
    
    firstLabel.frame = CGRectMake(13, cell.contentView.center.y-10, 40, 16);
    
    UILabel *secLabel = (UILabel*)[cell.contentView viewWithTag:101];
    
    secLabel.frame = CGRectMake(260, cell.contentView.center.y-8, 40, 16);
    
    UIImageView *avatarImageView = (UIImageView *)[cell.contentView viewWithTag:102];

    
    switch (indexPath.row) {
        case 0:{
            firstLabel.text = @"头像";
            [avatarImageView setHidden:NO];
            avatarImageView.frame = CGRectMake(240, 10, 40, 40);
            
            BmobUser *user = [BmobUser getCurrentUser];
            if ([user objectForKey:@"avatar"]) {

                [avatarImageView sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"setting_head"]];
            }else
                [avatarImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"setting_head"]];
        }
            break;
        case 1:{
            firstLabel.text = @"昵称";
        }
            break;
        case 2:{
            firstLabel.text = @"性别";
        }
            
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        [self updateAvatar];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark 

-(void)updateAvatar{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"相册",@"照相", nil];
    
    [as showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        return;
    }
    
    
    
    switch (buttonIndex) {
        case 0:{
            UIImagePickerController *pick = [[UIImagePickerController alloc] init];
            pick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pick.allowsEditing = YES;
            pick.delegate = self;
            
            [self presentViewController:pick animated:YES
                             completion:^{
                                 
                             }];
        }
            break;
        case 1:{
            UIImagePickerController *pick = [[UIImagePickerController alloc] init];
            pick.sourceType = UIImagePickerControllerSourceTypeCamera;
            pick.allowsEditing = YES;
            pick.delegate = self;
            
            [self presentViewController:pick animated:YES
                             completion:^{
                                 
                                 if (IS_iOS7) {
                                     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
                                 }
                                 
                             }];
        }
            break;
        default:
            break;
    }
    
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    BmobUser *user = [BmobUser getCurrentUser];
    BmobFile *file = [[BmobFile alloc] initWithFileName:@"avatar.jpg" withFileData:UIImageJPEGRepresentation(image, 0.8f)];

    [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [user setObject:file.url forKey:@"avatar"];
            [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                [_infoTableView reloadData];
            }];
        }
    } withProgressBlock:^(float progress) {
        NSLog(@"progress %.2f",progress);
    }];

    [picker dismissViewControllerAnimated:YES completion:^{
        if (IS_iOS7) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }
    }];

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        if (IS_iOS7) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }
    }];
}

@end
