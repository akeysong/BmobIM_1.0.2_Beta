//
//  LocateViewController.m
//  BmobIMDemo
//
//  Created by Bmob on 14-7-21.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import "LocateViewController.h"
#import "BMapKit.h"
#import "CommonUtil.h"
#import "ChatViewController.h"

@interface LocateViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>{
    BMKMapView                  *_mapView;     //百度地图
    BMKLocationService          *_locService;  //定位
    BMKGeoCodeSearch            *_geocodesearch;//地理编码
    CLLocationCoordinate2D      _currentLocationCoordinate2D;//当前百度坐标
    NSMutableString             *_addressString;//当前地理位置
}
@end

@implementation LocateViewController

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
        self.navigationItem.titleView  = [CommonUtil navigationTitleViewWithTitle:@"位置"];
        _addressString = [[NSMutableString alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *rightButton                  = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame                      = CGRectMake(0, 0, 50, 44);
    [[rightButton titleLabel] setFont:[UIFont systemFontOfSize:15]];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem             = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    ;
    //地图
    _mapView                   = [[BMKMapView alloc] init];
    _mapView.frame             = CGRectMake(0, ViewOriginY, 320, ScreenHeight - ViewOriginY);
    _mapView.zoomLevel         = 15.0f;
    [self.view addSubview:_mapView];

    //定位服务
    _locService                = [[BMKLocationService alloc]init];
    _locService.delegate       = self;
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode  = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
    
    //geo
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _currentLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0);
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate       = self;
    _geocodesearch.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate       = nil;
    _geocodesearch.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goback{
    [_locService stopUserLocationService];
    _locService.delegate = nil;
    [super goback];
}

-(void)dealloc{
    
}

-(void)send{
    [self goback];
    ChatViewController *tmpCvc = (ChatViewController *)[self.navigationController topViewController];
    [tmpCvc location:_currentLocationCoordinate2D address:_addressString];
    _addressString = nil;
}

- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation{
    [_mapView updateLocationData:userLocation];
    [_locService stopUserLocationService];
    //现在的坐标
    CLLocationCoordinate2D coor                         = [[userLocation location] coordinate];
    _currentLocationCoordinate2D                        = coor;
    //反geo地理编码
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint          = coor;
    [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher
                           result:(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        if (result.address) {
            [_addressString setString:result.address];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }
    
}

@end
