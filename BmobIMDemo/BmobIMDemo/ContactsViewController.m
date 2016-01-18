//
//  ContactsViewController.m
//  BmobIMDemo
//
//  Created by Bmob on 14-6-25.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import "ContactsViewController.h"
#import "BmobIMDemoConfig.h"
#import "Location.h"
#import "BMapKit.h"
//#import <BmobIM/BmobIM.h>


@interface ContactsViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView         *_friendTableView;
    NSMutableArray      *_friendsArray;
}

@end

@implementation ContactsViewController

#pragma mark life cycle

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
        
        _friendsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [CommonUtil navigationTitleViewWithTitle:@"联系人"];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 50, 44);
    [rightBtn setImage:[UIImage imageNamed:@"contact_add"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"contact_add_"] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(addContact) forControlEvents:UIControlEventTouchUpInside];
    if (IS_iOS7) {
        [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    }
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self performSelector:@selector(setupViewS) withObject:nil afterDelay:0.1f];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self performSelector:@selector(search) withObject:nil afterDelay:0.5f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark some action



-(void)search{
    NSArray *array = [[BmobDB currentDatabase] contaclList];
    
    if (array) {
        [_friendsArray setArray:array];
        
        [_friendTableView reloadData];
    }
}

-(void)addContact{
    SearchViewController *svc = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
}


-(void)setupViewS{

    _friendTableView                = [[UITableView alloc] init];
    _friendTableView.frame          = CGRectMake(0, ViewOriginY, 320, ScreenHeight-64-49);
    _friendTableView.dataSource     = self;
    _friendTableView.delegate       = self;
    _friendTableView.rowHeight      = 80;
    _friendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_friendTableView];
    
    [self initTableViewHeaderView];
}

-(void)initTableViewHeaderView{
    //消息头部
    UIView *headerView                    = [[UIView alloc] init];
    headerView.frame                      = CGRectMake(0, 0, 320, 140);
    //好友通知
    ContactHeaderView *friendView         = [[ContactHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    friendView.iconImageView.image        = [UIImage imageNamed:@"message_icon"];
    friendView.titleLabel.text            = @"好友通知";
    friendView.lineImageView.image        = [UIImage imageNamed:@"common_line"];
    friendView.arrowImageView.image =[UIImage imageNamed:@"common_jt"];
    [headerView addSubview:friendView];
    friendView.userInteractionEnabled     = YES;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goNewFriends:)];
    [friendView addGestureRecognizer:tapRecognizer];
    
    //附近的人
    ContactHeaderView *nearbyView         = [[ContactHeaderView alloc] initWithFrame:CGRectMake(0, 70, 320, 70)];
    nearbyView.iconImageView.image        = [UIImage imageNamed:@"message_icon"];
    nearbyView.titleLabel.text            = @"附近的人";
    nearbyView.lineImageView.image        = [UIImage imageNamed:@"common_line"];
    nearbyView.arrowImageView.image       =[UIImage imageNamed:@"common_jt"];
    [headerView addSubview:nearbyView];
    nearbyView.userInteractionEnabled     = YES;
    UITapGestureRecognizer *tapNearbyRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goNearby:)];
    [nearbyView addGestureRecognizer:tapNearbyRecognizer];
    
    
    [_friendTableView setTableHeaderView:headerView];
}


-(void)goNewFriends:(UITapGestureRecognizer*)gesture{
    NewFriendViewController *nfvc = [[NewFriendViewController alloc] init];
    [self.navigationController pushViewController:nfvc animated:YES];
}

-(void)goNearby:(UITapGestureRecognizer *)gesture{
    NearbyViewController *nvc = [[NearbyViewController alloc] init];
    [self.navigationController pushViewController:nvc animated:YES];
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_friendsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    RecentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[RecentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    BmobChatUser *user = (BmobChatUser *)[_friendsArray objectAtIndex:indexPath.row];
    if (user.avatar) {
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"setting_head"]];
    }
    cell.nameLabel.text = user.username;
    cell.lineImageView.image = [UIImage imageNamed:@"common_line"];
    return cell;
}

#pragma mark - UITableView Delegate methods

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{

    return UITableViewCellEditingStyleDelete;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteContact:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self chatWithSB:indexPath];
}

#pragma mark some action about chatuser
-(void)chatWithSB:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
    BmobChatUser *user = (BmobChatUser *)[_friendsArray objectAtIndex:indexPath.row];
    [infoDic setObject:user.objectId forKey:@"uid"];
    [infoDic setObject:user.username forKey:@"name"];
    if (user.avatar) {
        [infoDic setObject:user.avatar forKey:@"avatar"];
    }
    if (user.nick) {
        [infoDic setObject:user.nick forKey:@"nick"];
    }
    ChatViewController *cvc = [[ChatViewController alloc] initWithUserDictionary:infoDic];
    [self.navigationController pushViewController:cvc animated:YES];
    
}

-(void)deleteContact:(NSIndexPath *)indexPath{
    BmobChatUser *user = (BmobChatUser *)[_friendsArray objectAtIndex:indexPath.row];
    [[BmobDB currentDatabase] deleteContactWithUid:user.objectId];
    [[BmobDB currentDatabase] deleteMessagesWithUid:user.objectId];
    [[BmobDB currentDatabase] deleteRecentWithUid:user.objectId];
    [[BmobUserManager currentUserManager] deleteContactWithUid:user.objectId block:^(BOOL isSuccessful, NSError *error) {
        
    }];
    
    [_friendsArray removeObject:user];
    [_friendTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

@end
