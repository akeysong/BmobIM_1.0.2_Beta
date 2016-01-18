//
//  NearbyViewController.m
//  BmobIMDemo
//
//  Created by Bmob on 14-7-25.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import "NearbyViewController.h"
#import "BmobIMDemoConfig.h"

@interface NearbyViewController ()<UITableViewDelegate,UITableViewDataSource>{
    Location                *_shareLocation;
    NSMutableArray          *_nearMutableArray;
    NSDateFormatter         *_dateFormatter;
    UITableView             *_nearTableView;
    UIRefreshControl        *_refreshControl;
}
@end

@implementation NearbyViewController

#pragma mark - life Cycle

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
        _nearMutableArray = [[NSMutableArray alloc] init];
        _dateFormatter    = [[NSDateFormatter alloc] init];
        [_dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
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
    
    self.navigationItem.titleView = [CommonUtil navigationTitleViewWithTitle:@"附近的人"];
    
    _nearTableView            = [[UITableView alloc] init];
    _nearTableView.frame      = CGRectMake(0, ViewOriginY, 320, ScreenHeight-ViewOriginY);
    _nearTableView.dataSource = self;
    _nearTableView.delegate   = self;
    _nearTableView.rowHeight  = 80;
    _nearTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_nearTableView];

    //
    _shareLocation            = [Location shareInstance];
    [_shareLocation startUpdateLocation];
    [self performSelector:@selector(startLocate) withObject:nil afterDelay:0.7f];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.tag            = kMBProgressTag;
    [self.view addSubview:hud];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(startLocate) forControlEvents:UIControlEventValueChanged];
    [_nearTableView addSubview:_refreshControl];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
   
}

-(void)goback{
    [super goback];
    _nearTableView.dataSource = nil;
    _nearTableView.delegate   = nil;
    _nearMutableArray         = nil;
    
}

#pragma mark location

-(void)startLocate{
    
    MBProgressHUD *hud =(MBProgressHUD*) [self.view viewWithTag:kMBProgressTag];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"搜索中...";
    [hud show:YES];
    [hud hide:YES afterDelay:10.0f];
    
    CLLocationCoordinate2D coor = _shareLocation.currentLocation;
    BmobGeoPoint    *point      = [[BmobGeoPoint alloc] initWithLongitude:coor.longitude WithLatitude:coor.latitude];
    BmobUserManager *manager    = [BmobUserManager currentUserManager];

    NSLog(@"longitude %f, latitude %f",coor.longitude,coor.latitude);
    
    [manager queryNearbyWithKey:@"location" location:point page:0 block:^(NSArray *array, NSError *error) {
        [_refreshControl endRefreshing];
        if (error) {
            hud.mode = MBProgressHUDModeText;
            hud.labelText =[[error userInfo] objectForKey:@"error"];
            [hud hide:YES afterDelay:0.7f];
        }else{
            [_nearMutableArray removeAllObjects];
            hud.mode = MBProgressHUDModeText;
            hud.labelText =@"搜索完成";
            [hud hide:YES afterDelay:0.7f];
            for (BmobObject *obj in array) {
                NearInfo *tmpNearInfo           = [[NearInfo alloc] init];
                tmpNearInfo.name                = [obj objectForKey:@"username"];
                tmpNearInfo.avatarString        = [obj objectForKey:@"avatar"];
                tmpNearInfo.lastTime            = [_dateFormatter stringFromDate:obj.updatedAt];
                BmobGeoPoint *point             = (BmobGeoPoint *)[obj objectForKey:@"location"];
                CLLocationCoordinate2D bmobCoor = CLLocationCoordinate2DMake(point.latitude, point.longitude);
                tmpNearInfo.distance            = [NSString stringWithFormat:@" %.0f米",[CommonUtil distanceBetweenCoordinate2D:coor coordinate2D1:bmobCoor]];
                tmpNearInfo.objectId            = obj.objectId;
                [_nearMutableArray addObject:tmpNearInfo];
            }
            [_nearTableView reloadData];
            [_shareLocation stopUpateLoaction];
        }
        
    }];
}



#pragma mark - UITableView Datasource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_nearMutableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellID";
    NearbyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[NearbyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NearInfo *tmpNearInfo    = (NearInfo *)[_nearMutableArray objectAtIndex:indexPath.row];
    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:tmpNearInfo.avatarString] placeholderImage:[UIImage imageNamed:@"setting_head"]];
    cell.nameLabel.text      = tmpNearInfo.name;
    cell.distanceLabel.text  = tmpNearInfo.distance;
    cell.lastTimeLabel.text  = [NSString stringWithFormat:@"最后登录时间:%@",tmpNearInfo.lastTime];
    cell.lineImageView.image = [UIImage imageNamed:@"common_line"];
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     NearInfo *tmpNearInfo    = (NearInfo *)[_nearMutableArray objectAtIndex:indexPath.row];
    [self goPersonalProfileViewController:tmpNearInfo];
}


-(void)goPersonalProfileViewController:(NearInfo *)info{
    PersonalProfileViewController *ppvc = [[PersonalProfileViewController alloc] initWithInfomation:info];
    [self.navigationController pushViewController:ppvc animated:YES];
}

@end
