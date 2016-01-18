//
//  Search ViewController.m
//  BmobIMDemo
//
//  Created by Bmob on 14-6-26.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import "SearchViewController.h"
#import "CommonUtil.h"
#import <BmobIM/BmobUserManager.h>
#import <BmobIM/BmobChatManager.h>
#import "ContactTableViewCell.h"
#import "MBProgressHUD.h"
@interface SearchViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
    UITableView         *_contactsTableView;
    NSMutableArray      *_contactsArray;
}

@end

@implementation SearchViewController

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
        _contactsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.titleView          = [CommonUtil navigationTitleViewWithTitle:@"搜索联系人"];

    UIImageView  *loginBackgroundImageView = [[UIImageView alloc] init];
    loginBackgroundImageView.frame         = CGRectMake(0,  ViewOriginY+10, 320, 40);
    loginBackgroundImageView.image         = [[UIImage imageNamed:@"login_input"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [self.view addSubview:loginBackgroundImageView];

    UITextField *searchTextField           = [[UITextField alloc] initWithFrame:CGRectMake(10, ViewOriginY+10, 300, 40)];
    searchTextField.delegate               = self;
    searchTextField.placeholder            = @"搜索";
    searchTextField.returnKeyType          = UIReturnKeySearch;
    [self.view addSubview:searchTextField];

    _contactsTableView                      = [[UITableView alloc] initWithFrame:CGRectMake(0, ViewOriginY+50, 320, ScreenHeight-ViewOriginY-50)];
    _contactsTableView.delegate             = self;
    _contactsTableView.dataSource           = self;
    _contactsTableView.rowHeight            = 45;
    _contactsTableView.separatorStyle       = UITableViewCellSeparatorStyleNone;
    _contactsTableView.backgroundColor      = [UIColor clearColor];
    [self.view addSubview:_contactsTableView];
    
    self.view.backgroundColor = RGB(242, 242, 242, 1.0f);
    
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
    _contactsTableView.delegate   = nil;
    _contactsTableView.dataSource = nil;
    _contactsArray                = nil;
    
    [super goback];
}

#pragma mark some action

-(void)searchContact:(UITextField*)textField{
    
    [[BmobUserManager currentUserManager] queryUserByName:textField.text block:^(NSArray *array, NSError *error) {
        if (array) {
            [_contactsArray setArray:array];
            [_contactsTableView reloadData];
        }
    }];
    
    [self.view endEditing:YES];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchContact:textField];
    
    return YES;
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_contactsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[ContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = RGB(242, 242, 242, 1.0f);
        cell.backgroundColor = RGB(242, 242, 242, 1.0f);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.lineImageView.image = [UIImage imageNamed:@"common_line"];
    BmobObject *obj =(BmobObject*) [_contactsArray objectAtIndex:indexPath.row];
    
    cell.addButton.tag = indexPath.row;
    [cell.addButton addTarget:self action:@selector(addFriendRequest:) forControlEvents:UIControlEventTouchUpInside];
    [cell.addButton setTitle:@"添加好友" forState:UIControlStateNormal];
    cell.nameLabel.text = [obj objectForKey:@"username"];
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark add friend

-(void)addFriendRequest:(UIButton*)sender{
    MBProgressHUD *hud =(MBProgressHUD*) [self.view viewWithTag:kMBProgressTag];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"添加好友中";
    [hud show:YES];
    [hud hide:YES afterDelay:10.0f];
    
    BmobObject *obj =(BmobObject*) [_contactsArray objectAtIndex:sender.tag];
   
    [[BmobChatManager currentInstance] sendMessageWithTag:TAG_ADD_CONTACT targetId:obj.objectId block:^(BOOL isSuccessful, NSError *error) {
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
