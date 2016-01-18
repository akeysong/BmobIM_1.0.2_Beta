//
//  RecentViewController.m
//  BmobIMDemo
//
//  Created by Bmob on 14-6-25.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import "RecentViewController.h"
#import "CommonUtil.h"
#import <BmobSDK/Bmob.h>
#import <BmobIM/BmobDB.h>
#import "ChatViewController.h"
#import "RecentTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Location.h"
#import "BMapKit.h"

@interface RecentViewController ()<UITableViewDataSource,UITableViewDelegate,LocationDelegate>{

    UITableView         *_chatTableView;
    NSMutableArray      *_chatsArray;
    BOOL                _isUpdateLocation;
}

@end

@implementation RecentViewController

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
        
        _chatsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [CommonUtil navigationTitleViewWithTitle:@"会话"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _chatTableView                = [[UITableView alloc] init];
    _chatTableView.frame          = CGRectMake(0, ViewOriginY, 320, ScreenHeight-64-49);
    _chatTableView.dataSource     = self;
    _chatTableView.delegate       = self;
    _chatTableView.rowHeight      = 80;
    _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_chatTableView];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    BmobUser *user = [BmobUser getCurrentUser];
    if (!user) {
        [CommonUtil needLoginWithViewController:self animated:YES];
    }else{
        [self performSelector:@selector(search) withObject:nil afterDelay:0.7f];
        if (!_isUpdateLocation) {
            [self performSelector:@selector(updateLocation) withObject:nil afterDelay:0.7f];
        }
    }

}

-(void)updateLocation{
    
    [Location shareInstance].delegate = self;
    [[Location shareInstance] startUpdateLocation];
    
    
    
}

-(void)didUpdateLocation:(Location *)loc{
    BmobUser *user = [BmobUser getCurrentUser];
    if (user) {
        
        CLLocationDegrees longitude     = [[Location shareInstance] currentLocation].longitude;
        CLLocationDegrees latitude      = [[Location shareInstance] currentLocation].latitude;
        CLLocationCoordinate2D gpsCoor  = CLLocationCoordinate2DMake(latitude, longitude);
        //百度坐标
        CLLocationCoordinate2D bmapCoor = BMKCoorDictionaryDecode(BMKConvertBaiduCoorFrom(gpsCoor,BMK_COORDTYPE_GPS));
        BmobGeoPoint *location          = [[BmobGeoPoint alloc] initWithLongitude:bmapCoor.longitude WithLatitude:bmapCoor.latitude];
        [user setObject:location forKey:@"location"];
        //结束定位
        [[Location shareInstance] stopUpateLoaction];
        [Location shareInstance].delegate = nil;
        //更新定位
        [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                _isUpdateLocation = YES;
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)search{
    NSArray *array = [[BmobDB currentDatabase] queryRecent];
    
    if (array) {
        
        [_chatsArray setArray:array];
        [_chatTableView reloadData];
    
        
    }
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_chatsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    RecentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[RecentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    BmobRecent *recent = (BmobRecent *)[_chatsArray objectAtIndex:indexPath.row];
    
    if (recent.avatar) {
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:recent.avatar] placeholderImage:[UIImage imageNamed:@"setting_head"]];
    }
    
    cell.nameLabel.text      = recent.targetName;
    cell.messageLabel.text   = recent.message;
    cell.lineImageView.image = [UIImage imageNamed:@"common_line"];
    
    return cell;
}

#pragma mark - UITableView Delegate methods

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteChat:indexPath];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self chatWithSB:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)chatWithSB:(NSIndexPath *)indexPath{
    BmobRecent *recent = (BmobRecent *)[_chatsArray objectAtIndex:indexPath.row];
    
    NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
    
    [infoDic setObject:recent.targetId forKey:@"uid"];
    [infoDic setObject:recent.targetName forKey:@"name"];
    
    if (recent.nick) {
        [infoDic setObject:recent.nick forKey:@"nick"];
    }
    
    if (recent.avatar) {
        [infoDic setObject:recent.avatar forKey:@"avatar"];
    }
    
    
    ChatViewController *cvc = [[ChatViewController alloc] initWithUserDictionary:infoDic];
    [self.navigationController pushViewController:cvc animated:YES];
    
}


-(void)deleteChat:(NSIndexPath *)indexPath{
    
    BmobRecent *recent = (BmobRecent *)[_chatsArray objectAtIndex:indexPath.row];
    
    [[BmobDB currentDatabase] deleteRecentWithUid:recent.targetId];
    
    [_chatsArray removeObject:recent];
    [_chatTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    
    
}

@end
