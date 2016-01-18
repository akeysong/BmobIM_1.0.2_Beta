//
//  LocationViewController.m
//  BmobIMDemo
//
//  Created by Bmob on 14-7-14.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import "LocationViewController.h"
#import "BMapKit.h"
#import "CommonUtil.h"
@interface LocationViewController ()<BMKLocationServiceDelegate,BMKMapViewDelegate>{
   
}


@property (strong, nonatomic) BMKMapView *mapView;
@property (strong, nonatomic) NSArray   *infoArray;
@end

@implementation LocationViewController
@synthesize mapView = _mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(instancetype)initWithLocationArray:(NSArray *)array{
    self = [super init];
    if (self) {
        self.infoArray = array;
        self.navigationItem.titleView = [CommonUtil navigationTitleViewWithTitle:@"定位"];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _mapView                   = [[BMKMapView alloc] init];
    _mapView.frame             = CGRectMake(0, ViewOriginY, 320, ScreenHeight - ViewOriginY);
    _mapView.zoomLevel         = 14.0f;
    [self.view addSubview:_mapView];
     _mapView.delegate = self;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    if (!_mapView.delegate) {
         _mapView.delegate = self;
    }
   
    
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([[self.infoArray objectAtIndex:1] doubleValue], [[self.infoArray objectAtIndex:2] doubleValue]);
    _mapView.centerCoordinate   = coor;
    [_mapView removeAnnotations:_mapView.annotations];
    BMKPointAnnotation* item    = [[BMKPointAnnotation alloc]init];
    item.coordinate             = coor;
    item.title = self.infoArray[0];
    [_mapView addAnnotation:item];

}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    [self.mapView setDelegate:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goback{
    [super goback];
    self.mapView = nil;
    
}


- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation{

    NSString *AnnotationViewID = @"annotationViewID";
	//根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKAnnotationView *annotationView =[view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
   
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
		((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
		((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
	
	annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
	annotationView.canShowCallout = TRUE;
    annotationView.selected = YES;
    return annotationView;
}


#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]


- (NSString*)getMyBundlePath1:(NSString *)filename {
	
	NSBundle * libBundle = MYBUNDLE ;
	if ( libBundle && filename ){
		NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
		return s;
	}
	return nil ;
}

@end
