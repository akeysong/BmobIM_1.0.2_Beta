//
//  NewFriendViewController.m
//  BmobIMDemo
//
//  Created by Bmob on 14-6-26.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import "NewFriendViewController.h"
#import "ContactsViewController.h"
#import <BmobIM/BmobDB.h>
#import "ContactTableViewCell.h"
#import "CommonUtil.h"
#import <BmobIM/BmobUserManager.h>
#import "MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface NewFriendViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView         *_newFriendTableView;
    
    NSMutableArray      *_newFriendsArray;
}

@end

@implementation NewFriendViewController

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
        _newFriendsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [CommonUtil navigationTitleViewWithTitle:@"好友请求"];
    
    _newFriendTableView                      = [[UITableView alloc] initWithFrame:CGRectMake(0, ViewOriginY, 320, ScreenHeight-ViewOriginY)];
    _newFriendTableView.delegate             = self;
    _newFriendTableView.dataSource           = self;
    _newFriendTableView.rowHeight            = 80;
    _newFriendTableView.separatorStyle       = UITableViewCellSeparatorStyleNone;
    _newFriendTableView.backgroundColor      = [UIColor clearColor];
    [self.view addSubview:_newFriendTableView];
    
    self.view.backgroundColor = RGB(242, 242, 242, 1.0f);
    
    
    [self search];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.tag = kMBProgressTag;
    [self.view addSubview:hud];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goback{
    [super goback];
    
    _newFriendTableView.delegate = nil;
    _newFriendTableView.dataSource = nil;
    _newFriendsArray = nil;
    
    ContactsViewController *cvc = (ContactsViewController*)[self.navigationController topViewController];
    [cvc search];
}


-(void)search{
    
    NSArray *array = [[BmobDB currentDatabase] queryBmobInviteList];
    if (array) {
        [_newFriendsArray setArray:array];
        
        [_newFriendTableView reloadData];
    }
    
    
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_newFriendsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[ContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        
        
    }
    
    [cell.addButton removeTarget:self action:@selector(agree:) forControlEvents:UIControlEventTouchUpInside];
    [cell.addButton setTitle:@"" forState:UIControlStateNormal];
    cell.statueLabel.text = nil;
    
    BmobInvitation *tmpInvitation = (BmobInvitation *)[_newFriendsArray objectAtIndex:indexPath.row];
    
    if (tmpInvitation.statue == STATUS_ADD_NO_VALIDATION) {
        cell.addButton.tag = indexPath.row;
        [cell.addButton addTarget:self action:@selector(agree:) forControlEvents:UIControlEventTouchUpInside];

        [cell.addButton setTitle:@"同意" forState:UIControlStateNormal];
    }else{
        cell.statueLabel.text = @"已同意";
    }
    
    
    
    
    cell.nameLabel.text = tmpInvitation.fromname;
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark agree

-(void)agree:(UIButton*)sender{
    
    MBProgressHUD *hud = (MBProgressHUD *)[self.view viewWithTag:kMBProgressTag];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"已同意添加好友";
    [hud show:YES];
    [hud hide:YES afterDelay:10.0f];
    
    BmobInvitation *tmpInvitation = (BmobInvitation *)[_newFriendsArray objectAtIndex:sender.tag];
    

    
    [[BmobUserManager currentUserManager] agreeAddContactWithInvitation:tmpInvitation block:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [hud hide:YES afterDelay:0.7f];
            [[BmobDB currentDatabase] updateAgreeMessage:tmpInvitation.fromname];
            tmpInvitation.statue = STATUS_ADD_AGREE;
            [_newFriendTableView reloadData];
        }else{
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [[error userInfo] objectForKey:@"error"];
            [hud hide:YES afterDelay:0.7f];
        }
    }];
    
}

@end
