//
//  LocationViewController.h
//  BmobIMDemo
//
//  Created by Bmob on 14-7-14.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import "NextViewController.h"
#import <BmobSDK/Bmob.h>
#import <MapKit/MapKit.h>

@interface LocationViewController : NextViewController<MKMapViewDelegate>



-(instancetype)initWithLocationArray:(NSArray *)array;



@end
